-- Monitors and workspace pinning, keyed by EDID description.
--
-- WHY NOT CONNECTOR NAMES: they are not stable across dock re-plugs. These same
-- two Dell panels enumerated as DP-5 / DP-6 earlier on 2026-09-02 and as
-- DP-7 / DP-8 after a reconnect. Any rule written against a connector name
-- silently stops matching when the number shifts, which is what scrambles the
-- workspace layout on unplug/replug. `desc:` matches make/model/serial from the
-- EDID and survives reconnects.
--
-- Read the descriptions with:  hyprctl monitors all | grep description
-- Test a rule live with:       hyprctl eval 'hl.monitor({ ... })'
--   (`hyprctl keyword` does not work with a Lua config — it is legacy-parser only)

local LAPTOP  = "desc:BOE 0x0C3F"                       -- built-in, 1920x1200
local DELL_HE = "desc:Dell Inc. DELL P2425HE 9B43004"   -- external, middle
local DELL_H  = "desc:Dell Inc. DELL P2425H FTNJJ14"    -- external, right

-- Left to right: laptop, then the two externals chained with auto-right so the
-- chain collapses cleanly when one is unplugged.
hl.monitor({ output = LAPTOP,  mode = "preferred", position = "0x0",        scale = 1.25 })
hl.monitor({ output = DELL_HE, mode = "preferred", position = "auto-right", scale = 1.25 })
hl.monitor({ output = DELL_H,  mode = "preferred", position = "auto-right", scale = 1.25 })

-- Fallback for any monitor not listed above
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.25 })

-- Workspace pinning, by description for the same reason.
local pinned = {
    { "1", LAPTOP  }, { "2", LAPTOP  },
    { "3", DELL_HE }, { "4", DELL_HE },
    { "5", DELL_H  }, { "6", DELL_H  },
}

for _, w in ipairs(pinned) do
    hl.workspace_rule({
        workspace = w[1],
        monitor   = w[2],
        -- persistent = true,  -- uncomment to keep these workspaces alive while
        -- their monitor is away. Makes replug placement more deterministic, but
        -- all six then show permanently in waybar.
    })
end

-- Re-assert pinning on hotplug.
--
-- Workspace rules are only consulted when a workspace is CREATED. A workspace
-- that already exists and got pushed onto another screen while its monitor was
-- away does not travel back by itself when the monitor returns — that is the
-- behaviour that scrambles the layout on every dock cycle. This handler moves
-- the existing ones back.
--
-- Only workspaces that actually exist are touched; dispatching at one that does
-- not yet exist logs "Workspace not found". The delay gives the new output time
-- to settle before anything is moved onto it.
local function reassert_pinning()
    local want = {}
    for _, w in ipairs(pinned) do
        want[tonumber(w[1])] = w[2]
    end

    for _, ws in ipairs(hl.get_workspaces()) do
        local target = want[ws.id]
        if target then
            pcall(function()
                hl.dispatch(hl.dsp.workspace.move({ workspace = ws.id, monitor = target }))
            end)
        end
    end
end

hl.on("monitor.added", function()
    hl.timer(reassert_pinning, { timeout = 500, type = "oneshot" })
end)

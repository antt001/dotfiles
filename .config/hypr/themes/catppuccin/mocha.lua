-- Catppuccin Mocha palette for Hyprland
-- Generated from themes/catppuccin/mocha.conf during the hyprlang -> Lua migration.
-- Values are bare hex; use the helpers to build colour strings.
--   theme.rgb("mauve")        -> "rgb(cba6f7)"
--   theme.rgba("mauve", "ee") -> "rgba(cba6f7ee)"

local M = {
    rosewater    = "f5e0dc",
    flamingo     = "f2cdcd",
    pink         = "f5c2e7",
    mauve        = "cba6f7",
    red          = "f38ba8",
    maroon       = "eba0ac",
    peach        = "fab387",
    yellow       = "f9e2af",
    green        = "a6e3a1",
    teal         = "94e2d5",
    sky          = "89dceb",
    sapphire     = "74c7ec",
    blue         = "89b4fa",
    lavender     = "b4befe",
    text         = "cdd6f4",
    subtext1     = "bac2de",
    subtext0     = "a6adc8",
    overlay2     = "9399b2",
    overlay1     = "7f849c",
    overlay0     = "6c7086",
    surface2     = "585b70",
    surface1     = "45475a",
    surface0     = "313244",
    base         = "1e1e2e",
    mantle       = "181825",
    crust        = "11111b",
}

function M.rgb(name)
    return "rgb(" .. M[name] .. ")"
end

function M.rgba(name, alpha)
    return "rgba(" .. M[name] .. alpha .. ")"
end

return M

# Keybindings — CachyOS/Hyprland setup, and porting them to Omarchy

Source of truth for this machine: `.config/hypr/hyprland.lua` (Lua config).
Omarchy is still on **hyprlang** (`.conf` with `source =`), so the syntax differs
between the two machines even though both run Hyprland.

On Omarchy, put personal binds in **`~/.config/hypr/bindings.conf`**. Omarchy's
`hyprland.conf` sources its own defaults first and your file after, so anything
you set there wins. Never edit `~/.local/share/omarchy/default/...` — it is
overwritten on every update.

---

## My bindings

### Applications and session

| Keys | Action |
| --- | --- |
| `SUPER+Q` | Terminal (kitty) |
| `SUPER+E` | File manager (nautilus) |
| `SUPER+R` | App launcher (`rofi -show drun`) |
| `SUPER+C` | Close window |
| `SUPER+M` | Exit Hyprland |
| `SUPER+L` | Lock screen (hyprlock) |

### Window / tiling

| Keys | Action |
| --- | --- |
| `SUPER+V` | Toggle floating |
| `SUPER+F` | Fullscreen |
| `SUPER+U` | Pseudotile focused window |
| `SUPER+J` | Toggle split direction (dwindle) |
| `SUPER+←/→/↑/↓` | Move focus |
| `SUPER+LMB` drag | Move window |
| `SUPER+RMB` drag | Resize window |

### Workspaces

| Keys | Action |
| --- | --- |
| `SUPER+1`…`9`, `0` | Switch to workspace 1–10 |
| `SUPER+SHIFT+1`…`9`, `0` | Move window to workspace 1–10 |
| `SUPER+S` | Toggle special workspace `magic` |
| `SUPER+SHIFT+S` | Move window to special `magic` |
| `SUPER+scroll` | Next / previous workspace |

### Screenshots (hyprshot)

| Keys | Action |
| --- | --- |
| `SUPER+P` | Capture window |
| `SUPER+CTRL+P` | Capture whole output |
| `SUPER+SHIFT+P` | Capture region |

### Notifications (swaync)

| Keys | Action |
| --- | --- |
| `SUPER+N` | Toggle notification panel |
| `SUPER+SHIFT+N` | Toggle Do Not Disturb |

### Media and hardware keys

All are `locked` (work on the lock screen) and `repeating` where it makes sense.

| Key | Action |
| --- | --- |
| `XF86AudioRaiseVolume` / `LowerVolume` | `wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%±` (raise capped at 1.5) |
| `XF86AudioMute` | Mute output |
| `XF86AudioMicMute` | Mute input |
| `XF86MonBrightnessUp` / `Down` | `brightnessctl s 10%±` |
| `XF86AudioNext` / `Prev` | `playerctl next` / `previous` |
| `XF86AudioPlay` / `Pause` | `playerctl play-pause` |

---

## Conflicts with Omarchy defaults

These are the ones that matter — same key, different meaning. **Omarchy wins
unless you override.**

| Keys | Mine | Omarchy default | Note |
| --- | --- | --- | --- |
| `SUPER+C` | Close window | **Universal copy** (`sendshortcut CTRL+Insert`) | Omarchy closes with `SUPER+W` |
| `SUPER+V` | Toggle floating | **Universal paste** (`SHIFT+Insert`) | Omarchy floats with `SUPER+T` |
| `SUPER+L` | Lock screen | **Toggle workspace layout** | Omarchy locks with `SUPER+CTRL+L` |
| `SUPER+P` | Screenshot window | **Pseudotile** | Omarchy screenshots with `PRINT` |
| `SUPER+S` | Special ws `magic` | Scratchpad (`special:scratchpad`) | Same key, different workspace name |
| `SUPER+SHIFT+S` | Move to `magic` | *unbound* (Omarchy uses `SUPER+ALT+S`) | `SUPER+CTRL+S` is Omarchy's Share |

Identical in both, nothing to do: `SUPER+J`, `SUPER+F`, `SUPER+←/→/↑/↓`,
`SUPER+1..0`, `SUPER+SHIFT+1..0`, `SUPER+scroll`, `SUPER+LMB/RMB`.

Free on Omarchy, so my binds apply cleanly: `SUPER+Q`, `SUPER+E`, `SUPER+R`,
`SUPER+M`, `SUPER+U`, `SUPER+N`, `SUPER+SHIFT+N`, `SUPER+CTRL+P`,
`SUPER+SHIFT+P`.

### What I'd be giving up

Overriding `SUPER+C` / `SUPER+V` disables Omarchy's universal copy/paste, which
is one of its signature features — it sends `CTRL+Insert` / `SHIFT+Insert` so
the same keys copy and paste in terminals and GUI apps alike. Worth trying
before overriding.

Omarchy binds a lot that I have no equivalent for and that stays available:
`SUPER+SPACE` (walker launcher), `SUPER+TAB` / `SUPER+SHIFT+TAB` (cycle
workspaces), `SUPER+SHIFT+arrows` (swap window), `ALT+TAB` (cycle windows),
`SUPER+G` (window groups), `SUPER+ESCAPE` (system menu), `SUPER+K` (show all
keybindings — use this on the new machine), and the whole `SUPER+CTRL+…` menu
family.

---

## Ready-to-paste `~/.config/hypr/bindings.conf` for Omarchy

Everything is commented; delete the blocks you do not want. `unbind` is only
needed to remove an Omarchy default without replacing it.

```bash
# ---- Applications (all free on Omarchy) ----
bindd = SUPER, Q, Terminal, exec, kitty
bindd = SUPER, E, File manager, exec, nautilus
bindd = SUPER, R, App launcher, exec, rofi -show drun
bindd = SUPER, M, Exit Hyprland, exit,

# ---- Notifications: swaync keys, mapped onto Omarchy's mako ----
# Omarchy uses mako, not swaync. Nearest equivalents:
bindd = SUPER, N, Dismiss last notification, exec, makoctl dismiss
bindd = SUPER SHIFT, N, Dismiss all notifications, exec, makoctl dismiss --all

# ---- Window control: restores my muscle memory ----
# CONFLICT: these disable Omarchy's universal copy/paste. Comment out to keep it.
bindd = SUPER, C, Close window, killactive,
bindd = SUPER, V, Toggle floating, togglefloating,

# CONFLICT: Omarchy has SUPER+L on workspace layout, lock on SUPER+CTRL+L
bindd = SUPER, L, Lock screen, exec, omarchy-system-lock

# CONFLICT: Omarchy has SUPER+P on pseudotile
bindd = SUPER, U, Pseudotile, pseudo,
bindd = SUPER, P, Screenshot window, exec, omarchy-capture-screenshot windows
bindd = SUPER CTRL, P, Screenshot output, exec, omarchy-capture-screenshot fullscreen
bindd = SUPER SHIFT, P, Screenshot region, exec, omarchy-capture-screenshot region
# (omarchy-capture-screenshot takes smart|region|windows|fullscreen — verified
#  against its own --args header, not guessed)

# ---- Scratchpad under my name ----
# Omarchy's scratchpad workspace is called "scratchpad", not "magic".
# Easiest is to keep Omarchy's name and just add the move bind I'm used to:
bindd = SUPER SHIFT, S, Move window to scratchpad, movetoworkspacesilent, special:scratchpad
```

Media keys need nothing: Omarchy already binds all of them, wrapped in swayosd
so they show an on-screen indicator, which is an upgrade over raw `wpctl` /
`brightnessctl`.

---

## Syntax notes when moving between the two machines

| | This machine | Omarchy |
| --- | --- | --- |
| Config format | Lua (`hyprland.lua`) | hyprlang (`.conf`, `source =`) |
| Bind syntax | `hl.bind("SUPER + Q", hl.dsp.exec_cmd("kitty"))` | `bindd = SUPER, Q, Terminal, exec, kitty` |
| Flags | options table: `{ locked = true, repeating = true }` | letters on the keyword: `bindeld` = repeat + locked + description |
| Inspect live | `hyprctl binds` shows `dispatcher: __lua`, so match on `key:` / `modmask:` (64 = SUPER, 65 = SUPER+SHIFT) | `hyprctl binds` shows real dispatchers; or `SUPER+K` |
| Change a setting live | `hyprctl eval 'hl.config({...})'` (`hyprctl keyword` is refused) | `hyprctl keyword ...` works |

Omarchy writes workspace binds as `code:10`–`code:19` rather than `1`–`0`.
That is keycode-based and so independent of the active keyboard layout — worth
copying if I ever see binds misbehave while the Hebrew or Russian layout is
active.

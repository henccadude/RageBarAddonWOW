# RageBarAddon

**Version:** 1.0  
**Game:** World of Warcraft Forever (Interface `16001`)  
**Author:** Pyörätuoli Jouni

RageBarAddon displays your character's current Rage in a movable status bar. You can customize its appearance in-game, and your settings are saved between UI reloads.

## Installation

1. Copy the `RageBarAddon` folder into your game's `Interface/AddOns/` directory. For the Forever client, the path is typically `World of Warcraft/_forever_/Interface/AddOns/RageBarAddon/`.
2. Make sure **RageBarAddon** is enabled in the game's AddOns menu.
3. Log in to your character, or type `/reload` in chat if you have just updated the addon.

## Using the Rage Bar

- **Rage display:** Shows your current and maximum Rage, such as `75 / 100`.
- **Move the bar:** Unlock it, hold **Shift**, and drag the bar with the **left mouse button**.
- **L/U button:** Click to lock or unlock the bar. **L** (red) means locked; **U** (green) means unlocked.
- **S button:** Click to open or close the settings panel.

## Settings

Open the settings panel with the **S** button or the `/rgbsettings` chat command.

| Setting | Description |
| --- | --- |
| **Width** | Adjust the bar width from 100 to 400. |
| **Height** | Adjust the bar height from 10 to 50. |
| **Red / Blue / Green** | Choose one of three preset bar colors. |
| **Show Buttons** | Show or hide the **L/U** and **S** buttons next to the bar. |
| **Close** | Close the settings panel. |

> **Important:** If you turn off **Show Buttons**, the **S** button will also disappear. Type `/rgbsettings` in chat to reopen the panel and enable the buttons again.

## Chat Commands

| Command | Description |
| --- | --- |
| `/rgbsettings` | Open or close the settings panel. |
| `/rgblock` | Lock the bar in place. |
| `/rgbunlock` | Unlock the bar so it can be moved. |
| `/rgbreset` | Reset the bar to its default position. |
| `/debug on` | Enable debug logging. |
| `/debug off` | Disable debug logging. |
| `/debug status` | Show the current debug logging status. |
| `/debug help` | Show the debug command help. |

## Saving Your Settings

The bar's position, lock state, size, color, and button visibility are saved automatically using World of Warcraft's **SavedVariables** system (`RageBarAddonDB`). They are restored when the addon loads.

## Troubleshooting

- **I cannot move the bar:** Unlock it using the **L/U** button or `/rgbunlock`, then hold **Shift** while dragging with the left mouse button.
- **The buttons have disappeared:** Type `/rgbsettings` and enable **Show Buttons**.
- **The bar is in the wrong place:** Type `/rgbreset` to restore its default position.
- **The S button does not open settings:** Use `/rgbsettings` instead.
- **Changes are not appearing:** Try `/reload` and check that the addon is enabled.

## Compatibility

RageBarAddon was developed for the **World of Warcraft Forever** client. Compatibility with other World of Warcraft versions has not been verified.

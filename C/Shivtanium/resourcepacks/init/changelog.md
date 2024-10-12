# Shivtanium Changelog
This changelog contains changes made after Shivtanium version Beta 1.1.0.

## Beta 1.4.0 [build 35.3412]
- Added window resizing. This applies to all windows with the 3rd index of
  kernel window registery attributes being set to `1`. (Example: `001`)
  Supported programs: `systemb_explorer`, `systemb_console`
- The task bar now displays opened windows.
- Added system updates (Preview)
- Added a new embeddable script: `core\listSelectionUX.bat`
  This script handles dropdown/selection/context menus. More information is on
  the ![User Interface wiki](https://github.com/Shivter14/Shivtanium/wiki/UI).
- Added window minimizing & restoring.
  This uses the 2 new kernel functions:
  - `minimizeWindow   <PID>   <window>`
  - `restoreWindow    <PID>   <window>`
- The application launcher can now display installed programs in the left list.
  These programs can be BXF applications that will be compiled on first launch.
  Programs are located in `~\Shivtanium\Programs` as folders. A program folder
  must contain a `shivtanium.dat` file with metadata. More information:
  [Shivtanium Programs](https://github.com/Shivter14/Shivtanium/wiki/Programs)
- Added new resource pack: `discord_themes` - This resource pack contains
    themes from *Discord Nitro* ported to Shivtanium DWM themes which include:
    `mint_apple`, `citrus_sherbert`, `retro_raincloud`
- BXF applications compiled on first boot are now compiled with multi-threading.
- Added `sstoskrnldebugger.bat` - A simple batch file that streams kernel errors
  from `temp\kernelErr` to the console. Usefull for debugging.
- Added new system variable: `textMode` (Default value: `default` or undefined)
  This variable can force a custom text mode on startup, by an identifier.
  Text mode identifiers can be set with resource packs in file `textmodes.dat`.
- The boot screen now has a mode change instruction.
- Shivtanium can now change the font on startup.
  (if running with administrator privileges)
- Added command-line utilities: `clear`, `config`, `bxf` (now usable)
- Added a new function to `sys.bxf`: `@sys.call`
- Added kernel function: `modifyWindowProperties`
  Parameters: `WINDOW_ID  X  Y  [W]  [H]  [ATTRIB]`
- Added `conhost.exe` from Windows 10 to SSVM, and enabled forcing conhost as
  the terminal application. This has been done to completely eliminate problems
  on Windows 11 aswell as disabling all other incompatible terminals.
- Changes to the File Explorer:
  - It now supports loading icons from themes.
  - Added new file icons.
  - Changed the sidebar design a little.
- Changes to DWM:
  - Thememods located in resource pack `init` are now built-in and deleted from
    the resource pack. This does not mean that ThemeMods are deprecated.
  - Optimized memory usage, which now displays on the console's title.
  - Fixed issues with non-aero themes having issues with background filling.
  - The `Shivtanium` theme now has a gray background, making this a fully gray
    theme. The centering has also been fixed. It also doesn't contain the
	Shivtanium logo sprite, it now only points to it to reduce memory usage.
  - Fixed all issues with Windows 11.
  - DWM is now compiled with BXF.
  - Fixed issues with offloading & loading memory from files.
- Bugfixes:
  - Fixed error screen for "{Temp directory deletion}" freezing instead of
    showing a halt screen.
  - Made theme loading from external resource packs safer.
  - Fixed window centering issues for many programs. (off by 1 character)
  - Fixed the config API being unsafe with exclamation marks.
  - Fixed issues with the Git repository having BXF applications with Unix line
    endings (`LF`) instead of Windows line endings (`CRLF`) causing them to fail
    to compile. With that, the build on the Git repository is now fully stable.
  - *No GUI boot* causing an infinite black screen.
  - `systemb-control-panel`
    - Using deprecated variables (`sys.dir` instead of `sst.dir`) leading to
	  save fails.
    - Changing the user theme not saving changes.
  - `systemb-desktop` - Logging off not closing user's programs.
- The `systemb-desktop` task bar can be undocked. (recompiling required)
- BEFI boot menu rev4: Enhanced with `getInput64.dll` (Arrow keys & scrolling)

## Beta 1.3.2 [build 30.3229]
- All `systemb` applications are now compiled with BXF.
- Added a new function to `sys.bxf`: `@sys.onEventRaw`
- Task manager now only displays file names of running processes.
  (to reduce text length)
- Bugfixes:
  - BXF compiler issues with inline functions
  - `systemb-oobe` - issues selecting themes
  - Focused window's color not changing on auto-focusing after closing a window
  - `systemb-dialog` - not responding
- Changes to DWM:
  - Fixed many graphical issues on Windows 11 hosts.
  - Several themes have been updated to include unfocused colors.
  - Buffer splitting has been optimized.
  - Memory usage / environment size has been optimized.
- The desktop environment (`systemb-desktop`) has been updated:
  - The taskbar's color is now affected by the global theme.
  - The current focused window's title is now displayed on the taskbar
    instead of the window's ID.
- The application launcher doesn't have a window title bar.
  (Experimental DWM functionality)
- Added a new system variable: `windowManager` (Default value: `dwm.bat`)
  This variable contains the path to the window manager, which also means that
  custom window managers can be used. If you're experiencing issues with the new
  window manager, set this to: `dwm_fallback.bat`

## Beta 1.3.1 [24w33a]
- Added the BXF compiler - Batch Expanded Functions.
  This compiler can be used as an alternative to macros.
  Full documentation is at: [BXF Wiki](https://github.com/Shivter14/Shivtanium/wiki/BXF)
- BXF applications are automatically compiled on boot if they aren't compiled already.
- Added bootscreen modding support along with a new bootscreen.
  This bootscreen does a fade-in into the login BG theme.
- Fixed issues with VT breaking during startup animations
- Changes to the Desktop Window Manager (DWM):
  - Windows can have unfocused TI+TT colors.
  - Added ThemeMods: Themes that aren't full themes.
    These themes cannot be applied as global themes.
	They can be used to disable theme features. Examples:
	- `noCBUI.themeMod`
	- `noUnfocusedColors.themeMod`
	- `noWinAero.themeMod`
- The ESC key can now be used to clear the text input on login.
- Merged `systemb-launcher` into `systemb-desktop`.
- Changes to the kernel:
  - Added new switch: `/autorun <program> <parameters>`
    This switch can be used to run a process as an initial process.
	The process' PID will be 0.
  - Window position packets are no longer sent in realtime while the
    user is moving the window to improve performance This feature was
	previously present in `lowPerformanceMode`.
  - Fixed an annoying bug where if you hold your mouse button on a window's
    title bar without moving it, it would send out an undefine request for
	it's positions to all processes.
- Updated some legacy themes to use RGB colors instead of built-in
  3bpc colors for stability reasons.
- Optimized the file explorer. It is also compiled by the new BXF compiler on
  first boot.
- `systemb-dialog` is also compiled by the BXF compiler on first boot.

## Beta 1.3.0 [Milestone 3]
- The Control Panel customization page is now almost finished.
- Changes to the kernel:
  - Enabling `lowPerformanceMode` now changes every window's theme to `classic`
  - Keypresses are not sent when no window is focused.
- Changes to the Desktop Window Manager (DWM):
  - New theme variable: `winAero`;
    Aero themes can now have seperate aero math for windows.
  - Added new theme: `plex`. This theme uses the new change above.
- Added task manager. (More like a viewer atm)
- Added system update checks on startup.
- Added `systemb-oobe` - The Out-of-Box Experience. Features:
  - User profile setup
  - Font installation
  - Theme customization
- Added user profiles.
- Fixed kernel function `unRegisterWindow` not working correctly.
- Fixed Open-Source GitHub version of Shivtanium having some issues.
- Added new kernel subfunction to `powerState`: `fastReboot`
- BEFI bootloader revision 3 changelog:
  - Errorlevel `13` now does a reboot without exitting to SSVM.
- Fixed file/folder sorting in the File Explorer
  & added a folder icon to the title bar.
- Fixed focusing/input issues for many applications.

## Beta 1.2.3 [24w28c]
- File explorer now sorts files & directories properly.
- Added the Control Panel.
- Fixed calculator grabbing inputs when it's not focused.
- Added new system variables:
  - `reduceAnimations`:
    This variable disables animations like `lowPerformanceMode`,
    but it doesn't apply other `lowPerformanceMode` settings.
  - `loginBGtheme`:
    This is the theme applied to the Login screen's background.
  - `loginTheme`:
    This is the theme applied to the Login screen's window.
- Added buffer splitting into DWM.
- Changed the Application Launcher's layout.
- Removed the Interpreter for now. Might be added in the full release.

## Beta 1.2.2 [24w28b]
- Added VT100 (graphical) optimizations.
- BEFI boot menu revision 2; check the commit for more info.
- Added a config file: ~:\Shivtanium\settings.dat
  This file contains version info and the following new value:
- Added the following system value:
  'lowPerformanceMode'
  If this value is set to True.
  Some programs may use less animations,
  the default theme is set to 'classic',
  the Shell doesn't use animations,
  and newer programs will behave more suitably for lower-end computers.
- Added an automatic process exitting if the process exits without terminating
  the CMD session
- Removed remains of the Alpha stage interpreter.
- Added a Console/Terminal
  This is a simple terminal. It can run CMD commands,
  but it can break in many ways. This is just a demo.
- Optimized the calculator lmao.
- Spaced out the icons in the File Explorer.
  Thanks to MousieDev and Grub4K for the suggestion. (also optimized it)

## Beta 1.2.1 [24w28a]
- Added an application launcher. (start menu)
- Added a calculator. (yet again, but now with systemb)
- Added a file explorer.
- Optimized DWM.
- Optimized the Kernel.
- Fixed bugs.
- Fixed race conditions.

## Beta 1.2.0 [Milestone 2]
This release introduces the new Shivtanium OS Kernel; which
handles Mouse input, Keyboard input, Window management, and more.
The interpreter is currently disabled since it needs a partial re-write.
This also includes the updated Desktop Window Manager with better window moving.


## Milestone 2 Plans (finished)
- Finish the new Kernel.

## Milestone 3 Plans (finished)
- Give the Control Panel customization options.
- Add an Out-of-Box experience.
- Add a task manager.
- Add user profiles.

# Future plans

## Milestone 4 Plans
- Unfocusing windows changing colors
- The compiler with non-called functions (BXF)
- Window minimizing & restoring
- Resource packs (functionallity/concept)
- Fixing issues on Windows 11 + bugfixes & optimizations
- Window resizing

[current progress]

- Task bar
- System updates
- Installer

## Milestone 5 Plans
- Text viewer
- Notifications
- Multilanguism
- Sprite Viewer
- Resource Packs (full implementation + store)
- STORE

## Full release plans
- Window snapping
- Desktop items
- Better login screen
- Trailer
- Youtube videos
- Finish up the Wiki

## Post release plans
- Desktop items/files
- MetroTyper
- DOOM

### And those are the predictions for the future by Shivter.

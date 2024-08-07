== Shivtanium Changelog ==
This changelog contains changes made after Shivtanium version Beta 1.1.0.

# Beta 1.3.1 [24w32a]
- Added bootscreen modding support along with a new bootscreen.
- Fixed issues with VT breaking during startup animations
- Updated DWM theme format: Windows can have unfocused TI+TT colors.
- The ESC key can now be used to clear the text input on login.
- Merged `systemb-launcher` into `systemb-desktop`.

# Beta 1.3.0 [Milestone 3]
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

# Beta 1.2.3 [24w28c]
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

# Beta 1.2.2 [24w28b]
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
- Added an automatic process exitting if the process exits without terminating the CMD session
- Removed remains of the Alpha stage interpreter.
- Added a Console/Terminal
  This is a simple terminal. It can run CMD commands,
  but it can break in many ways. This is just a demo.
- Optimized the calculator lmao.
- Spaced out the icons in the File Explorer.
  Thanks to MousieDev and Grub4K for the suggestion. (also optimized it)

# Beta 1.2.1 [24w28a]
- Added an application launcher. (start menu)
- Added a calculator. (yet again, but now with systemb)
- Added a file explorer.
- Optimized DWM.
- Optimized the Kernel.
- Fixed bugs.
- Fixed race conditions.

# Beta 1.2.0 [Milestone 2]
This release introduces the new Shivtanium OS Kernel; which
handles Mouse input, Keyboard input, Window management, and more.
The interpreter is currently disabled since it needs a partial re-write.
This also includes the updated Desktop Window Manager with better window moving.


# Milestoen 2 Plans
- Finish the new Kernel.

# Milestone 3 Plans
- Give the Control Panel customization options.
- Add an Out-of-Box experience.
- Add a task manager.
- Add user profiles.

# Milestone 4 Plans
- Unfocusing windows should change colors if theme supports it.
[current progress]
- Add a game.
- Fully implement system updates.
- Text viewer.
- Implement window resizing.
- Create an installer.

# Milestone 5 Plans
- Add multilanguism.
- Sprite viewer.

# Full release plans
- Trailer
- Youtube videos
And that's the predictions for the future by Shivter.

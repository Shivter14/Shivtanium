<div align="center">

![Shivtanium Logo](https://raw.githubusercontent.com/Shivter14/Shivtanium/main/Shivtanium.png)
[![Release version](https://img.shields.io/github/v/release/Shivter14/Shivtanium?color=brightgreen&label=Latest%20version&style=for-the-badge)](https://github.com/Shivter14/Shivtanium/releases "Releases")
[![Commits](https://img.shields.io/github/commit-activity/m/Shivter14/Shivtanium?label=commits&style=for-the-badge)](https://github.com/Shivter14/Shivtanium/commits "Commit History")
[![Last Commit](https://img.shields.io/github/last-commit/Shivter14/Shivtanium/main?label=Latest%20commit&style=for-the-badge&display_timestamp=committer)](https://github.com/Shivter14/Shivtanium/pulse/monthly "Last activity")
## Shivtanium is the most advanced Batch OS Kernel, along with `systemb` making it the most advanced Batch OS ever created.

</div>

### How does it work?

Shivtanium runs *sub systems*. Like the Shivtanium Interpreter which can be used to safely create GUI applications.

These subsystems can run in parallel, and can communicate with each other.

Input is handled by the Shivtanium OS Kernel, which also handles:
- System shutdown
- Killing processes
- Starting processes
- Registering windows
- Moving windows

And much more...

Graphics & windows are handled by the Desktop Window Manager, which uses many kinds of VT sequences, optimizations, and all sorts of techniques to render windows quickly and smoothly.

More information about it can be found in the following sections and the ![DWM Wiki](https://github.com/Shivter14/Shivtanium/wiki/Desktop-Window-Manager).

### How does SSTFS work?
The Shivtanium interpreter uses a custom-written file system: SSTFS

That's the reason why you need a SSTFS file for it to work.

More information about it can be found on the ![SSTFS Wiki](https://github.com/Shivter14/Shivtanium/wiki/SSTFS)
## the Desktop Window Manager
Shivtanium uses a custom-made Desktop Window Manager to render windows with themes.
These themes can be customized with *resource packs*
Yes, Shivtanium has a resource pack format.

Creating themes requires VT100 knowledge.

The format is easy to understand just by looking at a theme located in: `C\Shivtanium\resourcepacks\init\themes\`

* To modify the window button controls, change the `CBUI` value which should add 9 characters. If more are needed, `\e[#E` can be used to push the cursor back # characters.
* For more help, head to the ![DWM Wiki](https://github.com/Shivter14/Shivtanium/wiki/Desktop-Window-Manager).
* Making *aero* themes will be described on the ![wiki](https://github.com/Shivter14/Shivtanium/wiki) soon.

It's even easier to create sprites, it's just raw ASCII art located in: `C\Shivtanium\resourcepacks\init\sprites\`
The sprite loader automatically detects and assigns the width of sprites while loading.
## Customization
The display dimensions can be changed in `ssvm.cww` value `mode`.

The OS name seen in SSVM can be changed in `C\SSVM.cww`.

And of course, the `ShivtaniumOS.sstfs` filesystem can be modified with knowledge of the Shivtanium Programming Language.
### Keyboard & typing
Shivtanium uses a keyboard layout system, where the keyboard layout is a batch file located in the resource pack:
`keyboard_init.bat`
This batch file may contain 3 variable definitions:
- `charset_L` - Lower case (keycode -> Character)
- `charset_U` - Upper case (Shift + keycode -> Upper case character)
- `charset_A` - Alternative (Alt + keycode -> Alternative character)

> The variable definitions are long strings containing all the possible characters that can be input.

> You can get a character from a character set using the following expansion method: `!charset_#:~<keycode>,1!`

> Keycode is a keyboard key value from WinAPI (used in: getInput64.dll, cmdwiz.exe, getInput.exe)

Example: `A` is pressed without `Shift` nor `Alt`;
- Keycode of `A` is 65.
- `!charset_L:~65,1!`

Modifying the keyboard layout can be done in the following way:
* Open the `keyboard_init.bat` file in the specified resource pack (default: `init`)
* Change one of the character sets (`charset_L` - Lower case, `charset_U` - Upper case, `charset_A` - Alternative)
* To *re-bind* a key to a different character, find the character, and replace it with a different one.
* To *bind a key by its keycode*, change the character at the position based on the keycode (Example: Keycode of `F1` is 112; go to the 112th place)

## How can I write `.sst` applications for Shivtanium?
Applications are written in the Shivtanium Subsystem which is interpreted.

This language has a `command<tab>parameters` syntax. Parameters aren't enclosed with quotes, instead, they are separated by `<tab>`

Code examples:
```
math  1
nocap  The 'math' command works very similarly to 'set /a' in batch. It outputs the result into the `return` variable
nocap  << this is a command for comments. It does exactly nothing.
:main
if  1  ==  1
  nocap  This is a comment.
if  $return$  >  3
  exit
goto  main
```

## How can I create interactive batch scripts compatible with Shivtanium?

With help from the Shivtanium Kernel;

Information about creating applications for Shivtanium can be found on the ![Kernel Wiki](https://github.com/Shivter14/Shivtanium/wiki/kernel). (In progress)
## How can I create external commands for the Shivtanium Interpreter?

- Create a batch file in `C\Shivtanium\core`.
- Name it with the following format: `ic-<command>.bat`
- Do not use `@echo off` nor `setlocal enableDelayedExpansion`.
To call your newly created command, use `call \bin\<command>`.
More information about interacting with the process' environment and Shivtanium:
- `%~1` is the PID of the calling process.
- To modify it's variables, use `"pid[%~1]v<variable>"`.
- Printing anything will be redirected straight into the Desktop Window Manager.
- To communicate with the Kernel, redirect (add) data into `!sst.dir!\temp\kernelPipe`. Warning: Don't *lock* the pipe! Other processes might want to be using it >:(

## Screenshots
<div align="center">

  ![image](https://github.com/Shivter14/Shivtanium/assets/98386496/dd131add-ed0a-4b8a-b11d-51ef5c7239ab)
  ![image](https://github.com/Shivter14/Shivtanium/assets/98386496/983b1fc7-c198-4bfc-8a7d-94462d6b9dfb)

</div>

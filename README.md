![Shivtanium Logo](https://raw.githubusercontent.com/Shivter14/Shivtanium/main/Shivtanium.png)
## Shivtanium is a secure batch OS Engine/Kernel + Interpreter.

### How does it work?
Shivtanium runs *sub systems*, like the Shivtanium Interpreter which can be used to safely create GUI applications.
These subsystems can run in parallel, and can communicate with each other.

Input is handled by the Shivtanium OS Kernel, which also handles:
- System shutdown
- Killing processes
- Starting processes
- Registering windows
- Moving windows

and more...

### How does SSTFS work?
Shivtanium uses a custom-written file system: SSTFS
That's the reason why you need a SSTFS file for it to boot.
An SSTFS file can contain applications, assets, and all kinds of stuff
- Shivtanium Applications have the `.sst` extension
- Sprites with normal ASCII art have the `.spr` extension

An SSTFS file contains *File headers* to separate files.
Here is an example of a filesystem with 2 files:
```
@FILE test1
This is a file called test1
@FILE test2
This is a file called test2
```
SSTFS also doesn't extract itself on startup. Instead, whenever a SSTFS file is loaded, Shivtanium reads through the whole filesystem and creates pointers to files (start + end) so that whenever the system needs to read an individual file, it goes to the line below that header, and reads the range of lines it needs.
Limitations: A SSTFS file cannot contain the exclamation mark (`!`).
## the Desktop Window Manager
Shivtanium uses a custom-made Desktop Window Manager to render windows with themes.
These themes can be customized with *resource packs*
Yes, Shivtanium has a resource pack format.

Creating themes requires VT100 knowledge.
The format is easy to understand just by looking at a theme located in: `C\Shivtanium\resourcepacks\init\themes\`

* To modify the window button controls, change the `CBUI` value which should add 9 characters. If more are needed, `\e[#E` can be used to push the cursor back # characters.
* For more help, head to the ![wiki](https://github.com/Shivter14/Shivtanium/wiki).
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
More info about it will be revealed soon. (Milestone 3)

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
Information about creating applications for Shivtanium can be found on the ![wiki](https://github.com/Shivter14/Shivtanium/wiki). [in progress: waiting]
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

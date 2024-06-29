![Shivtanium Logo](https://raw.githubusercontent.com/Shivter14/Shivtanium/main/Shivtanium.png)
## Shivtanium is a secure batch OS Engine/Kernel + Interpreter.

### How does it work?
Shivtanium uses *sub systems*, like the Shivtanium engine which can be used to safely create GUI applications.
These subsystems can run in pararell, and can communicate with each other.

//unfinished documentation

Input is handeled with an input handeling service, which automatically stops giving input when the program isn't focused.

### How does SSTFS work?
Shivtanium uses a custom-written file system: SSTFS
That's the reason why you need a SSTFS file for it to boot.
An SSTFS file can contain applications, assets, and all kinds of stuff
- Shivtanium Applications have the `.sst` extension
- Sprites with normal ASCII art have the `.spr` extension

A SSTFS file contains *File headers* to seperate files.
Here is an example of a filesystem with 2 files:
```
@FILE test1
This is a file called test1
@FILE test2
This is a file called test2
```
SSTFS also doesn't extract itself on startup. Instead, whenever a SSTFS file is loaded, Shivtanium reads through the whole filesystem and creates pointers to files (start + end) so that whenever the system needs to read an individual file, it goes to the line bellow that header, and reads the range of lines it needs.
### More about graphics
Shivtanium uses a custom-made Desktop Window Manager to render windows with themes.
These themes can be customized with *resource packs*
Yes, Shivtanium has a resource pack format.

Creating themes requires VT100 knowledge.
The format is easy to understand just by looking at a theme located in: `C\Shivtanium\resourcepacks\init\themes\`

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
## How can i write `.sst` applications for Shivtanium?
Applications are written in the Shivtanium Subsystem which is interpreted.
More info about it will be revealed soon. (Milestone 3)

This language has a `command<tab>parameters` syntax. Parameters aren't enclosed with quotes, instead, they are seperated by `<tab>`

Code examples:
```
math  1
nocap  The 'math' command works very similarly to 'set /a' in batch. It outputs the result into the `return` variable
:main
if  1  ==  1
  nocap  This is a comment.
if  $return$  >  3
  exit
goto  main
```

## How can i create interactive batch scripts compatible with Shivtanium?
With the help of the Shivtanium Library;
More info about it will also be revealed soon.
## How can i create external commands for Shivtanium and the interpreter?
- Create a batch file in `C\Shivtanium\core`.
- Name it with the following format: `ic-<command>.bat`
- Do not use `@echo off` nor `setlocal enableDelayedExpansion`.
To call your newly created command, use `call \bin\<command>`.
More information about interacting with the process' environment and Shivtanium:
- `%~1` is the PID of the calling process.
- To modify it's variables, use `"pid[%~1]v<variable>"`.
- Printing anything will be redirected straight into DWM.

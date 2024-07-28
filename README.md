<div align="center">

![Shivtanium Logo](https://raw.githubusercontent.com/Shivter14/Shivtanium/main/Shivtanium.png)
[![Latest release version](https://img.shields.io/github/v/release/Shivter14/Shivtanium?color=brightgreen&label=Latest%20version&style=for-the-badge)](https://github.com/Shivter14/Shivtanium/releases "Releases")
[![Commits](https://img.shields.io/github/commit-activity/m/Shivter14/Shivtanium?label=commits&style=for-the-badge)](https://github.com/Shivter14/Shivtanium/commits "Commit History")
[![Last Commit](https://img.shields.io/github/last-commit/Shivter14/Shivtanium/main?label=Latest%20commit&style=for-the-badge&display_timestamp=committer)](https://github.com/Shivter14/Shivtanium/pulse/monthly "Last activity")

## Shivtanium is the most advanced Batch OS Kernel, along with `systemb` making it the most advanced Batch OS ever created.

</div>

Shivtanium has a Kernel, which handles:

- Process management

- Registering windows

- Moving windows

- Resizing windows

- Automatically deleting windows when their process exits

- Shutdown & Rebooting

Shivtanium also has desktop environments. The default & original one is `systemb`. You can find screenshots at the bottom of this document.

Graphics & windows are handled by the Desktop Window Manager. It uses many kinds of VT sequences, optimizations, and all sorts of techniques in order to render windows quickly and smoothly.

More information about it can be found in the following sections and the ![DWM Wiki](https://github.com/Shivter14/Shivtanium/wiki/Desktop-Window-Manager).

## The Desktop Window Manager

Shivtanium uses a custom-made Desktop Window Manager to render windows with themes.
These themes can be customized with resource packs.

Creating themes requires VT100 knowledge.
The format is easy to understand just by looking at a theme located in: `C\Shivtanium\resourcepacks\init\themes\`

* To modify the window button controls, change the `CBUI` value which should add 9 characters. If more are needed, `\e[#E` can be used to expand the limit by # characters.

* For more help, head to the ![DWM Wiki](https://github.com/Shivter14/Shivtanium/wiki/Desktop-Window-Manager).

It's even easier to create sprites, it's just raw ASCII art located in: `C\Shivtanium\resourcepacks\init\sprites\`

The sprite loader automatically detects and assigns the width of sprites while loading.

## Customization

- The display dimensions can be changed in `ssvm.cww` value `mode`.

- The OS name seen in SSVM can be changed in `C\SSVM.cww`.

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

> Keycode is a keyboard key value from WinAPI (used in: getInput64.dll, cmdwiz.exe, getInput.exe, radish.exe...)

Example: `A` is pressed without `Shift` nor `Alt`;

- Keycode of `A` is 65.

- Result: `!charset_L:~65,1!`

Modifying the keyboard layout can be done in the following way:

* Open the `keyboard_init.bat` file in the specified resource pack. (default: `init`)

* Change one of the character sets. (`charset_L` - Lower case, `charset_U` - Upper case, `charset_A` - Alternative)

* To *re-bind* a key to a different character, find the character, and replace it with a different one.

* To *bind a key by its keycode*, change the character at the position based on the keycode.

  (Example: Keycode of `F1` is 112; go to the 112th place.)

## How can I create interactive batch scripts compatible with Shivtanium?

With help from the Shivtanium Kernel;

Information about creating applications for Shivtanium can be found on the ![Kernel Wiki](https://github.com/Shivter14/Shivtanium/wiki/kernel). (In progress)

## Screenshots

<div align="center">

  ![image](https://github.com/Shivter14/Shivtanium/assets/98386496/dd131add-ed0a-4b8a-b11d-51ef5c7239ab)
  ![image](https://github.com/Shivter14/Shivtanium/assets/98386496/983b1fc7-c198-4bfc-8a7d-94462d6b9dfb)
  ![image](https://github.com/user-attachments/assets/d417a5e4-452b-4e58-9eb5-8fad47d6b199)
  ![image](https://github.com/user-attachments/assets/737af2a2-d617-4ead-95cf-7d7acc818c9c)
  ![image](https://github.com/user-attachments/assets/9dde2564-e682-4895-98a9-4840cd61ba49)
  ![image](https://github.com/user-attachments/assets/8aa95fe2-74a8-4655-9a0e-966e88f54b22)
  ![image](https://github.com/user-attachments/assets/816ca08b-a275-4f0e-b7ed-c29ba9e4aa31)


    == Credits ==
    Head Programmer          Shivter
    DOS font        viler@int10h.org
    getInput64.dll         MousieDev
    playSound.vbs           Sintrode
    Audio Duration Script   RazorArt
    Ideas     Icarus, Yeshi, Grub4K,
        and members from server.bat!

</div>

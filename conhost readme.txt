You might be thinking; Why does SSVM contain it's own "conhost.exe"?
This file is from Windows 10 version 22H2 (OS Build 19045.4842, Home edition).
You can check the file's properties to confirm that it's signed by Microsoft.

The reason why it's included here is because of Windows 11's updated conhost breaking some VT100 features required by Shivtanium and other batch graphical operating systems.
It's also here to disable the usage of other terminals (like Windows Terminal) to avoid more issues (like getInput64.dll not working properly).

If this is somehow causing issues on newer versions of windows, delete the "conhost.exe" file, and SSVM should use the one provided by your Windows version.

- Shivter14 9/04/2024
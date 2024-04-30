![Shivtanium Logo](https://raw.githubusercontent.com/Shivter14/Shivtanium/main/Shivtanium.png)
## Shivtanium is a secure batch OS Engine/Kernel + Interpreter

### How does it work?
It uses a custom-written file system: SSTFS
That's the reason why you need an SSTFS file for it to boot.
An SSTFS file can contain applications, assets, and all kinds of stuff
- Shivtanium Applications have the `.sst` extension
- Sprites have the `.spr` extension
### How does SSTFS work?
An SSTFS file contains *File headers* to seperate files.
Here is an example of a filesystem with 2 files:
```
@FILE test1
This is a file called test1
@FILE test2
This is a file called test2
```
SSTFS also doesn't extract itself on startup. Instead, whenever an SSTFS file is loaded, Shivtanium reads through the whole filesystem and creates pointers to files (start + end) so that whenever the system needs to read an individual file, it goes to the line bellow that header, and reads the range of lines it needs.

## How can i write applications for Shivtanium?
Applications are written in the Shivtanium Programming Language which is interpreted.
More info about it will be revealed soon.

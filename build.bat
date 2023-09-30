ml64 /c main.asm
link main.obj /ENTRY:WinMain /SUBSYSTEM:WINDOWS /RELEASE
del *.obj
del *.lnk

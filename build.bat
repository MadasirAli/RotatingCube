ml64 /c main.asm
link main.obj /ENTRY:WinMain /SUBSYSTEM:WINDOWS
del *.obj
del *.lnk

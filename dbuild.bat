@echo off
mkdir build
ml64 /nologo /c /Fo build/Engine.obj src/main.asm
link /nologo /SUBSYSTEM:WINDOWS /DEBUG /OUT:build/Engine.exe /ENTRY:main build/Engine.obj

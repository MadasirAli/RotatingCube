@echo off
mkdir build
ml64 /nologo /c /Fo build/Engine.obj src/main.asm
link /nologo /SUBSYSTEM:CONSOLE /RELEASE /OUT:build/Engine.exe build/Engine.obj

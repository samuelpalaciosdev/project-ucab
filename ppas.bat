@echo off
SET THEFILE=e:\default folders\samuel\desktop\ucab 2do semestre\project-ucab\proyecto.exe
echo Linking %THEFILE%
c:\dev-pas\bin\ldw.exe  -s   -b base.$$$ -o "e:\default folders\samuel\desktop\ucab 2do semestre\project-ucab\proyecto.exe" link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end

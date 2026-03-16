@echo off
rem ***           This runs the uSimmics application             ***
rem ***  You can also start uSimmics\bin\uSimmics.exe directly.  ***

cd bin
rem *** Running the application without command line arguments
rem *** will create %HOMEDRIVE%%HOMEPATH%\.qucs\ folder to save all its data.
start /B uSimmics.exe

rem *** Calling with command line argument "-path"
rem *** will use the given folder to save all its data.
rem  start /B uSimmics.exe -"C:\users\guest\projects"

rem *** The project folder can also be set into the uSimmics directory.
rem *** This may be useful if the application is started from an USB stick.
rem  start /B uSimmics.exe -"%CD%\..\projects"

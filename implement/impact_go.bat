@echo off
REM --------------------------------------------------------------------------
REM Modified: Jonathon W. Donaldson
REM Rev-Mod:  $Id: impact_go.bat,v 1.1 2008-11-07 00:52:52 jwdonal Exp $
REM --------------------------------------------------------------------------

REM --------------------------------------------------------------------------
REM Script to target the FPGA with the resulting design bit file
REM --------------------------------------------------------------------------

echo 'SCRIPT: Which design would you like to use?'
:GETDIR
ECHO 0 - lq057q3dc02
ECHO 1 - Do not use
ECHO 2 - Do not use
set /p choice=Choice: 
if '%choice%'=='0' goto FAKEDLF
REM if '%choice%'=='1' goto REALDLF
REM if '%choice%'=='2' goto ALL
ECHO "%choice%" is not valid please try again
ECHO .
goto GETDIR

:FAKEDLF
echo 'SCRIPT: Running iMPACT...'
impact -batch impact_opt.cmd
goto DONE

:REALDLF
echo 'SCRIPT: Running iMPACT...'
impact -batch impact_opt_dlf.cmd
goto DONE

:ALL
echo 'SCRIPT: Running iMPACT...'
impact -batch impact_opt_all.cmd
goto DONE

:DONE
del _impactbatch.log
echo 'SCRIPT: Done!'

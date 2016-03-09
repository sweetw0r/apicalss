@ECHO OFF
REM cucumber -f html -o reports\report_%date:~10,4%%date:~4,2%%date:~7,2%%time:~0,2%%time:~3,2%.html

REM Create the date and time elements.
for /f "tokens=1-7 delims=:/-, " %%i in ('echo exit^|cmd /q /k"prompt $d $t"') do (
   for /f "tokens=2-4 delims=/-,() skip=1" %%a in ('echo.^|date') do (
      set dow=%%i
      set %%a=%%j
      set %%b=%%k
      set %%c=%%l
      set hh=%%m
      set min=%%n
      set ss=%%o
   )
)

REM Let's see the result.
REM echo %yy%%mm%%dd%%hh%%min%%ss%
cucumber -f html -o reports\report_%yy%%mm%%dd%%hh%%min%.html
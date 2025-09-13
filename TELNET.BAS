    1 REM AGONLIGHT TELNET CLIENT
    2 REM WRITTEN BY ANDREAS HENNINGSSON
    3 REM REQUIRE A ESP8266 WITH THE ZiMODEM FIRMWARE 
    5 REM ---------------------------------------------------------
   10 REM SERIAL SEND EXAMPLE
   20 REM RICHARD TURNNIDGE 2023
   21 REM This version is for 16-bit basic but you could adapt
   22 REM Check if we are running in 24-bit BASIC
   24 :
   25 IF HIMEM > &FFFF PRINT "This code will only run on BBC BASIC for Z80": STOP
   30 :
   31 REM ---------------------------------------------------------
   32 REM This is the user assembly code 
   33 REM ---------------------------------------------------------
   36 :
   38 REM allocate plenty of memory spaces for the three machine code commands
   39 :
   40 DIM openuart% 64
   50 DIM closeuart% 64
   60 DIM senduart% 64
   70 :
   90 REM This routine is for opening the uart
  100 FOR I%=0 TO 3 STEP 3
  110   P%=openuart%
  120   [
  130   OPT I%
  140   :
  150   LD IX, uartstruct ; Address of the uart struct
  160   ld a, &15
  170   RST &08 ; mos_uopen
  180   RET
  190   .uartstruct
  200   DEFB &80 ; LONG (3 bytes) to store baud rate (9600)
  210   DEFB &25
  220   DEFB &00
  230   DEFB 8 ; data bits
  240   DEFB 1 ; stop bits
  250   DEFB 0 ; parity bits
  260   DEFB 0 ; flow control
  270   DEFB 0 ; interrupt bits
  280   ]
  290 NEXT
 1000 :
 1010 REM This routine is to close the uart
 1080 FOR I%=0 TO 3 STEP 3
 1090   P%=closeuart%
 1100   [
 1110   OPT I%
 1120   :
 1210   ld a, &16
 1220   RST &08 ; mos_uclose
 1330   RET
 1370   ]
 1480 NEXT
 1500 :
 2000 REM This routine is to send uart data
 2080 FOR I%=0 TO 3 STEP 3
 2090   P%=senduart%
 2100   [
 2110   OPT I%
 2120   :
 2210   ld c, 65 ; char to send is stored here
 2215   ld a, &18
 2220   RST &08 ; mos_uputc
 2330   RET
 2370   ]
 2480 NEXT
 2999 :
 3000 REM ---------------------------------------------------------
 3001 REM This is the user Basic program
 3002 REM ---------------------------------------------------------
 3003 :
 3005 CLS : REM Just to make screen clear
 3010 REM ---------------------------------------------------------
 3011 REM VARIABLES
 3012 REM --------------------------------------------------------- 
 3040 A = senduart% +1 : REM this is second byte into the routine, store char to send here
 3050 CALL openuart%
 3052 defaultPort$="23"
 3053 verboseEnabled=0
 3054 configFile$ = "/.telnet.cfg"  : REM CONFIGURATION FILE
  3056 bgColor=4
 3057 textColor=6
 3058 programVersion$="0.1.0"
 3059 programName$="Agonlight telnet client"
 3060 programAbout$="Telnet client for AgonLight"
 3061 bellEnabled=0
 3062 debugEnabled=0
 3063 backspacePressed=0
 
 3200 REM ---------------------------------------------------------
 3201 REM PROGRAM START HERE
 3202 REM ---------------------------------------------------------
 3210 PROC_InitFile(configFile$)
 3220 PROC_LoadConfigFile
 3230 PROC_ApplyConfig
 3240 PROC_AppHeader
 3500 REM MAIN LOOP
 3505 v$=""
 3510 INPUT "telnet>"v$
  3512 IF v$="quit" THEN PROC_SaveConfig:END
 3513 IF v$="q" THEN PROC_SaveConfig:END
 3516 IF v$="bye" THEN PROC_SaveConfig:END
 3537 IF v$="apply" THEN PROC_ApplyConfig: GOTO 3500
 3540 IF LEFT$(v$,5)="open " THEN PROC_OpenSession(MID$(v$,6), defaultPort$): GOTO 3500
 3542 IF LEFT$(v$,4)="set " THEN PROC_ParseSetCommand(v$): GOTO 3500
 3544 IF v$="set" THEN PROC_PrintVaribles: GOTO 3500
 3546 IF v$="help" THEN PROC_PrintHelpText: GOTO 3500
 3548 IF v$="" THEN PROC_PrintHelpText: GOTO 3500
 3549 IF v$="save" THEN PROC_SaveConfig: GOTO 3500
 3551 IF v$="c" THEN PROC_EnterTelnetSession: GOTO 3500
 3552 IF v$="continue" THEN PROC_EnterTelnetSession: GOTO 3500
 3554 IF v$="config" THEN PROC_PrintConfiguration: GOTO 3500
 3556 IF v$="close" THEN PROC_CloseConnection: GOTO 3500
 3598 GOTO 3500
 3599 END

 3600 DEF PROC_Debug(lineNo%, functionName$, message$)
 3601 IF debugEnabled = 0 THEN ENDPROC
 3605 COLOUR 1
 3610 PRINT "*** DEBUG   LineNo: " + STR$(lineNo%)
 3620 PRINT "*** DEBUG     PROC: " + functionName$  
 3630 PRINT "*** DEBUG  Message: " + message$
 3640 COLOUR textColor
 3649 ENDPROC
 
 3650 DEF PROC_OpenSession(ip$, port$)
 3655 PROC_Debug(3605, "PROC_OpenSession", "ip: " + ip$ + ", port: " + port$)
 3660 i1=INSTR(ip$, ":")
 3665 i2=INSTR(ip$, " ")
 3670 PROC_Debug(3620, "PROC_OpenSession", "i1: " + STR$(i1) + ", i2: " + STR$(i2))
 3675 IF i1<>0 THEN ip$=MID$(ip$, 0, i1):port$=MID$(ip$, i1+1)
 3680 IF i2<>0 THEN ip$=MID$(ip$, 0, i1):port$=MID$(ip$, i1+1)
 3685 PROC_Debug(3635, "PROC_OpenSession", "ip: " + ip$ + ", port: " + port$)
 3690 PROC_Connect(ip$, port$) 
 3695 PROC_EnterTelnetSession
 3699 ENDPROC 
 
 3700 DEF PROC_AppHeader
 3710 PRINT programName$ + " version: " programVersion$:PRINT
 3720 ENDPROC

 3750 DEF PROC_Verbose(msg$)
 3760 IF verboseEnabled = 0 THEN ENDPROC
 3770 PRINT msg$
 3780 ENDPROC

 3997 DEF PROC_EnterTelnetSession
 3998 PROC_Debug(3999, "PROC_EnterTelnetSession", "")
 3999 PROC_OpenConnection
 4000 N = INKEY(0) : REM wait for a key press 
 4005 IF N=-1 THEN N=0
 4010 IF N=0 THEN GOTO 5000
 4011 IF N=3 THEN CLS:GOTO 3500
 4012 IF N=127 THEN backspacePressed=1
 4020 IF N = 27 THEN GOTO 6000 : REM ESC TO EXIT TERMINAL
 4030 ?A = N : REM poke the char we want to send into this memory byte
 4040 CALL senduart% : REM send the data byte
 4110 GOTO 4000
 4990 :
 5000 REM This section is to READ data from uart and print to the screen
 5001 :
 5005 A% = GET(&D5) : REM  flag for new data D5
 5010 A% = A% AND 1
 5015 IF A% = 0 THEN GOTO 4000
 5020 B% = GET(&D0)
 5021 IF backspacePressed=1 THEN IF B%=7 THEN PROC_MakeBeep:backspacePressed=0:GOTO 5000
 5022 IF backspacePressed=1 THEN IF B%=32 THEN VDU 127:backspacePressed=0:GOTO 5000
 5025 PRINT CHR$(B%);
 5030 GOTO 5000
 5999 :
 6000 PROC_CloseConnection
 6001 GOTO 3500
 6002 ENDPROC

 7000 DEF PROC_ChangeVerbose
 7005 PROC_Debug(7005, "PROC_ChangeVerbose", "Current Value:" + STR$(verboseEnabled)+ " New value: " + STR$(NOT verboseEnabled))
 7010 verboseEnabled = NOT verboseEnabled
 7020 ENDPROC
 7100 DEF PROC_SetVariable(VariableName$, VariableValue$)
 7105 PROC_Debug(7110, "PROC_SetVariable", "VariableName: " + VariableName$ + ", VariableValue: " + VariableValue$)
 7110 IF VariableName$="BGCOLOR" THEN bgColor=VAL(VariableValue$)
 7120 IF VariableName$="TEXTCOLOR" THEN textColor=VAL(VariableValue$)
 7130 IF VariableName$="VERBOSE" THEN verboseEnabled=VAL(VariableValue$)
 7140 IF VariableName$="PORT" THEN defaultPort=VariableValue$
 7150 IF VariableName$="BELL" THEN bellEnabled=VAL(VariableValue$)
 7160 IF VariableName$="DEBUG" THEN debugEnabled=VAL(VariableValue$)
 7199 ENDPROC

 7200 DEF PROC_ParseSetCommand(INP$)
 7205 PROC_Debug(7205, "PROC_ParseSetCommand", "INP: " + INP$)
 7210 INP$=MID$(INP$, 5)
 7215 PROC_Debug(7215, "PROC_ParseSetCommand", "INP updated to: " + INP$)
 7220 I=INSTR(INP$, " ")
 7225 PROC_Debug(7225, "PROC_ParseSetCommand", "I: " + STR$(I)) 
 7230 P1$=MID$(INP$, 0, I-1)
 7240 P2$=MID$(INP$, I+1) 
 7245 PROC_Debug(7245, "PROC_ParseSetCommand", "P1$="+P1$+ " P2$="+P2$)
 7250 PROC_SetVariable(P1$, P2$) 
 7299 ENDPROC

 7300 DEF PROC_PrintHelpText
 7305 PRINT
 7310 PROC_AppHeader
 7315 COLOUR textColor+1
 7320 PRINT:PRINT "  Option                      Description":PRINT
 7325 COLOUR textColor
 7330 PRINT "  open <ip address>           Open connection (default port)"
 7335 PRINT "  open <ip address> <port>    Open connection (specify port)"
 7340 PRINT "  continue|c                  Continue current session"
 7345 PRINT "  config                      Current configuration"
 7346 PRINT "  close                       Close connection"
 7350 PRINT "  set <Varible> <Value>       Set system varibale"
 7355 PRINT "  set                         List all system variables"
 7360 PRINT "  apply                       Apply config"
 7365 PRINT "  save                        Save config"
 7370 PRINT "  quit|bye|q                  Quit the program"
 7375 PRINT
 7399 ENDPROC

 7500 DEF PROC_SendUART(string$)
 7505 PROC_Debug(7505, "PROC_SendUART", "string$:"+string$)
 7510 length = LEN(string$)
 7520 FOR i = 1 TO length
 7530   character$ = MID$(string$, i, 1)
 7540   ?A = ASC(character$)
 7550   CALL senduart% 
 7560 NEXT
 7599 ENDPROC

 7600 DEF PROC_Connect(ip$, port$)
 7605 PROC_Debug(7605, "PROC_Connect", "ip: " + ip$ + ", port: " + port$)
 7610 CONFIG$="AT&621DT"+CHR$(34)+ip$+":"+port$+CHR$(34)
 7620 PROC_Verbose("Connection string: " + CONFIG$)
 7630 PROC_Verbose("Connecting to " + ip$ + ":" + port$)
 7640 PROC_SendUART(CONFIG$)
 7650 ?A=13
 7660 CALL senduart%
 7699 ENDPROC

 8000 DEF PROC_OpenAddressBookSession(entry$) 
 8005 PROC_Debug(8005, "PROC_OpenAddressBookSession", "entry:"+entry$)
 8006 LOCAL ip$, port$
 8010 ip$=addressBook$(int(entry$), 1)
 8020 port$=addressBook$(int(entry$), 2)
 8030 PROC_OpenSession(ip$, port$) 
 8049 ENDPROC

 8200 DEF PROC_InitFile(filename$)
 8205 PROC_Debug(8205, "PROC_InitConfigFile", "filename:"+filename$)
 8210 fileHandle% = OPENIN(filename$) : REM Attempt to open the file
 8220 IF fileHandle%=0 THEN PROC_CreateFile(filename$)
 8230 CLOSE#fileHandle%
 8299 ENDPROC

 8300 DEF PROC_LoadConfigFile
 8305 PROC_Debug(8305, "PROC_LoadConfigFile", "filename: " + configFile$)
 8310 fileHandle% = OPENIN(configFile$)
 8320 REPEAT
 8330   INPUT#fileHandle%, line$
 8340   V$=""
 8350   IF LEFT$(line$,8)="BGCOLOR=" THEN V$=MID$(line$, 9):bgColor=VAL(V$)
 8355   IF LEFT$(line$,10)="TEXTCOLOR=" THEN V$=MID$(line$, 11):textColor=VAL(V$)
 8360   IF LEFT$(line$,8)="VERBOSE=" THEN V$=MID$(line$, 9):verboseEnabled=VAL(V$)
 8365   IF LEFT$(line$,5)="PORT=" THEN V$=MID$(line$, 6):defaultPort$=V$
 8370   IF LEFT$(line$,5)="BELL=" THEN V$=MID$(line$, 6):bellEnabled=VAL(V$)
 8375   IF LEFT$(line$,6)="DEBUG=" THEN V$=MID$(line$, 7):debugEnabled=VAL(V$)
 8380 UNTIL EOF#fileHandle%
 8390 ENDPROC

 8400 DEF PROC_SaveConfig
 8405 PROC_Debug(8405, "PROC_SaveConfig", "filename: " + configFile$)
 8410 PROC_Verbose("Saving configuration...")
 8415 file%=OPENOUT configFile$
 8420 PRINT#file%, "BGCOLOR="+STR$(bgColor)
 8425 PRINT#file%, "TEXTCOLOR="+STR$(textColor)
 8430 PRINT#file%, "VERBOSE="+STR$(verboseEnabled)
 8435 PRINT#file%, "PORT="+defaultPort$
 8440 PRINT#file%, "BELL="+STR$(bellEnabled)
 8445 PRINT#file%, "DEBUG="+STR$(debugEnabled)
 8450 CLOSE#file%
 8455 PROC_Verbose("Done")
 8460 ENDPROC 

 8500 DEF PROC_ApplyConfig
 8505 PROC_Debug(8505, "PROC_ApplyConfig", "")
 8510 COLOUR textColor
 8520 COLOUR 128+bgColor
 8598 CLS
 8599 ENDPROC
 
 8600 DEF PROC_PrintVaribles
 8610 COLOUR textColor+1
 8615 PRINT:PRINT "  Variable                    Description                Valid Values":PRINT 
 8620 COLOUR textColor
 8625 PRINT       "  TEXTCOLOR                   Text color                 Number"
 8630 PRINT       "  BGCOLOR                     Background color           Number"
 8635 PRINT       "  BELL                        Bell enabled               0 or 1"
 8640 PRINT       "  VERBOSE                     Verbose enabled            0 or 1"
 8645 PRINT       "  PORT                        Default port (telnet 23)   Number"
 8650 PRINT       "  DEBUG                       Enable debug               0 or 1"
 8655 PRINT
 8699 ENDPROC

 8800 DEF PROC_MakeBeep
 8810 REM IF bellEnabled=-1 THEN .....
 8899 ENDPROC

 9000 DEF PROC_PrintConfiguration
 9010 COLOUR textColor+1
 9020 PRINT:PRINT "  Variable                    Value":PRINT 
 9025 COLOUR textColor
 9030 PRINT       "  TEXTCOLOR                   " + STR$(textColor)
 9040 PRINT       "  BGCOLOR                     " + STR$(bgColor)
 9050 PRINT       "  BELL                        ";: IF bellEnabled=1 THEN PRINT "TRUE" ELSE PRINT "FALSE"
 9060 PRINT       "  VERBOSE                     ";:IF verboseEnabled=1 THEN PRINT "TRUE" ELSE PRINT "FALSE"
 9070 PRINT       "  PORT                        " + defaultPort$
 9080 PRINT       "  DEBUG                       ";: IF debugEnabled=1 THEN PRINT "TRUE" ELSE PRINT "FALSE"
 9098 PRINT
 9099 ENDPROC

10000 DEF PROC_CloseConnection
10005 PROC_Debug(10005, "PROC_CloseConnection", "")
10006 PROC_Verbose("Closing connection")
10010 CALL closeuart%
10049 ENDPROC

10050 DEF PROC_OpenConnection
10055 PROC_Debug(10055, "PROC_OpenConnection", "")
10056 PROC_Verbose("Open connection")
10060 CALL openuart%
10099 ENDPROC

11000 DEF PROC_CreateFile(filename$)
11005 PROC_Debug(11005, "PROC_CreateFile", "filename: " + filename$)
11006 PROC_Verbose(filename$+" created...")
11020 file%=OPENOUT filename$
11030 CLOSE#file%
11049 ENDPROC

30000 (*  COPYRIGHT 1983 C.H.LINDSEY, UNIVERSITY OF MANCHESTER  *)
30010  (**)
30020  (**)
30030  (*+04()
30040  MODULE A68SIN;
30050  PROCEDURE DUMP;
30060  PRIVATE
30070  IMPORTS A68COM FROM A68DEC;
30080  ()+04*)
30090  (*+83()  PROCEDURE INITIALIZE; FORWARD; ()+83*)
30100  (*+85()  PROCEDURE STANDARDPRELUDE; FORWARD; ()+85*)
30110  (*+82()  PROCEDURE PARSEPARSER; FORWARD; ()+82*)
30120  (*+85()  PROCEDURE INITSEMANTICS; FORWARD; ()+85*)
30130  (*+01()  PROCEDURE INITBEGIN; FORWARD; ()+01*)
30140  (*+86()  PROCEDURE INITCODES; FORWARD; ()+86*)
30150  PROCEDURE SIN;
30160      BEGIN
30170  (*+83()    INITIALIZE;   ()+83*)
30180  (*+82()    PARSEPARSER;    ()+82*)
30190  (*+85()    STANDARDPRELUDE;   ()+85*)
30200  (*+85()    INITSEMANTICS;  ()+85*)
30210  (*+01()    INITBEGIN;   ()+01*)
30220  (*+86()    INITCODES;   ()+86*)
30230      END;
30240  (**)
30250  (**)
30260  (**)
30270  (**)
30280  (*+01()
30290  FUNCTION PFL: INTEGER;
30300  (*OBTAIN FIELD LENGTH FROM GLOBAL P.FL*)
30310  EXTERN;
30320  (**)
30330  (**)
30340  FUNCTION PFREE: PINTEGER;
30350  (*OBTAIN ADDRESS OF GLOBAL P.FREE*)
30360  EXTERN;
30370  (**)
30380  (**)
30390  (*$T-+)
30400  PROCEDURE DUMP(VAR START: INTEGER);
30410  (*DUMPS STACK AND HEAP ONTO FILE DUMPF.
30420        START IS FIRST VARIABLE ON STACK TO BE DUMPED*)
30430    CONST TWO30=10000000000B;
30440          FREEINIT=40000000000000000000B; (*INITIAL VALUE OF P.FREE*)
30450    VAR F1: FILE OF INTEGER;
30460        STACKSTART, STACKLENGTH, HEAPSTART, HEAPLENGTH: INTEGER;
30470        FRIG: RECORD CASE INTEGER OF
30480                     1:(INT: INTEGER); 2:(POINT: PINTEGER) END;
30490        D: DUMPOBJ;
30500        MASKM,MASKL: INTEGER;
30510        I: INTEGER;
30520      BEGIN
30530      FRIG.INT := GETB(5)+3; STACKSTART := FRIG.POINT^;
30540      STACKLENGTH := GETB(5)-STACKSTART;
30550      FOR I := STACKSTART TO STACKSTART+STACKLENGTH-1 DO
30560        BEGIN FRIG.INT := I; FRIG.POINT^ := 40000000000000000000B END; (*CLEAR STACK*)
30570      FOR I := GETB(6) TO PFL-1 DO
30580        BEGIN FRIG.INT := I; FRIG.POINT^ := 0 END; (*CLEAR SPACE BETWEEN STACK AND HEAPTOP*)
30590      SIN;
30600      HEAPSTART := GETB(4); HEAPLENGTH := PFL-HEAPSTART;
30610      FRIG.POINT := PFREE; START := FRIG.POINT^; (*STORE P.FREE ON STACK FOR DUMPING*)
30620      WRITELN(' STACK SIZE =', STACKLENGTH); WRITELN('  HEAP SIZE =', HEAPLENGTH);
30630      REWRITE(F1);
30640      FOR I := STACKSTART TO STACKSTART+STACKLENGTH-1 DO
30650        BEGIN FRIG.INT := I; WRITE(F1, FRIG.POINT^) END;
30660      FOR I := HEAPSTART TO HEAPSTART+HEAPLENGTH-1 DO
30670        BEGIN FRIG.INT := I; WRITE(F1, FRIG.POINT^) END;
30680      WRITELN(' F1 WRITTEN');
30690  (**)
30700      (*NOW CLEAR THE HEAP AND REINITIALIZE IT ONE WORD DOWN*)
30710      SETB(4, PFL-1); FRIG.POINT := PFREE; FRIG.POINT^ := FREEINIT;
30720      FOR I := STACKSTART TO STACKSTART+STACKLENGTH-1 DO
30730        BEGIN FRIG.INT := I; FRIG.POINT^ := 40000000000000000000B END;
30740      FOR I := GETB(6) TO PFL-1 DO
30750        BEGIN FRIG.INT := I; FRIG.POINT^ := 0 END;
30760      SIN;
30770      FRIG.POINT := PFREE; START := FRIG.POINT^;
30780      RESET(F1); REWRITE(A68INIT);
30790      D.INT := STACKLENGTH; D.MASK := HEAPLENGTH; WRITE(A68INIT, D.INT, D.MASK);
30800      FOR I := STACKSTART TO STACKSTART+STACKLENGTH-1 DO
30810        BEGIN
30820        READ(F1, D.INT);
30830        FRIG.INT := I; D.MASK := D.INT-FRIG.POINT^;
30840          (*D.MASK CONTAINS A 1 AT THE LS END OF EACH ^ FIELD OF D.INT*)
30850          (*NOW WE HAVE TO MULTIPLE D.MASK BY HEAPSTART*)
30860        MASKM := D.MASK DIV TWO30; MASKL := D.MASK-MASKM*TWO30;
30870        MASKM := MASKM*HEAPSTART; MASKL := MASKL*HEAPSTART;
30880        D.INT := D.INT-MASKM*TWO30-MASKL;
30890        WRITE(A68INIT, D.INT, D.MASK)
30900        END;
30910      FOR I := HEAPSTART TO HEAPSTART+HEAPLENGTH-1 DO
30920        BEGIN
30930        READ(F1, D.INT);
30940        FRIG.INT := I-1; D.MASK := D.INT-FRIG.POINT^;
30950        MASKM := D.MASK DIV TWO30; MASKL := D.MASK-MASKM*TWO30;
30960        MASKM := MASKM*HEAPSTART; MASKL := MASKL*HEAPSTART;
30970        D.INT := D.INT-MASKM*TWO30-MASKL;
30980        WRITE(A68INIT, D.INT, D.MASK)
30990        END;
31000      WRITELN(' A68INIT WRITTEN');
31010  (**)
31020      (*FINALLY, CLEAR THE HEAP AGAIN*)
31030      SETB(4, PFL); FRIG.POINT := PFREE; FRIG.POINT^ := FREEINIT
31040      END;
31050  ()+01*)
31060  (**)
31070  (**)
31080  (*-11()
31090  PROCEDURE STASHLEX(A1: ALFA);
31100  VAR I: INTEGER;
31110      BEGIN
31120      WITH CURRENTLEX DO
31130        BEGIN S10 := A1;
31140        I := 10; REPEAT I := I+1 ; STRNG[I] := ' ' UNTIL I MOD CHARPERWORD = 0;
31150        WHILE STRNG[I]=' ' DO I := I-1;
31160        LXCOUNT := (I+CHARPERWORD-1) DIV CHARPERWORD;
31170        END
31180      END;
31190  (**)
31200  (**)
31210  PROCEDURE STASHLLEX(A1, A2: ALFA);
31220  VAR I: INTEGER;
31230      BEGIN
31240      WITH CURRENTLEX DO
31250        BEGIN S10 := A1;
31251        FOR I := 11 TO 20 DO STRNG[I] := A2[I-10];
31260        I := 20; REPEAT I := I+1; STRNG[I] := ' ' UNTIL I MOD CHARPERWORD =  0;
31270        WHILE STRNG[I]=' ' DO I := I-1;
31280        LXCOUNT := (I+CHARPERWORD-1) DIV CHARPERWORD;
31290        END
31300      END;
31310  ()-11*)
31320  (**)
31330  (**)
31340  (*-01() (*-03() (*-04()
31350  FUNCTION GETADDRESS(VAR VARIABLE:INTEGER): ADDRINT; EXTERN;
31360  (**)
31370  PROCEDURE RESTORE(VAR START,FINISH: INTEGER);
31380    VAR  STACKSTART,STACKEND,GLOBALLENGTH,HEAPLENGTH,
31390         HEAPSTART(*+19(),LENGTH,POINTER()+19*): ADDRINT;
31395         I:INTEGER;
31400         P: PINTEGER;
31410         FRIG: RECORD CASE SEVERAL OF
31420                        1: (INT: ADDRINT);
31421                        2: (POINT: PINTEGER);
31422                        3: (PLEXP: PLEX);
31423                (*+19() 4: (APOINT: ^ADDRINT); ()+19*)
31424           (*-19()4,()-19*)5,6,7,8,9,10: ()
31430                      END;
31440         D: RECORD INT,MASK: INTEGER END;
31450      BEGIN
31459 (*+05()
31460      OPENLOADFILE(A68INIT, 4, FALSE);
31461 ()+05*)
31470      STACKSTART := GETADDRESS(START);
31480      IF NOT EOF(A68INIT) THEN
31490        BEGIN
31500        READ(A68INIT,GLOBALLENGTH,HEAPLENGTH);
31510        ENEW(FRIG.PLEXP, HEAPLENGTH);
31520        HEAPSTART := FRIG.INT;
31530        FRIG.INT := STACKSTART;
31535 (*-19()
31540        FOR I := 1 TO GLOBALLENGTH DIV SZWORD DO
31550          BEGIN
31560          READ(A68INIT,D.INT,D.MASK);
31570          IF D.MASK=SZREAL THEN (*D.INT IS A POINTER OFFSET FROM HEAPSTART*)
31580             D.INT := D.INT+HEAPSTART;
31590          FRIG.POINT^ := D.INT;
31600          FRIG.INT := FRIG.INT+SZWORD;
31610          END;
31620        FRIG.INT := HEAPSTART;
31630        FOR I := 1 TO HEAPLENGTH DIV SZWORD DO
31640          BEGIN
31642          READ(A68INIT,D.INT,D.MASK);
31644          IF D.MASK=SZREAL THEN
31646            D.INT := D.INT+HEAPSTART;
31648          FRIG.POINT^ := D.INT;
31650          FRIG.INT := FRIG.INT+SZWORD
31652          END
31654 ()-19*)
31659 (*+19()
31660          LENGTH:=GLOBALLENGTH DIV SZWORD;
31662          I:=1;
31664          WHILE I<=LENGTH DO
31666          BEGIN
31668             READ(A68INIT,D.MASK);
31670             IF D.MASK=SZADDR+SZWORD THEN (*IT IS A POINTER*)
31672             BEGIN
31674                READ(A68INIT,POINTER);
31676                POINTER:=POINTER+HEAPSTART;
31678                FRIG.APOINT^:=POINTER;
31680                FRIG.INT:=FRIG.INT+SZWORD+SZWORD; (*POINTER IS 2 WORDS *)
31682                I:=I+2
31684             END
31686             ELSE
31688             BEGIN
31690               READ(A68INIT,D.INT);
31691               FRIG.POINT^:=D.INT;
31692               FRIG.INT:=FRIG.INT+SZWORD;
31693               I:=I+1
31694             END
31695          END;
31696          LENGTH:=HEAPLENGTH DIV SZWORD;
31697          FRIG.INT:=HEAPSTART;
31698          I:=1;
31699          WHILE I<=LENGTH DO
31700          BEGIN
31701             READ(A68INIT,D.MASK);
31702             IF D.MASK=SZADDR+SZWORD THEN (*IT IS A POINTER*)
31703             BEGIN
31704                READ(A68INIT,POINTER);
31705                POINTER:=POINTER+HEAPSTART;
31706                FRIG.APOINT^:=POINTER;
31707                FRIG.INT:=FRIG.INT+SZWORD+SZWORD; (*POINTER IS 2 WORDS *)
31708                I:=I+2
31709             END
31710             ELSE
31711             BEGIN
31712               READ(A68INIT,D.INT);
31713               FRIG.POINT^:=D.INT;
31714               FRIG.INT:=FRIG.INT+SZWORD;
31715               I:=I+1
31716             END
31717          END
31718 ()+19*)
31719        END
31720      END;
31730  PROCEDURE DUMP(VAR START,FINISH: INTEGER);
31740    VAR STACKSTART,STACKEND,GLOBALLENGTH,
31750        HEAPLENGTH,HEAPSTART: ADDRINT;
31755        I:INTEGER;
31760        P: PINTEGER;
31770        FRIG: RECORD CASE SEVERAL OF
31780                       1: (INT:ADDRINT); 2: (POINT:PINTEGER);
31790                       3: (PLEXP: PLEX); 4,5,6,7,8,9,10: ()
31800                     END;
31810        D: RECORD INT,MASK: INTEGER END;
31830  (**)
31840      BEGIN  (* DUMP *)
31850      REWRITE(LSTFILE);WRITELN(LSTFILE,' START DUMP');
31860 (*+05()
31870      OPENLOADFILE(DUMPF, 5, TRUE);
31871 ()+05*)
31880      IF EOF(LGO) THEN ENEW(FRIG.PLEXP,SZREAL)
31890      ELSE ENEW(FRIG.PLEXP,2*SZREAL);
31900      NEW(FRIG.POINT); (*-02() DISPOSE(FRIG.POINT); ()-02*)
31910      HEAPSTART := FRIG.INT;
31920      RESTORE(START,FINISH);
31930      SIN;
31935 (*-02()
31940      NEW(FRIG.POINT); DISPOSE(FRIG.POINT);
31941 ()-02*)
31943 (*+02()
31945      ENEW(FRIG.POINT,100); (* TO MAKE SURE IT GOES AT THE END *)
31947 ()+02*)
31950      HEAPLENGTH := FRIG.INT-HEAPSTART;
31960      STACKSTART := GETADDRESS(START);
31970      STACKEND := GETADDRESS(FINISH);
31980      GLOBALLENGTH := STACKEND-STACKSTART;
31990      WRITE(DUMPF,GLOBALLENGTH,HEAPLENGTH,HEAPSTART);
32000      FRIG.INT := STACKSTART;
32010      FOR I := 1 TO ABS(GLOBALLENGTH) DIV SZWORD DO
32020        BEGIN
32030        WRITE(DUMPF,FRIG.POINT^);
32040        FRIG.INT := FRIG.INT+SZWORD*(ORD(GLOBALLENGTH>0)*2-1);
32050        END;
32060      FRIG.INT := HEAPSTART;
32070      FOR I := 1 TO ABS(HEAPLENGTH) DIV SZWORD DO
32080        BEGIN
32090        WRITE(DUMPF,FRIG.POINT^);
32100        FRIG.INT := FRIG.INT+SZWORD*(ORD(HEAPLENGTH>0)*2-1);
32110        END;
32120      WRITELN(LSTFILE,' DUMPF WRITTEN');
32130  (**)
32140      WRITELN(LSTFILE,' GLOBAL LENGTH',GLOBALLENGTH,' HEAP LENGTH',HEAPLENGTH);
32150      END;
32160  ()-04*) ()-03*) ()-01*)
32170  (*-01() (*-02() (*-05()
32180  PROCEDURE DUMP(VAR START, FINISH: INTEGER);
32190      BEGIN SIN END;
32200  ()-05*) ()-02*) ()-01*)

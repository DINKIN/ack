08000 #include "rundecs.h"
08010     (*  COPYRIGHT 1983 C.H.LINDSEY, UNIVERSITY OF MANCHESTER  *)
08020 (**)
08030 (*+01() (*$X6*) ()+01*)
08040 PROCEDURE STANDINC(PCOV: OBJECTP; LFN: LFNTYPE); EXTERN;
08050 PROCEDURE STANDOUT(PCOV: OBJECTP; LFN: LFNTYPE); EXTERN;
08060 PROCEDURE STANDBAC(PCOV: OBJECTP; LFN: LFNTYPE); EXTERN;
08070 (*+01() (*$X4*) ()+01*)
08080 PROCEDURE CL68(PB: ASNAKED; RF: OBJECTP); EXTERN;
08090 PROCEDURE ERRORR(N: INTEGER); EXTERN;
08100 (*+05() FUNCTION TIME: REAL; EXTERN; ()+05*)
08110 PROCEDURE CALLPASC ; EXTERN;
08120 PROCEDURE ABORT; EXTERN;
08130 (*+02()
08140 PROCEDURE ACLS(FIL: FETROOMP); EXTERN;
08150 PROCEDURE STOPEN (VAR PF: FYL; VAR RF: OBJECTP; LFN: LFNTYPE; PROCEDURE CH(COV:OBJECTP;L:LFNTYPE) ); EXTERN;
08160 ()+02*)
08170 (*+01() (*$X6*) ()+01*)
08180 FUNCTION PROC(PROCEDURE P):ASPROC;EXTERN;
08190 (*-01()
08200 FUNCTION PROCH( PROCEDURE P( COV: OBJECTP ; L: LFNTYPE ) ): ASPROC ; EXTERN ;
08210 ()-01*)
08220 (*+01() (*$X4*) ()+01*)
08230 (**)
08240 (*+24()
08250 PROCEDURE FINDSORT(POINT: OBJECTP; VAR GETSORT: ALFA);
08260     BEGIN
08270 (*+01() (*$T-*) ()+01*)
08280     CASE POINT^.SORT OF
08290       STRUCT: GETSORT:='STRUCT    ';
08300       MULT:   GETSORT:='MULT      ';
08310       IELS:   GETSORT:='IELS      ';
08320       ROUTINE:GETSORT:='ROUTINE   ';
08330       REF1:   GETSORT:='REF1      ';
08340       REF2:   GETSORT:='REF2      ';
08350       REFN:   GETSORT:='REFN      ';
08360       CREF:   GETSORT:='CREF      ';
08370       REFR:   GETSORT:='REFR      ';
08380       REFSL1: GETSORT:='REFSL1    ';
08390       REFSLN: GETSORT:='REFSLN    ';
08400       RECR:   GETSORT:='RECR      ';
08410       RECN:   GETSORT:='RECN      ';
08420       UNDEF:  GETSORT:='UNDEF     ';
08430       NILL:   GETSORT:='NILL      ';
08440       STRING: GETSORT:='STRING    ';
08450     END
08460     END;
08470 (**)
08480 (**)
08490 PROCEDURE PRINTSORT(POINT: OBJECTP);
08500     BEGIN
08510     CASE POINT^.SORT OF
08520       STRUCT: WRITE('STRUCT');
08530       MULT:   WRITE('MULT');
08540       IELS:   WRITE('IELS');
08550       ROUTINE:WRITE('ROUTINE');
08560       REF1:   WRITE('REF1');
08570       REF2:   WRITE('REF2');
08580       REFN:   WRITE('REFN');
08590       CREF:   WRITE('CREF');
08600       REFR:   WRITE('REFR');
08610       REFSL1: WRITE('REFSL1');
08620       REFSLN: WRITE('REFSLN');
08630       RECR:   WRITE('RECR');
08640       RECN:   WRITE('RECN');
08650       UNDEF:  WRITE('UNDEF');
08660       NILL:   WRITE('NILL');
08670     END;
08680     WRITELN(' SORT');
08690 (* ( $T+ ) *)
08700     END;
08710 (**)
08720 (**)
08730 PROCEDURE PRINTDESC(ADESC: OBJECTP);
08740 VAR I:INTEGER;
08750     BEGIN
08760     WITH ADESC^ DO
08770       BEGIN
08780       WRITE('SIZ',SIZE:2,' D0',D0:2,' LBJ',LBADJ:2);
08790       WRITE(' LIUIDI');
08800       FOR I := 0 TO ROWS DO WITH DESCVEC[I] DO
08810         WRITE(LI:2, UI:2, DI:2);
08820       WRITELN
08830       END;
08840     END;
08850 ()+24*)
08860 (**)
08870 (**)
08880 FUNCTION CRSTRING(LENGTH: OFFSETRANGE): OBJECTP;
08890   VAR POINT :OBJECTP;
08900       PTR: UNDRESSP;
08910     BEGIN
08920     IF LENGTH<0 THEN LENGTH := 0;
08930     ENEW(POINT, STRINGCONST+((LENGTH + CHARPERWORD - 1) DIV CHARPERWORD)*SZWORD);
08940 (*-02() POINT^.FIRSTWORD := SORTSHIFT * ORD(STRING); ()-02*)
08950 (*+02() POINT^.PCOUNT:=0; POINT^.SORT:=STRING; ()+02*)
08960     POINT^.STRLENGTH := LENGTH;
08970     PTR := INCPTR(POINT, STRINGCONST+((LENGTH-1) DIV CHARPERWORD)*SZWORD);
08980     IF LENGTH<>0 THEN PTR^.FIRSTWORD := 0;
08990     CRSTRING := POINT
09000     END;
09010 (**)
09020 (**)
09030 FUNCTION CRSTRUCT(TEMPLATE: DPOINT): OBJECTP;
09040 VAR  NEWSTRUCT: OBJECTP;
09050      TEMPOS, STRUCTPOS, STRUCTSIZE, COUNT: INTEGER;
09060      PTR, PTR1: UNDRESSP;
09070 BEGIN
09080      STRUCTSIZE:= TEMPLATE^[0];
09090      ENEW(NEWSTRUCT, STRUCTSIZE+STRUCTCONST);
09100      WITH NEWSTRUCT^ DO
09110      BEGIN
09120 (*-02()   FIRSTWORD := SORTSHIFT * ORD(STRUCT); ()-02*)
09130 (*+02()   PCOUNT:=0; SORT:=STRUCT; ()+02*)
09140  (*+01()  SECONDWORD := 0;  ()+01*)
09150           OSCOPE := 0 ;
09160           LENGTH := STRUCTSIZE+STRUCTCONST;
09170           DBLOCK:= TEMPLATE;
09180           PTR := INCPTR(NEWSTRUCT, STRUCTCONST);
09190           PTR^.FIRSTWORD := INTUNDEF;
09200           PTR1 := INCPTR(PTR, SZWORD);
09210           MOVELEFT(PTR, PTR1, STRUCTSIZE-SZWORD);
09220      TEMPOS:= 1;
09230      STRUCTPOS := TEMPLATE^[1];
09240      WHILE STRUCTPOS >= 0
09250      DO BEGIN
09260           PTR := INCPTR(NEWSTRUCT, STRUCTCONST+STRUCTPOS);
09270           PTR^.FIRSTPTR := UNDEFIN;
09280           TEMPOS:= TEMPOS+1;
09290           STRUCTPOS := TEMPLATE^[TEMPOS];
09300      END;
09310      END;
09320      CRSTRUCT := NEWSTRUCT
09330 END;
09340 (**)
09350 (**)
09360 PROCEDURE GARBAGE(ANOBJECT:OBJECTP); FORWARD;
09370 (**)
09380 (**)
09390 (*+02()
09400 PROCEDURE ACLOSE(EFET: FETROOMP);
09410   VAR NAME:OBJECTP;
09420     BEGIN
09430       WITH EFET^ DO
09440         IF UFD>2 THEN (*USER'S FILE*)
09450           BEGIN NAME := INCPTR(FNAME, -STRINGCONST);
09460           FPDEC(NAME^); IF FPTST(NAME^) THEN GARBAGE(NAME);
09470           END;
09480     ACLS(EFET);
09490     END;
09500 ()+02*)
09510 PROCEDURE GARBAGE(* (ANOBJECT: OBJECTP) *) ;
09520   LABEL 1;
09530   VAR ASINT: INTEGER;
09540       BACK, HEAD: OBJECTP; TEMPLATE: DPOINT;
09550       TEMP: OBJECTP;
09560       PTR: UNDRESSP;
09570       ELSIZE, SIZEACC, COUNT, STRUCTPOS, TEMPOS: INTEGER;
09580       ISHEAD: BOOLEAN;
09590       GETSORT: ALFA;
09600       PFET: FETROOMP;
09610     BEGIN
09620     (*+24()(*BUGFILE
09630     FINDSORT(ANOBJECT, GETSORT);
09640     WRITELN(BUGFILE, 'GARBGE', GETSORT, 'AT', ORD(ANOBJECT):(*-01()1()-01*)(*+01()6 OCT()+01*) ,
09650             'C=', ANOBJECT^.PCOUNT:4);
09660     BUGFILE*)()+24*)
09670 1:  WITH ANOBJECT^ DO
09680       BEGIN
09690 (*+01() IF ORD(ANOBJECT)=0 THEN HALT; (*FOR CATCHING BUGS - SHOULDN'T HAPPEN*) ()+01*)
09700       CASE SORT OF
09710         STRUCT:
09720           BEGIN
09730           TEMPLATE:= DBLOCK;
09740           TEMPOS:= 1;
09750           STRUCTPOS:= TEMPLATE^[1];
09760           WHILE STRUCTPOS>=0 DO
09770             BEGIN
09780             PTR := INCPTR(ANOBJECT, STRUCTCONST+STRUCTPOS);
09790             WITH PTR^.FIRSTPTR^ DO
09800               BEGIN FDEC; IF FTST THEN GARBAGE(PTR^.FIRSTPTR) END;
09810             TEMPOS:= TEMPOS+1;
09820             STRUCTPOS:= TEMPLATE^[TEMPOS]
09830             END;
09840           EDISPOSE(ANOBJECT, LENGTH)
09850           END;
09860         IELS:
09870           BEGIN
09880           TEMPLATE := DBLOCK;
09890           IF ORD(TEMPLATE)<=MAXSIZE  (*NOT STRUCT*) THEN
09900             BEGIN
09910             IF ORD(TEMPLATE)=0  (*DRESSED*) THEN
09920               BEGIN
09930               PTR := INCPTR(ANOBJECT, ELSCONST);
09940               WHILE ORD(PTR)<ORD(ANOBJECT)+ELSCONST+D0 DO
09950                 BEGIN
09960                 WITH PTR^.FIRSTPTR^ DO
09970                   BEGIN
09980                   FDEC;
09990                   IF FTST THEN GARBAGE(PTR^.FIRSTPTR)
10000                   END;
10010                 PTR := INCPTR(PTR, SZADDR)
10020                 END
10030               END
10040             END
10050           ELSE BEGIN  (*UNDRESSED STRUCTURES*)
10060             ELSIZE:= TEMPLATE^[0];
10070             IF TEMPLATE^[1] >= 0 THEN
10080               BEGIN
10090               COUNT:= D0;
10100               ASINT:= ELSCONST;
10110               WHILE COUNT>0 DO
10120                 BEGIN
10130                 TEMPOS := 1;
10140                 STRUCTPOS := TEMPLATE^[1];
10150                 WHILE STRUCTPOS>=0 DO
10160                   BEGIN
10170                   PTR := INCPTR(ANOBJECT, ASINT+STRUCTPOS);
10180                   WITH PTR^.FIRSTPTR^ DO
10190                     BEGIN FDEC;
10200                     IF FTST THEN GARBAGE(PTR^.FIRSTPTR)
10210                     END;
10220                   TEMPOS := TEMPOS+1;
10230                   STRUCTPOS := TEMPLATE^[TEMPOS]
10240                   END;
10250                 ASINT:= ASINT+ELSIZE;
10260                 COUNT:= COUNT-ELSIZE
10270                 END
10280               END
10290             END;
10300           EDISPOSE(ANOBJECT, ELSCONST+D0)
10310           END;
10320         MULT:
10330         (*ASSERT: THIS MULTIPLE IS NOT SLICED*)
10340         IF PVALUE=NIL (* A BOUNDS BLOCK *) THEN
10350           EDISPOSE(ANOBJECT, MULTCONST+(ROWS+1)*SZPDS)
10360         ELSE
10370           BEGIN
10380           BACK := BPTR;
10390           IF BACK<>NIL THEN
10400             BEGIN (*NOT SLICED BUT A SLICE*)
10410             HEAD:= FPTR;
10420             IF ANOBJECT<>BACK^.IHEAD THEN
10430               BEGIN (*NOT FIRST SLICE*)
10440               BACK^.FPTR:= HEAD;
10450               IF HEAD<>NIL THEN
10460                 HEAD^.BPTR:= BACK
10470               END
10480             ELSE
10490               IF HEAD<>NIL (* THE FIRST SLICE AND NOT THE LAST SLICE *) THEN
10500                 BEGIN
10510                 BACK^.IHEAD:= HEAD;
10520                 HEAD^.BPTR := BACK
10530                 END
10540               ELSE
10550                 BEGIN (*THE ONLY SLICE*)
10560                 BACK^.IHEAD := NIL;
10570                 FPDEC(BACK^);
10580                 IF FPTST(BACK^) THEN GARBAGE(BACK)
10590               END
10600             END;
10610           FPDEC(PVALUE^); TEMP := PVALUE;
10620           EDISPOSE(ANOBJECT, MULTCONST+(ROWS+1)*SZPDS);
10630           IF FPTST(TEMP^) THEN BEGIN ANOBJECT := TEMP; GOTO 1 END
10640           END;
10650         REFN:
10660           BEGIN
10670           FPDEC(PVALUE^); TEMP := PVALUE;
10680           EDISPOSE(ANOBJECT, REFNSIZE);
10690           IF FPTST(TEMP^) THEN BEGIN ANOBJECT := TEMP; GOTO 1 END
10700           END;
10710         REFSLN:
10720           BEGIN
10730           FPDEC(ANCESTOR^);
10740           TEMP := ANCESTOR;
10750           EDISPOSE(ANOBJECT, REFSLNCONST+(ROWS+1)*SZPDS);
10760           IF FPTST(TEMP^) THEN BEGIN ANOBJECT := TEMP; GOTO 1 END
10770           END;
10780         REFSL1:
10790           BEGIN
10800           FPDEC(ANCESTOR^);
10810           TEMP := ANCESTOR;
10820           EDISPOSE(ANOBJECT, REFSL1SIZE);
10830           IF FPTST(TEMP^) THEN BEGIN ANOBJECT := TEMP; GOTO 1 END
10840           END;
10850         REFR:
10860           BEGIN
10870           FPDEC(PVALUE^); TEMP := PVALUE;
10880           EDISPOSE(ANOBJECT, REFRCONST+(ROWS+1)*SZPDS);
10890           IF FPTST(TEMP^) THEN BEGIN ANOBJECT := TEMP; GOTO 1 END
10900           END;
10910         RECR:
10920           BEGIN
10930           BACK:= PREV;
10940           HEAD:= NEXT;
10950           BACK^.NEXT:= HEAD;
10960           IF HEAD <> NIL THEN
10970             HEAD^.PREV:= BACK;
10980           FPDEC(PVALUE^); TEMP := PVALUE;
10990           EDISPOSE(ANOBJECT, RECRCONST+(ROWS+1)*SZPDS);
11000           IF FPTST(TEMP^) THEN BEGIN ANOBJECT := TEMP; GOTO 1 END
11010           END;
11020         RECN:
11030           BEGIN
11040           BACK := PREV;
11050           HEAD := NEXT;
11060           BACK^.NEXT := HEAD;
11070           IF HEAD<>NIL THEN
11080             HEAD^.PREV:= BACK;
11090           FPDEC(PVALUE^); TEMP := PVALUE;
11100           EDISPOSE(ANOBJECT, RECNSIZE);
11110           IF FPTST(TEMP^) THEN BEGIN ANOBJECT := TEMP; GOTO 1 END
11120           END;
11130         CREF:
11140           EDISPOSE(ANOBJECT, CREFSIZE);
11150         REF1:
11160           EDISPOSE(ANOBJECT, REF1SIZE);
11170 (*-01() REF2:
11180           EDISPOSE(ANOBJECT, REF2SIZE); ()-01*)
11190         ROUTINE:
11200           EDISPOSE(ANOBJECT, ROUTINESIZE);
11210         PASCROUT:
11220           EDISPOSE(ANOBJECT, PROUTINESIZE);
11230         STRING:
11240           EDISPOSE(ANOBJECT, STRINGCONST+((STRLENGTH+CHARPERWORD-1) DIV CHARPERWORD)*SZWORD);
11250         UNDEF, NILL:
11260           PCOUNT := 255; (*MUSTN'T BE COLLECTED, OF COURSE*)
11270         COVER:
11280           BEGIN
11290           IF ASSOC THEN
11300             BEGIN FPDEC(ASSREF^); IF FPTST(ASSREF^) THEN GARBAGE(ASSREF) END
11310           ELSE BEGIN
11320             IF OPENED IN STATUS THEN ACLOSE(BOOK);
11330             PFET := BOOK;
11340             IF NOT(STARTUP IN STATUS) THEN DISPOSE(PFET)
11350             END;
11360           EDISPOSE(ANOBJECT, COVERSIZE)
11370           END
11380         END    (*ESAC*)
11390       END    (*OF WITH*)
11400     END;   (*OF GARBAGE*)
11410 (**)
11420 (**)
11430 FUNCTION COPYDESC(ORIGINAL: OBJECTP; NEWSORT: STRUCTYPE): OBJECTP;
11440 (*PRODUCES EITHER A MULT,RECR,REFR OR A REFSLN FROM A MULT OR A REFSLN
11450   N.B. NO PCOUNTS ARE UPDATED*)
11460   VAR NEWDESC: OBJECTP;
11470       COUNT: INTEGER;
11480     BEGIN
11490     COUNT := MULTCONST (*REFSLNCONST*) + (ORIGINAL^.ROWS + 1)*SZPDS;
11500     ENEW(NEWDESC, COUNT);
11510     WITH NEWDESC^ DO
11520       BEGIN
11530       MOVELEFT(ORIGINAL, NEWDESC, COUNT);
11540       SORT := NEWSORT;
11550       PCOUNT := 0;
11560       END;
11570     COPYDESC := NEWDESC
11580     END;
11590 (**)
11600 (**)
11610 (*+01() (*$X6*) ()+01*)
11620 PROCEDURE OPENCOVER(
11630   PFET: FETROOMP; VAR PCOV: OBJECTP; LFN: LFNTYPE; PROCEDURE CH (*-01() ( COV: OBJECTP; L: LFNTYPE) ()-01*)
11640                    );
11650     BEGIN
11660     ENEW(PCOV, COVERSIZE);
11670     WITH PCOV^ DO
11680       BEGIN
11690 (*-02() FIRSTWORD := SORTSHIFT * ORD(COVER) + INCRF; ()-02*)
11700 (*+02() PCOUNT:=1; SORT:=COVER; ()+02*)
11710       BOOK := PFET;
11720       ASSOC := FALSE;
11730       OSCOPE := 1;
11740       CHANNEL := PROC(*-01()H()-01*)(CH);
11750       COFCPOS := 1; LOFCPOS := 1; POFCPOS := 1;
11760       CH(PCOV, LFN);
11770       END
11780     END;
11790 (**)
11800 (**)
11810 PROCEDURE START68;
11820 (*INITIALIZATION OF RUN68*)
11830   VAR PINT: INTPOINT;
11840       CURR: IPOINT;
11850       TEMP: PACKED RECORD CASE SEVERAL OF
11860           1: (INT: INTEGER);
11870           2: (ALF: LFNTYPE);
11880           3: (LFN: PACKED ARRAY [1..7] OF CHAR;
11890       (*+01() EFET1: 0..777777B ()+01*) );
11900           0 , 4 , 5 , 6 , 7 , 8 , 9 , 10 : () ;
11910           END;
11920       (*+01() AW66: ^W66 ; ()+01*)
11930       TEMP1: REALTEGER;
11940       I: INTEGER;
11950       EFET: INTEGER;
11960 (*+01() PROCEDURE ESTART(CURR: IPOINT); EXTERN; ()+01*)
11970 (*+02() PROCEDURE ESTART_(VAR INF,OUTF : TEXT); EXTERN;
11980         FUNCTION MAXR REAL; EXTERN; ()+02*)
11990 (*-02() PROCEDURE STOPEN(
12000     VAR PF: FYL; VAR RF: OBJECTP; LFN: LFNTYPE; PROCEDURE CH (*-01() ( COV: OBJECTP ; L: LFNTYPE ) ()-01*)
12010                   ); EXTERN; ()-02*)
12020     BEGIN
12030 (*+01() CPUCLOCK := -CLOCK; ()+01*)
12040 (*-02() CURR := STATIC(ME)+FIRSTIBOFFSET;
12050         SETMYSTATIC(CURR); ()-02*)
12060 (*+01() ESTART(CURR); (*TO DO ALL THE MACHINE-DEPENDENT INITIALIZATIONS*) ()+01*)
12070 (*+02() ESTART_(INPUT,OUTPUT); (*THIS ALSO SETS UP THE FILES*)
12080         CURR := STATIC(ME);(*ESTART SET UP START68'S STATIC LINK*) ()+02*)
12090     SCOPE := 1;
12100     BITPATTERN.MASK := 0; BITPATTERN.COUNT := 0;
12110     TRACE := NIL;
12120     LEVEL := 0; PROCBL := NIL;
12130     LINENO := 0;
12140 (*+02()INTUNDEF := -32000 -768; ()+02*)
12150     WITH FIRSTRG DO WITH FIRSTW DO
12160       BEGIN
12170       LOOPCOUNT := 0; RGIDBLK := NIL; RECGEN := NIL;
12180       RGSCOPE := 1;
12190       (*-41()
12200       RIBOFFSET := INCPTR( ASPTR( CURR ) , IBCONST ) ;
12210       RGNEXTFREE := INCPTR(RIBOFFSET, RGCONST+SZINT+3*SZADDR (*+02()+3*SZREAL()+02*)) ;
12220       ()-41*)
12230       (*+41()
12240       RIBOFFSET := INCPTR( ASPTR( CURR ) , IBCONST + RGCONST ) ;
12250       RGLASTUSED := INCPTR(RIBOFFSET, -SZINT-3*SZADDR (*+02()-3*SZREAL()+02*)) ;
12260       ()+41*)
12270       END;
12280     ENEW(UNDEFIN, MULTCONST+8*SZPDS);
12290       (*SHOULD BE, INTER ALIA, THE EMPTY STRING AND THE FLATTEST MULT AND AN UNOPENED COVER*)
12300     WITH UNDEFIN^ DO
12310       BEGIN
12320 (*-02() FIRSTWORD := SORTSHIFT * ORD(UNDEF); ()-02*)
12330 (*+02() PCOUNT:=0; SORT:=UNDEF; ()+02*)
12340 (*+01() SECONDWORD := 0; ()+01*)
12350       PCOUNT := 255;
12360       ANCESTOR := UNDEFIN;
12370       OSCOPE := 1;
12380       ENEW(HIGHPCOUNT,MULTCONST+8*SZPDS);
12390       PVALUE := HIGHPCOUNT;
12400       WITH PVALUE^ DO
12410         BEGIN
12420 (*-02() FIRSTWORD := SORTSHIFT * ORD(UNDEF); ()-02*)
12430 (*+02() PCOUNT:=0; SORT:=UNDEF; ()+02*)
12440 (*+01() SECONDWORD := 0; ()+01*)
12450         ANCESTOR := UNDEFIN;
12460         PCOUNT := 255;
12470         PVALUE := UNDEFIN^.PVALUE;
12480         OSCOPE := 1;
12490         OFFSET := HIOFFSET;
12500         ROWS := 7;
12510         STRLENGTH := 0;
12520         STATUS := [];
12530         WITH DESCVEC[0] DO BEGIN LI := MAXBOUND; UI := MINBOUND END;
12540         FOR I := 1 TO 7 DO DESCVEC[I] := DESCVEC[1]
12550         END;
12560       OFFSET := HIOFFSET;
12570       ROWS := 7;
12580       STRLENGTH := 0;
12590       STATUS := [];
12600       WITH DESCVEC[0] DO BEGIN LI := MAXBOUND; UI := MINBOUND END;
12610       FOR I := 1 TO 7 DO DESCVEC[I] := DESCVEC[1]
12620       END;
12630     NILPTR := COPYDESC(UNDEFIN, NILL);
12640     NILPTR^.PCOUNT := 255;
12650     PUTSTRING := CRSTRING(2*REALWIDTH+2*EXPWIDTH+9);
12660     PUTSTRING^.PCOUNT := 255;
12670     ALLCHAR := []; FOR I := 0 TO (*+01()58()+01*) (*-01()MAXABSCHAR()-01*) DO ALLCHAR := ALLCHAR+[CHR(I)];
12680 (*+01() ALLCHAR1 := []; FOR I := 59 TO 63 DO ALLCHAR1 := ALLCHAR1+[CHR(I-59)]; ()+01*)
12690     ENEW(COMPLEX, 2*SZWORD);
12700     COMPLEX^[0] := 2*SZREAL; COMPLEX^[1] := -1;  (*DBLOCK FOR .COMPL*)
12710     ENEW(FILEBLOCK, 12*SZWORD+SZTERMSET); (*DBLOCK FOR FILE*)
12720     FILEBLOCK^[0] := 5*SZADDR+SZTERMSET; FILEBLOCK^[1] := 0; FILEBLOCK^[2] := SZADDR; FILEBLOCK^[3] := 2*SZADDR;
12730     FILEBLOCK^[4] := 3*SZADDR; FILEBLOCK^[5] := 4*SZADDR; FILEBLOCK^[6] := -1;
12740     FILEBLOCK^[7] := 12; FILEBLOCK^[8] := 12; FILEBLOCK^[9] := 12; FILEBLOCK^[10] := 12;
12750     FILEBLOCK^[11] := 0; FOR I := 1 TO SZTERMSET DIV SZWORD DO FILEBLOCK^[11+I] := 1;
12760     NEW(PASCADDR); TEMP1.PROCC := PROC(CALLPASC); PASCADDR^.XBASE := TEMP1.PROCVAL.PROCADD;
12770 (*+54()
12780     ENEW(EXCEPTDB, 4*SZWORD);
12790     EXCEPTDB^[0] := 2*SZINT; EXCEPTDB^[1] := -1;
12800     EXCEPTDB^[2] := 1; EXCEPTDB^[3] := 0;
12810 ()+54*)
12820 (*-44()
12830     LASTRANDOM := ROUND(MAXINT/2);
12840 (*-01() (*-05() HALFPI.ACTUALPI := 2*ARCTAN(1.0); ()-05*) ()-01*)
12850 (*+01() HALFPI.FAKEPI := FAKEPI; ()+01*)
12860 (*+02() PI := 2.0*HALFPI.ACTUALPI;
12870         SMALLREAL := 1.0;
12880         WHILE (1.0+SMALLREAL*2.0>1.0) AND (1.0-SMALLREAL*2.0<1.0) DO SMALLREAL := SMALLREAL/2.0;
12890         MAXREAL := MAXR;
12900 ()+02*)
12910 (*+05() HALFPI.FAKEPI := FAKEPI ; HALFPI.FAKEPI1 := FAKEPI1 ; ()+05*)
12920 ()-44*)
12930     UNINT := INTUNDEF;
12940 (*+02() UNINTCOPY := UNINT; UNDEFINCOPY := UNDEFIN; ()+02*)
12950 (*+01()
12960     WITH TEMP DO
12970       BEGIN
12980       PINT := ASPTR(2); (*1ST PROGRAM PARAMETER*)
12990       INT := PINT^;
13000       IF INT = 0 THEN LFN := 'INPUT::' ;
13010       STOPEN(INPUT, STIN, ALF , STANDINC);
13020       EFET := CURR-FIRSTIBOFFSET+INPUTEFET;
13030       LFN := 'INPUT::'; EFET1 := EFET+1;
13040       PINT^ := INT;
13050       PINT := ASPTR(3); (*2ND PROGRAM PARAMETER*)
13060       INT := PINT^;
13070       IF INT = 0 THEN LFN := 'OUTPUT:' ;
13080       STOPEN(OUTPUT, STOUT, ALF , STANDOUT);
13090       EFET := CURR-FIRSTIBOFFSET+OUTPUTEFET;
13100       AW66 := ASPTR(66B);
13110       IF (AW66^.JOPR=3) AND (LFN='OUTPUT:') THEN WRITELN(OUTPUT, 'STARTING ...');
13120       LFN := 'OUTPUT:'; EFET1 := EFET+1;
13130       PINT^ := INT;
13140       PINT := ASPTR(4);
13150       PINT^ := INT; (*IN CASE USER OPENS ANOTHER FILE ON OUTPUT*)
13160     STBACK := UNDEFIN;
13170       END;
13180 ()+01*)
13190 (*+02()
13200     STOPEN(INPUT, STIN, NIL, STANDINC);
13210     STOPEN(OUTPUT, STOUT, NIL, STANDOUT);
13220     WRITELN(OUTPUT, 'STARTING ...');
13230 ()+02*)
13240 (*+05()
13250     STOPEN(INPUT, STIN, NIL , STANDINC);
13260     STOPEN(OUTPUT, STOUT, NIL , STANDOUT);
13270     WRITELN(ERROR, 'STARTING ...');
13280 ()+05*)
13290     END;
13300 (*+01() (*$X4*) ()+01*)
13310 (**)
13320 (**)
13330 (**)
13340 (**)
13350 PROCEDURE STOP68;
13360 (*+01() PROCEDURE PEND(EFET: INTEGER); EXTERN; ()+01*)
13370 (*+02() PROCEDURE ESTOP_; EXTERN; ()+02*)
13380     BEGIN
13390 (*+05() FLSBUF(STOUT^.PVALUE^.PCOVER^.BOOK^.XFILE, CHR(10)); ()+05*)
13400     WRITELN((*-05()OUTPUT()-05*)(*+05()ERROR()+05*));
13410  WRITELN((*-05()OUTPUT()-05*)(*+05()ERROR()+05*), ' ... AND YET ANOTHER ALGOL68 PROGRAM RUNS TO COMPLETION');
13420     (*+01() WRITELN(OUTPUT, ' CPU ', (CPUCLOCK+CLOCK)/1000:6:3); ()+01*)
13430     (*+05() WRITELN(ERROR, ' CPU ', TIME :5:2); ()+05*)
13440 (*+01() PEND(STATIC(ME)-FIRSTIBOFFSET+OUTPUTEFET) ()+01*)
13450 (*+02() ESTOP_; ()+02*)
13460     END;
13470 (**)
13480 (**)
13490 (**)
13500 (**)
13510 (*-02() BEGIN END ; ()-02*)
13520 (*+01()
13530 BEGIN (*OF MAIN PROGRAM*)
13540 END (*OF EVERYTHING*).
13550 ()+01*)
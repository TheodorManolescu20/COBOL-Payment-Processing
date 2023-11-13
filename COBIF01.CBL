       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBIF01.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CONSOLE IS CNSL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-RECORD                PIC X(23)
                                   VALUE 'RAZVANEUR10004234567GBR'.
       01 WS-OUTPUT-FILE.
          05 WS-OUT-NAME           PIC X(6).
          05 WS-OUT-AMNT           PIC Z,ZZ9.
          05 WS-OUT-CARDNO         PIC 9(7).

       01 WS-REJECT-FILE.
          05 WS-REJ-PREFIX         PIC X(3) VALUE 'REJ'.
          05 FILLER                PIC X(1) VALUE '|'.
          05 WS-REJ-CARDNO         PIC X(7).
          05 FILLER                PIC X(1) VALUE '|'.
          05 WS-REJ-AMNT           PIC 9(4).
          05 FILLER                PIC X(1) VALUE '|'.
          05 WS-REJ-CTRY           PIC X(3).
          05 FILLER                PIC X(1) VALUE '|'.
          05 WS-REJ-REASON         PIC X(15).
             88 REJ-CTRY           VALUE 'CTRY NOT ACC'.
             88 REJ-CT             VALUE 'CT NOT ACC'.

       01 WS-INPUT2.
          05 WS-NAME               PIC X(6).
          05 WS-CURRENCY           PIC X(3).
          05 WS-AMNT               PIC 9(4).
          05 WS-CARDNO.
               10 WS-CARD-TYPE          PIC 9(1).
                  88 CARD-VALID-VALUES  VALUES 4 THRU 6.
                  88 VISA               VALUE 4.
                  88 MST                VALUE 5.
                  88 DIN                VALUE 6.
               10 WS-CARD-NO            PIC X(6).
          05 WS-CARD-SCRTY REDEFINES WS-CARDNO PIC 9(7).

          05 WS-COUNTRY            PIC X(3).
             88 CTRY-VALID-VALUE         VALUE 'GBR','USA','ROM','BGL'.
             88 CTRY-GBR           VALUE 'GBR'.
             88 CTRY-USA           VALUE 'USA'.
             88 CTRY-ROM           VALUE 'ROM'.
             88 CTRY-BGL           VALUE 'BGL'.

       01 WS-RATE-EURGBP           PIC 9(1)V9(2) VALUE 1.1.
       01 WS-RATE-USDGBP           PIC 9(1)V9(2) VALUE 1.2.
       01 WS-RATE-RONGBP           PIC 9(1)V9(2) VALUE 1.3.
       01 WS-RATE-BGNGBP           PIC 9(1)V9(2) VALUE 1.4.

       01 WS-COUNTER               PIC 9 VALUE 0.

       PROCEDURE DIVISION.
           PERFORM UNTIL WS-COUNTER = 8
           ACCEPT WS-INPUT2
           PERFORM 0900-PROCESS-FILE THRU 0909-EXIT
           PERFORM 1000-BUILD-OUTPUT THRU 1009-EXIT
           ADD 1 TO WS-COUNTER
           END-PERFORM.
           STOP RUN.


      **************************************************************
      *PROCESS RECORDS
      **************************************************************

       0900-PROCESS-FILE.
           IF VISA
              EVALUATE TRUE
                 WHEN CTRY-GBR
                    COMPUTE WS-AMNT = WS-AMNT * WS-RATE-EURGBP - 5
                 WHEN CTRY-USA
                    COMPUTE WS-AMNT = WS-AMNT * WS-RATE-USDGBP - 5
                 WHEN CTRY-ROM
                    COMPUTE WS-AMNT = WS-AMNT * WS-RATE-RONGBP - 5
                 WHEN CTRY-BGL
                    COMPUTE WS-AMNT = WS-AMNT * WS-RATE-BGNGBP - 5
                 WHEN OTHER
                   PERFORM 0500-BUILD-REJECT THRU 0509-EXIT
              END-EVALUATE
           END-IF.

           IF MST
              EVALUATE TRUE
                 WHEN CTRY-GBR
                    COMPUTE WS-AMNT = WS-AMNT * WS-RATE-EURGBP - 10
                 WHEN CTRY-USA
                    COMPUTE WS-AMNT = WS-AMNT * WS-RATE-USDGBP - 10
                 WHEN CTRY-ROM
                    COMPUTE WS-AMNT = WS-AMNT * WS-RATE-RONGBP - 10
                 WHEN CTRY-BGL
                    COMPUTE WS-AMNT = WS-AMNT * WS-RATE-BGNGBP - 10
                 WHEN OTHER
                   CALL 'ILBOABN0'
              END-EVALUATE
           END-IF.

           IF DIN
           PERFORM 0500-BUILD-REJECT THRU 0509-EXIT
           END-IF.


       0909-EXIT.


      *************************************************************

      *************************************************************
       0500-BUILD-REJECT.
              MOVE WS-CARD-NO TO WS-REJ-CARDNO.
              MOVE WS-AMNT TO WS-REJ-AMNT.
              MOVE WS-COUNTRY TO WS-REJ-CTRY.
           IF VISA
              SET REJ-CTRY TO TRUE
           ELSE
              IF DIN
                 SET REJ-CT TO TRUE
              END-IF
           END-IF.
              DISPLAY WS-REJECT-FILE UPON CNSL.


       0509-EXIT.
      **************************************************************
      *BUILD OUTPUT RECORD
      **************************************************************

       1000-BUILD-OUTPUT.
           IF NOT DIN
               MOVE WS-NAME TO WS-OUT-NAME
               MOVE WS-AMNT TO WS-OUT-AMNT
               DISPLAY WS-OUTPUT-FILE UPON CNSL
           END-IF.
       1009-EXIT.

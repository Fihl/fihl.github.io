PROGRAM Pr;             { Multiplex Interrupt Test                   }
{$R-,S-,I-,F-,V-,B-,N-}
{$M 16384,0,655360 }
{                                                                    }
{            PR.PAS - Interrupt $24 (Multiplex) Demonstration        }
{                                by                                  }
{                          Duane L. Geiger                           }
{                                                                    }
  USES DOS,CRT,Spool;

  VAR
    Installed : Boolean;          { Print Spooler Installed Switch   }
    Name      : PathName;         { Full Path and Filename           }
    Ch        : Char;             { Used to Pause the Program        }

  BEGIN
    {  The first demonstration is to see if SHARE is installed.  The }
    {  same technique used to detect share can also be used to test  }
    {  any utility which supports 'Get Installed State'.             }

    Installed:=ShareInstalled;         { If Share is Installed       }
    WriteLn('Share Installed: ',Installed,' Error:',Error);

    {  The next part of the program simply checks to see if you have }
    {  Print.Com installed, and if you have DOS Ver 3.0 or greater.  }
    {  If either condition is not met, an error is returned.         }

    Installed:=SpoolerInstalled;       { If Print Spooler Installed  }
    WriteLn('Print.Com Installed: ',Installed,' Error:',Error);
    IF NOT Installed THEN Halt(Error); { Can't Continue this Program }

    {  Now Queue up a name to the print program.                     }

    Name:='Pr.Pas';                    { Name of Actual File to Que  }
    Write('Submitting: ',Name,' - ');  { Print a Test Message        }
    SpoolerSubmit(Name);               { Submit Name to Spooler      }
    IF OK THEN WriteLn('Successful')   { Everything went OK          }
    ELSE WriteLn('Error encountered:',Error); { Display Error Message}

    Name:='Spool.Pas';                 { Submit another file to print}
    Write('Submitting: ',Name,' - ');  { Display a message           }
    SpoolerSubmit(Name);               { Submit Name(s) to Spooler   }
    IF OK THEN WriteLn('Successful')   { Did it work correctly?      }
    ELSE WriteLn('Error encountered:',Error); { of Produce an Error  }

    WriteLn('Press Any Key to Continue');   { Now printing PR.PAS    }
    REPEAT UNTIL KeyPressed;           { Wait for a Keystroke        }
    REPEAT Ch:=Readkey; UNTIL NOT KeyPressed; { Flush keyboard       }

    SpoolerStatusRead;                 { Pause and display queue     }
    IF OK THEN WriteLn('Successful')   { OK on status read           }
    ELSE WriteLn('Error encountered:',Error); { An Error of some type}

    WriteLn('Press Any Key to Continue');   { Another pause          }
    REPEAT UNTIL KeyPressed;           { Get a keystroke             }
    REPEAT Ch:=Readkey; UNTIL NOT KeyPressed; { Flush keyboard again }

    Write('Spooler Release - ');       { Print test message          }
    SpoolerStatusEnd;                  { Start up the print job again}
    IF OK THEN WriteLn('Successful')   { It went OK                  }
    ELSE WriteLn('Error encountered:',Error); { or it failed somehow }

    Write('Canceling: ALL - ');        { Message declaring intent    }
    SpoolerCancelAll;                  { Cancel entire print queue   }
    IF OK THEN WriteLn('Successful')   { It was successful or        }
    ELSE WriteLn('Error encountered:',Error); { it somehow failed    }

    Name:='Pr.Pas';                    { Cancel Individual filename  }
    Write('Canceling: ',Name,' - ');   { Display test message        }
    SpoolerCancel(Name);               { Cancel by name              }
    IF OK THEN WriteLn('Successful')   { It will work                }
    ELSE WriteLn('Error encountered:',Error); { or fail              }

  END.

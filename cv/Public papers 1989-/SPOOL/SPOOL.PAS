UNIT Spool;             {  Print.Com Spool Utility                   }
{                                                                    }
{               SPOOL.PAS - Queue Management Routines                }
{                                by                                  }
{                          Duane L. Geiger                           }
{                                                                    }
INTERFACE               { Globally Known Types and Variables         }

Uses
  DOS;                  { Standard TP4 DOS Unit                      }

TYPE
  PathName  = STRING[64];         { Path and Filename String Area    }

VAR
  OK        : Boolean;            { Global Flag for Success Tests    }
  Error     : Byte;               { Error Flag if Not OK on Interrupt}

{  Possible error conditions encountered in Functions 1 through 5    }
{  Carry Flag is Set and Register AX contains:                       }
{              1 = Function Code Invalid                             }
{              2 = File Not Found                                    }
{              3 = Path Not Found                                    }
{              4 = Too Many Open Files                               }
{              5 = Access Denied                                     }
{              8 = Queue is Full                                     }
{              9 = Spooler Busy                                      }
{            $0C = Name is too long                                  }
{            $0F = Drive is invalid                                  }

FUNCTION  SpoolerInstalled  : Boolean;
PROCEDURE SpoolerSubmit( Name : PathName );
PROCEDURE SpoolerCancel( Name : PathName );
PROCEDURE SpoolerCancelAll;
PROCEDURE SpoolerStatusRead;
PROCEDURE SpoolerStatusEnd;

FUNCTION  ShareInstalled    : Boolean;

IMPLEMENTATION

TYPE
  ZName     = ARRAY[1..64] OF Byte;    { ASCIIZ FileName Area        }

VAR
  Regs      : Registers;          { Registers for DOS Unit Interface }
  Major,                          { Major Version of DOS Installed   }
  Minor     : Word;               { Minor Version of DOS             }

PROCEDURE ASCIIZ( Name : PathName; VAR PassName : ZName );
{  Create an ASCIIZ Name from Pascal String }
  TYPE
    ASCIIZName = RECORD                { Use the Structure of String }
      LnByte : Byte;                   { Length of the String        }
      NStr   : ZName;                  { Actual Characters in String }
    END;

  VAR
    Nme      : ASCIIZName ABSOLUTE Name;    { Point the the String   }

  BEGIN
    Nme.NStr[Nme.LnByte+1] := $00;     { Null Terminate the String   }
    PassName := Nme.Nstr;              { Return the ASCIIZ Portion   }
  END;

FUNCTION SpoolerInstalled : Boolean;
{  TRUE if Spooler Installed, Otherwise FALSE and an Error           }
{       AL Contains installed Status:                                }
{          $00 = Not Installed, OK to Install                        }
{          $01 = Not Installed, Not OK to Install                    }
{          $FF = Installed                                           }
  BEGIN
    {  First test to see if DOS Ver 3.00 or Greater is Running       }
    IF (Major >= 3) AND           { It's version 3.0 or greater      }
       (Minor >= 0) THEN          { Null then  (It's OK for $2F)     }
    ELSE BEGIN                    { This is not a good version of DOS}
      Error            := 1;      { Not Install and Can't Run        }
      SpoolerInstalled := False;  { Function Return                  }
      Exit;                       { Immeditate Exit                  }
    END;                          { of Error Condition               }

    {  Now test to see if resident portion of Print.Com is installed.}
    Error   := 0;                 { Reset System Wide Error          }
    Regs.AH := $01;               { Select Resident Portion of Print }
    Regs.AL := $00;               { Request the Installed Status     }
    Intr($2F,Regs);               { Perform Status Interrupt         }
    IF ((Regs.Flags AND FCarry) <> 0) THEN BEGIN  { Flags Set/Error  }
      SpoolerInstalled := False;  { Set 'Not Installed' Switch       }
      Error            := Regs.AX;{ Load the Error Encountered       }
    END                           { of Error Condition               }
    ELSE                          { The Interrupt Succeeded          }
      SpoolerInstalled := (Regs.AL=$FF); { $FF Indicates Installed   }
  END;

PROCEDURE SpoolerSubmit( Name : PathName );
  TYPE
    Packet = RECORD                    { Submit Packet for Print     }
      Level : Byte;                    { Printer Level               }
      NPtr  : Pointer;                 { Pointer to ASCIIZ Name      }
    END;

  VAR
    SubPack  : Packet;                 { Submit Filename Packet      }
    PassName : Zname;                  { ASCIIZ FileName to Pass     }

  BEGIN
    Error := 0;                        { Clear the Global Error Flag }
    OK    := True;                     { Assume it will work         }
    ASCIIZ( Name , PassName );         { Build an ASCIIZ Name to Pass}
    SubPack.Level := 0;                { Print 'Level'               }
    SubPack.NPtr  := @PassName;        { Pointer to Filename         }
    Regs.AH       := $01;              { Resident Portion of Print   }
    Regs.AL       := $01;              { Submit a File to Print      }
    Regs.DS       := Seg(SubPack);     { Segment Pointer to Packet   }
    Regs.DX       := Ofs(SubPack);     { Offset to SubMission        }
    Intr($2F,Regs);                    { MultiPlex Interrupt         }
    IF ((Regs.Flags AND FCarry) <> 0) THEN BEGIN   { Flags Set/Error }
      OK    := False;                  { Error in File SubMission    }
      Error := Regs.AX;                { Load the Error Variable     }
    END;                               { of Error Handling           }
  END;

PROCEDURE SpoolerCancel( Name : PathName );
{ Remove a Filename, Wildcards are allowed }
  VAR
    PassName : Zname;                  { ASCIIZ FileName to Pass     }

  BEGIN
    Error := 0;                        { Clear the Global Error Flag }
    OK    := True;                     { Assume if will work         }
    ASCIIZ(Name,PassName);             { Build an ASCIIZ Name to Pass}
    Regs.AH := $01;                    { Resident Portion of Print   }
    Regs.AL := $02;                    { Cancel a File in Print Queue}
    Regs.DS := Seg(PassName);          { Pointer to the ASCIIZ Name  }
    Regs.DX := Ofs(PassName);          { Offset to ASCIIZ Name       }
    Intr($2F,Regs);                    { Multiplex Interrupt         }
    IF ((Regs.Flags AND FCarry) <> 0) THEN BEGIN   { Flags Set/Error }
      OK    := False;                  { Error in File SubMission    }
      Error := Regs.AX;                { Load the Error Variable     }
    END;                               { of Error Handling           }
  END;

PROCEDURE SpoolerCancelAll;
{  Remove all names from print queue }
  BEGIN
    Error := 0;                        { Clear the Global Error Flag }
    OK    := True;                     { Assume it will work         }
    Regs.AH := $01;                    { Resident Portion of Print   }
    Regs.AL := $03;                    { Cancel All Files In Queue   }
    Intr($2F,Regs);                    { MultiPlex Interrupt         }
    IF ((Regs.Flags AND FCarry) <> 0) THEN BEGIN { Flags Set if Error}
      OK    := False;                  { Error in File SubMission    }
      Error := Regs.AX;                { Load the Error Variable     }
    END;                               { of Error Handling           }
  END;

PROCEDURE SpoolerStatusRead;
{  Pause the Spooler and Read the names  }
  VAR
    QPtr : ^ZName;                     { Pointer to ASCIIZ String    }
    Idx  : LongInt ABSOLUTE QPtr;      { Index Pointer               }
    I    : Byte;                       { String Index                }
    Name : PathName;                   { Constructed File Name       }

  BEGIN
    Error := 0;                        { Clear the Global Error Flag }
    OK    := True;                     { Assume if will work         }
    Regs.AH := $01;                    { Resident Portion of Print   }
    Regs.AL := $04;                    { Hold for Status Read        }
    Intr($2F,Regs);                    { MultiPlex Interrupt         }
    IF ((Regs.Flags AND FCarry) <> 0) THEN BEGIN { Flags Set if Error}
      OK    := False;                  { Error in File SubMission    }
      Error := Regs.AX;                { Load the Error Variable     }
    END                                { of Error Handling           }
    ELSE BEGIN                         { Display the Queue           }

      { This section displays the names of all of the files that are }
      { currently in the print Queue.  If you want control, modify   }
      { this PROCEDURE to return the pointer to the names and bypass }
      { this display routine.                                        }

      QPtr := Ptr( Regs.DS , Regs.SI );{ Point to First Name in Queue}
      WHILE( QPtr^[1] <> $00 ) DO BEGIN  { Start a Display Loop      }
        I := 1;   Name := '';          { Index Pointer               }
        WHILE( QPtr^[I] <> $00 ) DO BEGIN   { Start displaying Names }
          Name := Name + Chr( QPtr^[I] );{ Build the Name String     }
          I := Succ(I);                { Point to Next Character     }
        END;                           { of a Name Character         }
        WriteLn(Name);                 { Display the Name just built }
        Idx := Idx + 64;               { Point to Next 64 Bytes      }
      END;                             { of Display Loop             }

    END;                               { of Queue Display            }
  END;                                 { of SpoolerStatusRead        }

PROCEDURE SpoolerStatusEnd;
{  Clear the Paused Condition }
  BEGIN
    Error := 0;                        { Clear the Global Error Flag }
    OK    := True;                     { Assume if will work         }
    Regs.AH := $01;                    { Resident Portion of Print   }
    Regs.AL := $05;                    { Clear Status Read           }
    Intr($2F,Regs);                    { MultiPlex Interrupt         }
    IF ((Regs.Flags AND FCarry) <> 0) THEN BEGIN { Flags Set if Error}
      OK    := False;                  { Error in File SubMission    }
      Error := Regs.AX;                { Load the Error Variable     }
    END;                               { of Error Handling           }
  END;

FUNCTION ShareInstalled : Boolean;
  BEGIN
    {  First test to see if DOS Ver 3.00 or Greater is Running       }
    IF (Major >= 3) AND           { It's version 3.0 or greater      }
       (Minor >= 0) THEN          { Null then  (It's OK for $2F)     }
    ELSE BEGIN                    { This is not a good version of DOS}
      Error          := 1;        { Not Install and Can't Run        }
      ShareInstalled := False;    { Function Return                  }
      Exit;                       { Immeditate Exit                  }
    END;                          { of Error Condition               }

    {  Now test to see if resident portion of Share is installed.    }
    Error   := 0;                 { Reset System Wide Error          }
    Regs.AH := $10;               { Select Resident Portion of Share }
    Regs.AL := $00;               { Request the Installed Status     }
    Intr($2F,Regs);               { Perform Status Interrupt         }
    IF ((Regs.Flags AND FCarry) <> 0) THEN BEGIN { Flags Set if Error}
      ShareInstalled := False;    { Set 'Not Installed' Switch       }
      Error          := Regs.AX;  { Load the Error Encountered       }
    END                           { of Error Condition               }
    ELSE                          { The Interrupt Succeeded          }
      ShareInstalled := (Regs.AL = $FF); { $FF Indicates Installed   }
  END;

BEGIN
  {  First test to see if DOS Ver 3.00 or Greater is Running         }
  Regs.AH := $30;                 { Request Version Number           }
  MsDos(Regs);                    { Perform Interrupt $21            }
  Major   := Regs.AL;             { Extract Major Version of DOS     }
  Minor   := Regs.AH;             { Extract Minor Version of DOS     }
END.

Program MORE;
Uses  Crt,DosFilter;
Const Prompt: String[20]='--Endnu mere--';
begin
  DF1:=0;
  while not EOF do begin
    readln(Line); writeln(Line);
    inc(DF1); if (DF1 mod 24)=0 then
    begin
      write(ErrorOutput,Prompt);
      repeat until ReadKey<>#0;
      for DF2:=1 to Length(Prompt) do
        write(ErrorOutput,^H' '^H);
    end;
  end;
end.

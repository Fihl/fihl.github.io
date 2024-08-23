{$i graphics}
const
  xmax=30; ymax=30; zmax=50;
  x0l=-10; x0r=10; z0=-1500;
type
  dot= record dx,dy,dz,x,y,z,xpl,xpr,yp: integer end;
var
  line: boolean;
  ch: char;
  n: integer;
  p1,p2: dot;

procedure init(var d: dot);
begin
  d.dx:=random(5)+2; d.dy:=random(5)+2; d.dz:=random(5)+2;
  d.x:=0; d.y:=0; d.z:=0;
end;

procedure calc3d(var d: dot);
var zfak: real;
begin
  with d do begin
    zfak:=z0/(z0-z);
    yp:=100+round(y*zfak);
    xpl:=160+x0l+round((x-x0l)*zfak);
    xpr:=160+x0r+round((x-x0r)*zfak);
  end;
end;

procedure line3d(var p1,p2: dot);
begin
  if line then begin
    draw(p1.xpl,p1.yp,p2.xpl,p2.yp,2);
    draw(p1.xpr,p1.yp,p2.xpr,p2.yp,1);
  end else begin
    plot(p1.xpl,p1.yp,2); plot(p2.xpl,p2.yp,2);
    plot(p1.xpr,p1.yp,1); plot(p2.xpr,p2.yp,1);
  end;
end;

procedure noline3d(var p1,p2: dot);
begin
  if line then begin
    draw(p1.xpl,p1.yp,p2.xpl,p2.yp,0);
    draw(p1.xpr,p1.yp,p2.xpr,p2.yp,0);
  end else begin
    plot(p1.xpl,p1.yp,0); plot(p2.xpl,p2.yp,0);
    plot(p1.xpr,p1.yp,0); plot(p2.xpr,p2.yp,0);
  end;
end;

procedure newpos(var d: dot);
begin
  with d do begin
    if x<-xmax then dx:=random(5)+2; if x>xmax then dx:=-random(5)-2;
    if y<-ymax then dy:=random(5)+2; if y>ymax then dy:=-random(5)-2;
    if z<-zmax then dz:=random(5)+2; if z>zmax then dz:=-random(5)-2;
    x:=x+dx; y:=y+dy; z:=z+dz;
  end;
end;

procedure makedot(x1,y1,z1: integer; var d:dot);
begin
  d.x:=x1; d.y:=y1; d.z:=z1; calc3d(d);
end;

procedure cube(x,y,z: integer);
var
  x1,y1,z1,x2,y2,z2: integer;
  p1,p2: dot;
begin
  for x1:=0 to 1 do for y1:=0 to 1 do for z1:=0 to 1 do
  for x2:=0 to 1 do for y2:=0 to 1 do for z2:=0 to 1 do begin
    n:=0; if x1=x2 then n:=n+1; if y1=y2 then n:=n+1; if z1=z2 then n:=n+1;
    if n=2 then begin
      makedot(2*x1*x-x,2*y1*y-y,2*z1*z-z,p1);
      makedot(2*x2*x-x,2*y2*y-y,2*z2*z-z,p2);
      line3d(p1,p2);
    end;
  end;
end;

begin
  graphcolormode;
  line:=true;
  cube(2*xmax,2*ymax,4*zmax);
{  line:=false;  }
  init(p1); init(p2);
  repeat
    newpos(p1); newpos(p2);
    calc3d(p1); calc3d(p2);
    line3d(p1,p2);
    for n:=0 to 3000 do;
    noline3d(p1,p2);
  until keypressed; Read(Kbd,ch);
  TextMode;
end.
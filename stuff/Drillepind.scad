// 2024 Christen Fihl Christen@Fihl.net

elephantFootH = 0.3; //Height
elephantFootW = 0.6; //Width

cube=8; //8 mm
spacing=2;
slip=0.3;

a = [ [1,1,1,1],
      [1,1,1,1],
      [0,0,0,0],
      [0,0,0,0,] ];
b = [ [1,1,1,1],
      [1,0,0,1],
      [0,0,1,1],
      [0,0,0,1] ];
c = [ [1,1,1,1],
      [1,0,0,1],
      [0,1,0,0],
      [0,0,0,0] ];
d = [ [1,1,1,1],
      [1,1,1,1],
      [0,0,1,0],
      [0,0,1,0] ];
e = [ [1,1,1,1],
      [0,0,0,0],
      [1,0,0,1],
      [0,0,0,0] ];
f = [ [1,1,1,1],
      [1,1,1,1],
      [1,1,1,1],
      [1,1,1,1] ];

plotAll(0,a);
plotAll(1,b);
plotAll(2,c);
plotAll(3,d);
plotAll(4,e);
plotAll(5,f);

module plotAll(pos,a)
{
  translate([0,-pos*(cube*2+spacing),0])
  difference() 
  {
      union() { // 2*2*8 cubes
          translate([0, 0, elephantFootH])
              cube([8*cube,2*cube,2*cube-elephantFootH]);
          color("green")
          for (y=[0:1])
            for (x=[0:7])
              translate([x*cube, y*cube, 0])
              translate([elephantFootW, elephantFootW, 0])
                cube([cube-elephantFootW*2, cube-elephantFootW*2, elephantFootH]);
//          translate([elephantFootW, elephantFootW, 0])
//            cube([8*cube-elephantFootW*2, 2*cube-elephantFootW*2, elephantFootH]);
      }
      for (z=[0,1])
        for (y=[0:1])
          for (x=[0:3])
            if (a[y+z*2][x]) {
              translate([(x+2.5)*cube, (1.5-y)*cube, (z+0.5)*cube])
                sphere(d = cube+0.5, $fn=18);
            } else 
              translate([(x+2)*cube-slip, (1-y)*cube-slip, z*cube-slip])
                cube([cube+2*slip,cube+2*slip,cube+2*slip]);
      for (z=[0,1])
        for (y=[0:1])
          for (x=[0,1,6,7])
            translate([(x+0.5)*cube, (y+0.5)*cube, (z+0.5)*cube])
              sphere(d = cube+0.5, $fn=18);
  }
}

module hollowCube(xyz,wall)
{
    x = xyz[0];
    y = xyz[1];
    z = xyz[2];
    difference() 
    {
        cube([x,y,z]);
        translate([x/2,y/2,z/2])
          sphere(d = x-wall);
    }
}




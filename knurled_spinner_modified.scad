// bearing_inner_d is the bearing's inner diameter in mm
// bearing_outer_d is the bearing's outer diameter in mm
// bearing_h is the bearing's height in mm
// bevel is presently unused
// cap_th is the thickness of the peg_cap in mm
// debug enables code debugging
// fudge_factor is a small correction to help the model render cleanly in openscan
// number_of_outer_rings is the inner knurl between rings colored blue
// num_bearings is the number of desired bearings, where the first is the center
// wall_th is the thickness of the walls in mm

// tau function
function t (angle) = angle*360;
bearing_inner_d    = 8.3+0.3;
bearing_outer_d    = 22.15;
bearing_h          = 7;
bevel              = 3;
cap_th             = 3;
fnord              = 0;
fudge_factor       = 0.1;
num_bearings       = 7;   // skate bearings. I recommend values between 3 and 7. default 4
                          // issues arise after 8 rings.
rotation           = 0;   // rotate the bearings. default 0. I recommend trying 30, 45, 90.
// works great with solid discs.
solid_discs        = 0;   // make the rings solid. default 0
texture            = 1;   // enable knurling on external rings
wall_th            = 1.5; // inner knurling invisible at values less than 1

// cap variables
thumb_indent_width = 0.8;  // 0.1 - 1.0.  Smaller values make the walls thicker. default 0.8
thumb_indent_depth = 1.10; // 1.05 - 1.20. Smaller values make the indent shallower. default 1.15


// uncomment out one of the two subroutines below. never both at the same time.
// peg_cap();
housing_knurled_3();

module housing_knurled_3() {
  number_of_outer_rings = (num_bearings-1);
  // anything less than 2 will not work
  if (num_bearings <= 3) {
    number_of_outer_rings = 2;
  }

  difference() {
    $fn = 20; // number of fragments, more makes it smoother in the render. default 30

    // main housings
      union() {
        difference() {
          // draw center ring and color it green
          color ([0,1,0]) {
            if (texture == 1) {
              translate([0, 0, 0]) {
                cylinder(r = bearing_outer_d/2+wall_th*3, h = bearing_h, center = true);
              }
            } else {
              translate([0, 0, 0]) {
                cylinder(r = bearing_outer_d/2+wall_th*2, h = bearing_h, center = true);
              }
            }
          }

          // inner knurling needs to start from 0 degrees
          // i.e. 3 cuts are 120 degrees but we want to center at 0 degrees to start
          //      or interval/2
          // 3 rings = 60 180 300
          // 4 rings = 45 135 225 315
          // 5 rings = 72 144 216 288 324
          for (i = [1:(number_of_outer_rings)]) {
            interval = (360/number_of_outer_rings);
            placement = (interval*i)-(interval/2);

            // apply knurling to center ring and color it blue
            color ([0,0,1]) {
              rotate([0, 0, placement])
              translate([bearing_outer_d*1.5-wall_th*1, 0, 0])
              scale([1, 1.3, 1])
              if (texture == 1) {
                translate([0, 0, -bearing_h/1.9]) {
                  knurl(k_cyl_od = bearing_outer_d*1.7, k_cyl_hg = bearing_h+(fudge_factor*2));
                }
              }
            }
          }
        }

        // draw outer rings
        for (i = [1:(number_of_outer_rings)]) {
          // color it red
          color([1,0,0]) {

              rotate([0, 0, i*360/(number_of_outer_rings)])
              if (texture == 1) {
                // rings with knurling
                translate ([bearing_outer_d+wall_th*2, 0, 0])
                rotate(a=rotation, v=[1,0,0]) {
                  knurl(k_cyl_od = bearing_outer_d+wall_th*4, k_cyl_hg = bearing_h, fnord = -bearing_h/2);
                }
            } else {
              // no knurling rings
              translate ([bearing_outer_d+wall_th*2, 0, 0])
              rotate(a=rotation, v=[1,0,0]) {
                cylinder(r = bearing_outer_d/2+wall_th*2, h = bearing_h, center = true);
              }
            }
          }
        }
      }

    // subtract bearing holes
    // position identical for knurled or not.
    cylinder(r = bearing_outer_d/2, h = bearing_h+(fudge_factor), center = true);
    if (solid_discs != 1) {
      for (i = [1:(number_of_outer_rings)]) {
        color([1,1,0])
        rotate([0, 0, i*360/(number_of_outer_rings)])
        rotate(a=rotation, v=[1,0,0]) {
          translate ([bearing_outer_d+wall_th*2, 0, 0])
          cylinder(r = bearing_outer_d/2, h = bearing_h+(fudge_factor), center = true);
        }
      }
    }
  }
}

module peg_cap() {
  $fn = 100; // number of fragments, more makes it smoother in the render. default 100
  extra_d = 0.1;
  difference() {
    union() {
      cylinder(r1 = bearing_inner_d/2-extra_d+(extra_d*2), r2 = bearing_inner_d/2+(extra_d*2), h = bearing_h, center = true);
      translate([0, 0, 0]) cylinder(r = bearing_inner_d/2+2+(extra_d*2), h = 2, center = true);
      translate([0, 0, 0+cap_th/2]) cylinder(r = bearing_outer_d/2, h = cap_th, center = true);
      translate([0, 0, 0])sphere(r = bearing_inner_d/2-extra_d+(extra_d*2), h = cap_th, center = true);
    }
  translate([0, 0, bearing_outer_d+bearing_h])
    scale([thumb_indent_width, thumb_indent_width, thumb_indent_depth])
    sphere(r = bearing_outer_d, center = true);
  }
  if (debug == 1) {
    echo ("DEBUG r1:", bearing_inner_d/2-extra_d+(extra_d*2));
    echo ("DEBUG r2:", bearing_inner_d/2+(extra_d*2));
  }
}


///////////////////
// KNURL LIBRARY //
///////////////////
/*
 * knurledFinishLib_v2.scad
 *
 * Written by aubenc @ Thingiverse
 * http://www.thingiverse.com/aubenc/about
 *
 * This script is in the Public Domain.
 *
 *   http://www.thingiverse.com/thing:31122
 *
 * Derived from knurledFinishLib.scad (also Public Domain license) available at:
 *
 *   http://www.thingiverse.com/thing:9095
 *
 * Usage:
 *
 *	 Drop this script somewhere that OpenSCAD can find it.
 *     ( your current project's working directory/folder or
 *       your OpenSCAD libraries directory/folder )
 *
 *	 Add the line:
 *
 *		 use <knurledFinishLib_v2.scad>
 *
 *	 to your OpenSCAD script and call either:
 *
 *     knurled_cyl( Knurled cylinder height,
 *                  Knurled cylinder outer diameter,
 *                  Knurl polyhedron width,
 *                  Knurl polyhedron height,
 *                  Knurl polyhedron depth,
 *                  Cylinder ends smoothed height,
 *                  Knurled surface smoothing amount );
 *
 *   or:
 *
 *     knurl();
 *
 *	If you use knurled_cyl() module, you will need to specify the values for all
 *    variables. Call the module 'help();' for more detail.
 *  Take a look to the PDF available at http://www.thingiverse.com/thing:9095
 *    for an in-depth description of the knurl properties.
 */

module knurl(
  k_cyl_hg  = 0,
	k_cyl_od  = 0,
	knurl_wd  = 4,
	knurl_hg  = 4,
	knurl_dp  = .5,
	e_smooth  = 2,
	s_smooth  = 0,
  fnord = 0) {
  knurled_cyl(k_cyl_hg, k_cyl_od, knurl_wd, knurl_hg, knurl_dp, e_smooth, s_smooth, fnord);
}

module knurled_cyl(chg, cod, cwd, csh, cdp, fsh, smt, fnord) {
  cord = (cod+cdp+cdp*smt/100)/2;
  cird = cord-cdp;
  cfn = round(2*cird*PI/cwd);
  clf = 360/cfn;
  crn = ceil(chg/csh);

  /*Uncomment for debugging purposes*/
  /*echo("knurled cylinder max diameter: ", 2*cord);*/
  /*echo("knurled cylinder min diameter: ", 2*cird);*/

  if ( fsh < 0 ) {
    union() {
      shape(fsh, cird+cdp*smt/100, cord, cfn*4, chg);
      translate([0, 0, -(crn*csh-chg)/2])
        knurled_finish(cord, cird, clf, csh, cfn, crn);
    }
  } else if ( fsh == 0 ) {
    intersection() {
      cylinder( r = cord-cdp*smt/100, h = chg, $fn = cfn*2, center = false);
      translate([0, 0, -(crn*csh-chg)/2])
        knurled_finish(cord, cird, clf, csh, cfn, crn);
    }
  } else {
    if (fnord != 0) {
      intersection() {
        translate([0,0,fnord])
        shape(fsh, cird, cord-cdp*smt/100, cfn*4, chg);
        translate([0,0,fnord])
          knurled_finish(cord, cird, clf, csh, cfn, crn);
      }
    } else {
      intersection() {
        shape(fsh, cird, cord-cdp*smt/100, cfn*4, chg);
        translate([0, 0, -(crn*csh-chg)/2])
        knurled_finish(cord, cird, clf, csh, cfn, crn);
      }
    }
  }
}

module shape(hsh, ird, ord, fn4, hg) {
  x0 = 0;
  x1 = hsh > 0 ? ird : ord;
  x2 = hsh > 0 ? ord : ird;
  y0 = 0.1;
  y1 = 0;
  y2 = abs(hsh);
  y3 = hg-abs(hsh);
  y4 = hg;
  y5 = hg+0.1;

  if ( hsh >= 0 ) {
    rotate_extrude(convexity = 10, $fn = fn4)
    polygon(points = [[x0, y1], [x1, y1], [x2, y2], [x2, y3], [x1, y4], [x0, y4]],
      			paths  = [[0, 1, 2, 3, 4, 5]]);
  } else {
  	rotate_extrude(convexity = 10, $fn = fn4)
  	polygon(
            points = [[x0, y0], [x1, y0], [x1, y1], [x2, y2],
                      [x2, y3], [x1, y4], [x1, y5], [x0, y5]],
            paths  = [[0, 1, 2, 3, 4, 5, 6, 7]]);
  }
}

module knurled_finish(ord, ird, lf, sh, fn, rn) {
  for (j = [0:rn-1]) {
    h0 = sh*j;
    h1 = sh*(j+1/2);
    h2 = sh*(j+1);
      for(i = [0:fn-1]) {
        lf0 = lf*i;
        lf1 = lf*(i+1/2);
        lf2 = lf*(i+1);
          polyhedron(
            points = [
              [ 0, 0, h0],
              [ ord*cos(lf0), ord*sin(lf0), h0],
              [ ird*cos(lf1), ird*sin(lf1), h0],
              [ ord*cos(lf2), ord*sin(lf2), h0],

              [ ird*cos(lf0), ird*sin(lf0), h1],
              [ ord*cos(lf1), ord*sin(lf1), h1],
              [ ird*cos(lf2), ird*sin(lf2), h1],

              [ 0, 0, h2],
              [ ord*cos(lf0), ord*sin(lf0), h2],
              [ ird*cos(lf1), ird*sin(lf1), h2],
              [ ord*cos(lf2), ord*sin(lf2), h2],
            ],
            faces = [
              [0 , 1, 2], [2, 3, 0], [1 , 0, 4], [4 , 0, 7],
              [7 , 8, 4], [8, 7, 9], [10, 9, 7], [10, 7, 6],
              [6 , 7, 0], [3, 6, 0], [2 , 1, 4], [3 , 2, 6],
              [10, 6, 9], [8, 9, 4], [4 , 5, 2], [2 , 5, 6],
              [6 , 5, 9], [9, 5, 4]
            ],
            convexity = 5);
    }
  }
}

module knurl_help() {
  echo();
  echo("    Knurled Surface Library v2");
  echo("");
  echo("      Modules:");
  echo("");
  echo("        knurled_cyl(parameters... ); - Requires a value for each an every expected parameter (see below)");
  echo("");
  echo("        knurl(); - Call to the previous module with a set of default parameters,");
  echo("                      values may be changed by adding 'parameter_name = value'.");
  echo("                      i.e. knurl(s_smooth = 40);");
  echo("");
  echo("      Parameters: all of them in mm except s_smooth.");
  echo("");
  echo("        k_cyl_hg   -   [  12  ]  ,,  Height for the knurled cylinder");
  echo("        k_cyl_od   -   [  25  ]  ,,  Cylinder's outer diameter before applying the knurled surface finishing.");
  echo("        knurl_wd   -   [  3   ]  ,,  Knurl's Width.");
  echo("        knurl_hg   -   [  4   ]  ,,  Knurl's Height.");
  echo("        knurl_dp   -   [  1.5 ]  ,,  Knurl's Depth.");
  echo("        e_smooth   -   [  2   ]  ,,  Bevel's Height at the bottom and the top of the cylinder");
  echo("        s_smooth   -   [  0   ]  ,,  Knurl's Surface Smoothing:  File down the top of the knurl this value, i.e. 40 will smooth it a 40%.");
  echo("");
}

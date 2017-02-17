# 3d-spinner
openscad spinner code

http://www.thingiverse.com/thing:1969836

Updated 02/17/17:

current:
removed the debuging code.<br>
refactored the code (again).<br>
added ROTATION to the outer rings.<br>
reduced the size of the cylinders that make the holes in the outer rings.<br>
removed a lot of unnecessary code.<br>

older:
Redid the math to better support spinners of 3 to 7 bearings.<br>
Added color to better show the different functions.<br>
Expanded fudge_factor to other loops in the code.<br>
Added more comments to better explain variables, loops, math, etc.<br>
Added debug function to print out variables in openscad. 1 = on, 0 = off.<br>

An edit of the scad code from:

http://www.thingiverse.com/thing:1871997

I added a "fudge_factor" variable to the object to clean up the model in the scad viewer.

I've also updated the knurled surface library code to remove the deprecated function assign and parameter 'triangles' in the polygon function.
This should make the knurled module up to date with the current (12/2016) scad library.

http://www.thingiverse.com/thing:32122

The code has also been refactored to my preferred coding style.

Edited in Atom with the language-openscad plugin.

https://atom.io/

https://atom.io/packages/language-openscad

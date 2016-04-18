//bounce ball
#version 3.7;

#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "metals.inc"
#include "golds.inc"
#include "stones.inc"
#include "woods.inc"
#include "shapes.inc"
#include "shapes2.inc"
#include "functions.inc"
#include "math.inc"
#include "transforms.inc"
#include "skies.inc"

global_settings {
  assumed_gamma 2.2
}

#declare ed = 120;
#declare fpi =2*pi;

#declare tick = clock;

camera {
	//location <-.2, 12, -11.2>
	location <-1.2+cos(tick*fpi*.3)*ed*(.7+tick)*.58,
		 		12+tick*60+(pow(.2,int(tick*100)))*14*int(tick*100)/2,
		  		sin(tick*fpi*.3)*ed*.8 -40>
	look_at <0, 26+sin(fpi*15/16*tick-fpi*3/16)*12, 0>
	angle 80
}

light_source { <100, 1000, -100> color rgb 1.6 }

// 空と霞
sky_sphere {
    S_Cloud5
}

#declare stone = union { 
	sphere{0 1.7  scale <1,1,.6>  translate <0,-.1,0.2>}
	sphere{0  .7  scale <1,1,.6> translate <0,-.3,0.15>}
	box   {0  .2  scale <1,1,.6>  translate <-.2,.1,0.2>}
    texture{ T_Stone15    
        normal { agate 0.25 scale 0.15 rotate<0,0,0> }
        finish { phong 1 } 
        rotate<0,0,0> scale 0.5 translate<0,0,0>
    } // end of texture 
}



object{
	stone 
	translate  <8,.2,12>
	scale 2
	rotate  y*-15
}
object{
	stone 
	translate  <5,0,-22>
	scale 2.4
	rotate  y*-25
}
object{
	stone 
	translate  <-8,.4,-28>
	scale 1.7
	rotate  y*9
}

/*plane {
	-y, 1
	texture {
	pigment { color rgb <.6,.8,.6> }
	}
}
*/
box{<-200,0,-200><200,0.1,200>
	         texture { T_Grnt9
                   //normal { agate 0.15 scale 0.15}
                   finish { phong 0.2 } 
                   scale 6
                 } // end of texture 
}/*
	 // scale your object first!!!
	 texture{ pigment{ brick color White                // color mortar
	                         color rgb<0.4,0,0>    // color brick
	                   brick_size <.8, 0.19, 0.4> // format in x ,y and z- direction 
	                   mortar 0.01                      // size of the mortar 
	                 } // end of pigment
	          normal {wrinkles 0.75 scale 0.01}
	          finish {ambient 0.15 diffuse 0.95 phong 0.2} 
	          scale 4
	          rotate<0,0,0>  translate<-0.01, 0.02,0.10>
	} // end of texture
}*/

#if (tick < .016)
	sphere{<0,30,0> 18 
		pigment{color Clear}
		finish { F_Glass1 }
		interior {I_Glass1 fade_color color rgb <.8,.8,1> caustics 0.88}
	}
#end

#declare BN = 100;
#declare pos = array [BN][3];
#declare vel = array [BN][3];
#declare col = array [BN];

#declare SD = seed(12889);
	
//#ifndef (BOUNCE_BALL)
//	#declare BOUNCE_BALL = 1;
	//#if (tick = 0)
	//#debug concat("DEBUG:BOUNCE_BALL :Value is:",str(tick*100,5,0),"\n")
	
	#for (i,0,BN-1)
		#declare pos[i][0] = (rand(SD)-.5)*18;
		#declare pos[i][2] = (rand(SD)-.5)*18;

		#declare pos[i][1] = rand(SD)*18+16;

		#declare vel[i][0] = (rand(SD)-.5)*1.8;
		#declare vel[i][2] = (rand(SD)-.5)*1.8;
		#declare vel[i][1] = (rand(SD)-.5)*4+1.5;
		
		#declare col[i] = color rgb<rand(SD),rand(SD),rand(SD)>;
	#end
	//#end
//#end

#declare tn = int(tick * 200);
#declare gravi = .18;

#for (i,0,BN-1)
	#for (tm,0,tn-1)
		#declare vel[i][1] =vel[i][1]-gravi;

		#declare pos[i][0] =pos[i][0]+vel[i][0];
		#declare pos[i][1] =pos[i][1]+vel[i][1];
		#declare pos[i][2] =pos[i][2]+vel[i][2];
	
		#if (pos[i][1]-1 <= 0 )
			#declare tv = ((pos[i][1]-1) / vel[i][1])*gravi;
			#declare vel[i][1] = vel[i][1] +tv;
			#declare pos[i][1] = pos[i][1] +tv;
			#declare pos[i][1] = abs(pos[i][1]-1)+1;
			#declare vel[i][1] = abs(vel[i][1])*.92;
			
			#declare vel[i][1] =vel[i][1]-tv;
			#declare pos[i][1] =pos[i][1]-tv;
		#end
	#end
	
	sphere{<pos[i][0],pos[i][1],pos[i][2]> , 1
		pigment{ col[i] }
		finish {ambient .6 specular .4}
	}
		
#end

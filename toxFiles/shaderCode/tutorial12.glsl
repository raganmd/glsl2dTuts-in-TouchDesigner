// GLSL 2D Tutorials | https://www.shadertoy.com/view/Md23DV
// Uğur Güney

/*
	by Uğur Güney. March 8, 2014. 

	Hi! I started learning GLSL a month ago. The speedup gained by using
	GPU to draw real-time graphics amazed me. If you want to learn
	how to write shaders, this tutorial written by a beginner can be
	a starting place for you.

	Please fix my coding errors and grammar errors. :-)
*/

// Ported to TouchDesigner by Matthew Ragan
// matthewragan.com

/*
	Getting your bearings with GLSL can be a bit of a rodeo when
	you're first getting started. Uğur's 2D tuts were a huge help to me
	when I was first getting started, and they often show examples
	that are a little more granular than The Book of Shaders. 

	Hopefully this set of examples will help you get started and 
	get your gl bearings here in Touch.

	When possible, I've copied the examples as faithfully as possible.
	What that means is that there may be better ways to approach some
	challenges - but what you'll find here is as close to the original
	tutorial as I can manage.
*/

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Tutorial 12
// DISK
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// Let's draw disks
//
// So, in GLSL we don't give a command of "draw this disk here with that
// color". Instead we use an indirect command such as "if the pixel 
// coordinate is inside this disk, put that color for the pixel"
// The indirect commands are a bit counter intuitive until you
// get used to that way of thinking.

// uniforms
uniform float uTime;
uniform vec2 uRes;

// functions


out vec4 fragColor;
void main()
{

	// Uğur Güney
	// vec2 r = vec2( fragCoord.xy / iResolution.xy );

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	// Matthew Ragan
	// TouchDesigner provides us with a built in variable
	// that already holds the uvs for our texutre. Normally we'd 
	// you'll see this done other places with fragcoord and the
	// resolution of the scene. We could similarly derive this value
	// like this:
	// vec2 r 		= gl_FragCoord.xy / uTD2DInfos[0].res.zw;
	// here gl_FragCoord provides the pixel value, and uTD2DInfos[0].res.zw
	// provides the xy resolution of our first input.
	//
	// Lucky for us, TouchDesigner provides a built in uniform that 
	// already does this for us - vUV.st
	// for now we'll continue to use Ugur's method, but in the future
	// you'll see that I replace this computation with the line below.
	//
	// Sometimes we need values scaled between -1 and 1 rather than 0 and 1.
	// Since vUV.st is already normalized, we can do this fiarly eaisly 
	// by multiplying this value by 2, and subracting 1.
	//
	// Additionally, we don't always have square viewports, here we can construct
	// a vec2 that will hold an aspect multiplier for both x an y.
	// Next we need to multiply r by aspect. 
	//
	// The results of this will be hard to see here in our square examples, 
	// but try it on your own to see how it works.
	vec2 r 							= ( vUV.st * 2 ) - 1;
	vec2 aspect 					= uRes/uRes.x;
	r 								*= aspect;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	vec3 bgCol 						= vec3(0.3);
	vec3 col1 						= vec3(0.216, 0.471, 0.698); // blue
	vec3 col2 						= vec3(1.00, 0.329, 0.298); // yellow
	vec3 col3 						= vec3(0.867, 0.910, 0.247); // red

	vec3 pixel 						= bgCol;
	
	// To draw a shape we should know the analytic geometrical
	// expression of that shape.
	// A circle is the set of points that has the same distance from
	// it its center. The distance is called radius.
	// The distance from the coordinate center is sqrt(x*x + y*y)
	// Fix the distance as the radius will give the formula for
	// a circle at the coordinate center
	// sqrt(x*x + y*y) = radius
	// The points inside the circle, the disk, is given as
	// sqrt(x*x + y*y) < radius
	// Squaring both sides will give
	// x*x + y*y < radius*radius
	float radius 					= 0.8;
	if( r.x*r.x + r.y*r.y < radius*radius ) {
		pixel = col1;
	}
	
	// There is a shorthand expression for sqrt(v.x*v.x + v.y*v.y)
	// of a given vector "v", which is "length(v)"
	if( length(r) < 0.3) {
		pixel = col3;
	}
	
	// draw a disk of which center is not at (0,0).
	// Say the center is at c: (c.x, c.y). 
	// The distance of any point r: (r.x, r.y) to c is 
	// sqrt((r.x-c.x)^2+(r.y-c.y)^2)
	// define a distance vector d: (r.x - c.x, r.y - c.y)
	// in GLSL d can be calculated "d = r - c".
	// Just as in division, substraction of two vectors is done
	// component by component.
	// Then, length(d) means sqrt(d.x^2+d.y^2)
	// which is the distance formula we are looking for.
	vec2 center = vec2(0.9, -0.4);
	vec2 d = r - center;
	if( length(d) < 0.6) {
		pixel = col2;
	}
	// This shifting of the center of the shape works for any
	// kind of shape. If you have a formula in terms of r
	// f(r) = 0, then f(r-c)=0 expresses the same geometric shape
	// but its coordinate is shifted by c.
	
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -	
	// Matthew Ragan
	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 						= TDOutputSwizzle(vec4(pixel, 1.0));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
}
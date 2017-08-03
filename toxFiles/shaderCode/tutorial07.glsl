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
// Tutorial 7
// COORDINATE TRANSFORMATION
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// 
// Instead of working on screen coordinates, using our own coordinate
// system is more convenient most of the time.
//
// Here we will make and use a new coordinate system "r", instead of
// the absolute screen coordinates "fragCoord". In "r"
// the x and y coordinates will go from 0 to 1. For x, 0 is the left
// side and 1 is the right side. For y, 0 is the bottom side, and 1 is
// the upper side.
//
// Using "r" let's divide the screen into 3 parts.

// uniforms
uniform float uTime;
uniform vec2 uRes;

// functions


out vec4 fragColor;
void main()
{

	// Uğur Güney
	vec2 r 				= vec2(	gl_FragCoord.x / uRes.x,
				  				gl_FragCoord.y / uRes.y);
	// r is a vec2. Its first component is pixel x-coordinate divided by
	// the frame width. And second component is the pixel y-coordinate
	// divided by the frame height.
	//
	// For example, on my laptop, the full screen frame size is
	// 1440 x 900. Therefore iResolution is (1440.0, 900.0).
	// The main function should be run 1440*900=1296000 times to
	// generate a frame.
	// fragCoord.x will have values between 0 and 1439, and
	// fragCoord.y will have values between 0 and 899, whereas
	// r.x and r.y will have values between [0,1].

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
	// vec2 r 				= vUV.st;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	vec3 color1 		= vec3(0.841, 0.582, 0.594);
	vec3 color2 		= vec3(0.884, 0.850, 0.648);
	vec3 color3 		= vec3(0.348, 0.555, 0.641);
	vec3 pixel;
	
	// sugar syntax for "if" conditional. It says
	// "if the x coordinate of a pixel is greater than the half of
	// the width of the screen, then use color1, otherwise use
	// color2."
	if( r.x < 1.0/3.0) {
		pixel 			= color1;
	} else if( r.x < 2.0/3.0 ) {
		pixel 			= color2;
	} else {
		pixel 			= color3;
	}
			
	// pixel = ( r.x < 1.0/3.0 ) ? color1 : (r.x<2.0/3.0) ? color2: color3;
	// same code, single line.
	
	// Matthew Ragan
	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 			= TDOutputSwizzle(vec4(pixel, 1.0));
	
}
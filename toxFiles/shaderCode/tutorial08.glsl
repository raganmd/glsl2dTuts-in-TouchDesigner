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
// Tutorial 8
// HORIZONTAL AND VERTICAL LINES
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
	// vec2 r = vec2( fragCoord.xy / iResolution.xy );
	// shorter version of the same coordinate transformation.
	// For example "aVector.xy" is a new vec2 made of the first two 
	// components of "aVector".
	// And, when division operator is applied between vectors,
	// each component of the first vector is divided by the corresponding
	// component of the second vector.
	// So, first line of this tutorial is the same as the first line
	// of the previous tutorial.

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
	vec2 r 							= vUV.st;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	vec3 backgroundColor 			= vec3(1.0);
	vec3 color1 					= vec3(0.216, 0.471, 0.698);
	vec3 color2 					= vec3(1.00, 0.329, 0.298);
	vec3 color3 					= vec3(0.867, 0.910, 0.247);

	// start by setting the background color. If pixel's value
	// is not overwritten later, this color will be displayed.
	vec3 pixel 						= backgroundColor;
	
	// if the current pixel's x coordinate is between these values,
	// then put color 1.
	// The difference between 0.55 and 0.54 determines
	// the with of the line.
	float leftCoord 				= 0.54;
	float rightCoord 				= 0.55;
	if( r.x < rightCoord && r.x > leftCoord ) pixel = color1;
	
	// a different way of expressing a vertical line
    // in terms of its x-coordinate and its thickness:
	float lineCoordinate 			= 0.4;
	float lineThickness 			= 0.003;
	if(abs(r.x - lineCoordinate) < lineThickness) pixel = color2;
	
	// a horizontal line
	if(abs(r.y - 0.6)<0.01) pixel 	= color3;
	
	// see how the third line goes over the first two lines.
	// because it is the last one that sets the value of the "pixel".

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
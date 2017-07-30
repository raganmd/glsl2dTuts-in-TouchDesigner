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
// Tutorial 10
// MOVING THE COORDINATE CENTER TO THE CENTER OF THE FRAME
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// Instead of mapping [0, iResolution.x]x[0, iResolution.y] region to
// [0,1]x[0,1], lets map it to [-1,1]x[-1,1]. This way the coordinate
// (0,0) will not be at the lower left corner of the screen, but in the
// middle of the screen.

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

	// sometimes we need values scaled between -1 and 1 rather than 0 and 1.
	// Since vUV.st is already normalized, we can do this fiarly eaisly 
	// by multiplying this value by 2, and subracting 1.
	vec2 r 							= ( vUV.st * 2 ) - 1;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	vec3 backgroundColor 			= vec3(1.0);
	vec3 axesColor 					= vec3(0.0, 0.0, 1.0);
	vec3 gridColor 					= vec3(0.5);

	// start by setting the background color. If pixel's value
	// is not overwritten later, this color will be displayed.
	vec3 pixel = backgroundColor;
	
	// Draw the grid lines
	// This time instead of going over a loop for every pixel
    // we'll use mod operation to achieve the same result
    // with a single calculation (thanks to mikatalk)
	const float tickWidth = 0.1;
	if( mod(r.x, tickWidth) < 0.008 ) pixel = gridColor;
    if( mod(r.y, tickWidth) < 0.008 ) pixel = gridColor;
    // Draw the axes
	if( abs(r.x)<0.006 ) pixel = axesColor;
	if( abs(r.y)<0.007 ) pixel = axesColor;
	
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
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
// Tutorial 6
// RESOLUTION, THE FRAME SIZE
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// If you resize your browser, or go to fullscreen mode and come back
// you'll see that the ratio of the width of the first color to the
// second color changes with screen size.
// It is because we set the width of the strip in absolute number of
// pixels, rather than as a proportion of the screen width and height.
//
// Say we want to paint the left and right halves with different colors.
// Without knowing the number of pixels horizontally, we cannot prepare
// a shader that works on all frame sizes.
// 
// How can we learn the screen size (the width and height) in terms of 
// the number of pixel. It is given us in the variable "iResolution".
// "iResolution.x" is the width of the frame, and
// "iResolution.y" is the height of the frame

// Matthew Ragan
// while iResolution is provided by shaderToy as a variable, TouchDesigner
// doesn't have the same provided uniform. We can find this information
// any number of ways, though to stay true to the nature of these tuts
// let's add our own uniform. I've added this as a unifrom on the vectors1
// page in the glslmulti TOP. Additionally, I've declaired the unifrom 
// so it's accesable to use while we're coding.

// uniforms
uniform float uTime;
uniform vec2 uRes;

// functions


out vec4 fragColor;
void main()
{

	// Uğur Güney
	// choose two colors
	vec3 color1 		= vec3(0.741, 0.635, 0.471);
	vec3 color2 		= vec3(0.192, 0.329, 0.439);
	vec3 pixel;
	
	// sugar syntax for "if" conditional. It says
	// "if the x coordinate of a pixel is greater than the half of
	// the width of the screen, then use color1, otherwise use
	// color2."
	pixel 				= ( gl_FragCoord.x > uRes.x / 2.0 ) ? color1 : color2;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -	
	// Matthew Ragan
	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 			= TDOutputSwizzle(vec4(pixel, 1.0));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -	
}
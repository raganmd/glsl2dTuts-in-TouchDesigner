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
// Tutorial 5
// THE COORDINATE SYSTEM
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// "fragCoord", "fragment coordinate" is an input variable.
//
// It tells us at which pixel we are on the screen. The coordinate center
// is the left bottom corner, and coordinate values increases towards
// right and upwards.
//
// The main function is run for each and every pixel on the screen. At
// each call the "gl_FracCoord" has the coordinates of the corresponding
// pixel.
//
// GPUs have many cores, so, the function calls for different pixels
// can be calculated in parallel at the same time.
// This allows higher speeds than the calculation of pixel colors one
// by one in series on the CPU. But, it puts an important constraint too:
// The value of a pixel cannot depend on the value of another pixel. (the
// calculations are done in parallel and it is impossible to know which
// one will finish before the other one)
// The outcome of a pixel can only depend on the pixel coordinate (and
// some other input variables.)
// This is the most important difference of shader programming. We'll
// come to this point again and again
//
// Let's draw something that is not a solid color.

// uniforms
uniform float uTime;

// functions


out vec4 fragColor;
void main()
{

	// Uğur Güney
	// choose two colors
	vec3 color1 = vec3(0.886, 0.576, 0.898);
	vec3 color2 = vec3(0.537, 0.741, 0.408);
	vec3 pixel;
	
	// if the x coordinate is greater than 100 then plot color1
	// else plot color2
	float widthOfStrip = 100.0;
	if( gl_FragCoord.x > widthOfStrip ) {
		pixel = color2;
	} else {
		pixel = color1;
	}

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
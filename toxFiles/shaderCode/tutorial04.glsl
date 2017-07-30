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
// Tutorial 4
// RGB COLOR MODEL AND COMPONENTS OF VECTORS
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// After initialized, the components of vectors can be reached using
// the dot "." notation.
//
// RGB: http://en.wikipedia.org/wiki/RGB_color_model
// A color is represented by three numbers (here in the range [0.0, 1.0])
// The model assumes the addition of pure red, green and blue lights
// of given intensities.
//
// If you lack design skills like me, and having hard time
// in choosing nice looking, coherent set of colors 
// you can use one of these websites to choose color palettes, where
// you can browse different sets of colors 
// https://kuler.adobe.com/create/color-wheel/
// http://www.colourlovers.com/palettes
// http://www.colourlovers.com/colors

// uniforms
uniform float uTime;

// functions


out vec4 fragColor;
void main()
{

	// Uğur Güney
	// play with these numbers:
	float redAmount 	= 0.6; // amount of redness
	float greenAmount 	= 0.2; // amount of greenness
	float blueAmount 	= 0.9; // amount of blueness
	
	vec3 color 			= vec3(0.0); 
	// Uğur Güney
	// Here we only input a single argument. It is a third way of
	// contructing vectors.
	// "vec3(x)" is equivalent to vec3(x, x, x);
	// This vector is initialized as
	// color.x = 0.0, color.y = 0.0; color.z = 0.0;
	color.x 			= redAmount;
	color.y 			= greenAmount;
	color.z 			= blueAmount;
	
	float alpha 		= 1.0;
	vec4 pixel 			= vec4(color, alpha);	

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -	
	// Matthew Ragan
	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 			= TDOutputSwizzle(pixel);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -	
}
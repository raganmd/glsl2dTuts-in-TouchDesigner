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
// Tutorial 2
// SOLID COLOR
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// uniforms
uniform float uTime;

// functions


out vec4 fragColor;
void main()
{

	// Uğur Güney
	//
	// "fragColor" is the output variable of the shader.
	// Its value determines the image on the screen.
	// This shaders sets its value to be the yellow color.

	vec3 color 		= vec3(1.0, 1.0, 0.0);

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	// Matthew Ragan
	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 		= TDOutputSwizzle(vec4( color, 1.0 ));
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -	
}
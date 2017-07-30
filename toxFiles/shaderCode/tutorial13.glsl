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
// Tutorial 13
// FUNCTIONS
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// Functions are great for code reuse. Let's put the code for disks
// into a function and use the function for drawing.
// There are so many different ways of writing a function to draw a shape.
//
// Here we have a void function that does not return anything. Instead,
// "pixel" is taken as an "inout" expression. "inout" is a unique
// keyword of GLSL.
// By default all arguments are "in" arguments. Which
// means, the value of the variable is given to the function scope
// from the scope the function is called. 
// An "out" variable gives the value of the variable from the function
// to the scope in which the function is called.
// An "inout" argument does both. First the value of the variable is
// sent to the function as its argument. Then, that variable is
// processed inside the function. When the function ends, the value
// of the variable is updated where the function is called.
//
// Here, the "pixel" variable that is initialized with the background
// color in the "main" function. Then, "pixel" is given to the "disk"
// function. When the if condition is satisfied the value of the "pixel"
// is changed with the "color" argument. If it is not satified, the
// "pixel" is left untouched and keeps it previous value (which was the
// "bgColor".

// uniforms
uniform float uTime;
uniform vec2 uRes;

// functions
void disk(vec2 r, vec2 center, float radius, vec3 color, inout vec3 pixel) {
	if( length(r-center) < radius) {
		pixel = color;
	}
}

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
	vec3 col2						= vec3(1.00, 0.329, 0.298); // yellow
	vec3 col3 						= vec3(0.867, 0.910, 0.247); // red

	vec3 pixel 						= bgCol;
	
	disk(r, vec2(0.1, 0.3), 0.5, col3, pixel);
	disk(r, vec2(-0.8, -0.6), 1.5, col1, pixel);
	disk(r, vec2(0.8, 0.0), .15, col2, pixel);

	// As you see, the borders of the disks have "jagged" curves, where
	// individual pixels can be seen. This is called "aliasing". It occurs
	// because pixels have finite size and we want to draw a continuous
	// shape on a discontinuous grid.
	// There is a method to reduce the aliasing. It is done by mixing the
	// inside color and outside colors at the border. To achieve this
	// we have to learn some built-in functions.

	// And, again, note the order of disk function calls and how they are
	// drawn on top of each other. Each disk function manipulates
	// the pixel variable. If a pixel is manipulated by multiple disk
	// functions, the value of the last one is sent to fragColor.

	// In this case, the previous values are completely overwritten.
	// The final value only depends to the last function that manipulated
	// the pixel. There are no mixtures between layers.
	
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
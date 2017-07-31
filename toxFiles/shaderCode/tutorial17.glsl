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
// Tutorial 17
// BUILT-IN FUNCTIONS: MIX
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// A shader can be created by first constructing individual parts
// and composing them together.
// There are different ways of how to combine different parts.
// In the previous disk example, different disks were drawn on top
// of each other. There was no mixture of layers. When disks
// overlap, only the last one is visible.
//
// Let's learn mixing different data types (in this case vec3's
// representing colors

// definitions
#define PI 3.14159265359
#define TWOPI 6.28318530718

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
	vec2 p 							= vUV.st;
	
	vec3 bgCol 						= vec3(0.3);
	vec3 col1 						= vec3(0.216, 0.471, 0.698); // blue
	vec3 col2 						= vec3(1.00, 0.329, 0.298); // red
	vec3 col3 						= vec3(0.867, 0.910, 0.247); // yellow 
							
	vec3 ret;
	
	// divide the screen into four parts horizontally for different
	// examples
	if(p.x < 1./5.) { // Part I
		// implementation of mix
		float x0 					= 0.2; // first item to be mixed
		float x1 					= 0.7;  // second item to be mixed
		float m 					= 0.1; // amount of mix (between 0.0 and 1.0)
		// play with this number
		// m = 0.0 means the output is fully x0
		// m = 1.0 means the output is fully x1
		// 0.0 < m < 1.0 is a linear mixture of x0 and x1
		float val 					= x0*(1.0-m) + x1*m;
		ret 						= vec3(val);
	} 
	else if(p.x < 2./5.) { // Part II
		// try all possible mix values 
		float x0 					= 0.2;
		float x1 					= 0.7;
		float m 					= p.y; 
		float val 					= x0*(1.0-m) + x1*m;
		ret 						= vec3(val);		
	} 
	else if(p.x < 3./5.) { // Part III
		// use the mix function
		float x0 					= 0.2;
		float x1 					= 0.7;
		float m 					= p.y; 
		float val 					= mix(x0, x1, m);
		ret 						= vec3(val);		
	}
	else if(p.x < 4./5.) { // Part IV
		// mix colors instead of numbers
		float m 					= p.y;
		ret 						= mix(col1, col2, m);
	}
	else if(p.x < 5./5.) { // Part V
		// combine smoothstep and mix for color transition
		float m 					= smoothstep(0.5, 0.6, p.y);
		ret 						= mix(col1, col2, m);
	}
	
	vec3 pixel 						= ret;

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
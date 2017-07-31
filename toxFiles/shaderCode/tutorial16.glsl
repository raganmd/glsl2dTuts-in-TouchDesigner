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
// Tutorial 16
// BUILT-IN FUNCTIONS: SMOOTHSTEP
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// "smoothstep" function is like step function but instead of a
// sudden jump from 0 to 1 at the edge, it makes a smooth transition
// in a given interval
// http://en.wikipedia.org/wiki/Smoothstep

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
	// use [0,1] coordinate system for this example
	
	vec3 bgCol 						= vec3(0.0); // black
	vec3 col1 						= vec3(0.216, 0.471, 0.698); // blue
	vec3 col2 						= vec3(1.00, 0.329, 0.298); // red
	vec3 col3 						= vec3(0.867, 0.910, 0.247); // yellow

	vec3 pixel 						= bgCol;
	
	float edge, variable, ret;
	
	// divide the screen into four parts horizontally for different
	// examples
	if(p.x < 1./5.) { // Part I
		float edge = 0.5;
		ret 						= step(edge, p.y); // simple step function
	} 
	else if(p.x < 2./5.) { // Part II
		// linearstep (not a builtin function)
		float edge0 				= 0.45;
		float edge1 				= 0.55;
		float t 					= (p.y - edge0)/(edge1 - edge0);
		// when p.y == edge0 => t = 0.0
		// when p.y == edge1 => t = 1.0
		// RHS is a linear function of y
		// so, between edge0 and edge1, t has a linear transition
		// between 0.0 and 1.0
		float t1 					= clamp(t, 0.0, 1.0);
		// t will have negative values when t<edge0 and
		// t will have greater than 1.0 values when t>edge1
		// but we want it be constraint between 0.0 and 1.0
		// so, clamp it!		
		ret 						= t1;
	} 
	else if(p.x < 3./5.) { // Part III
		// implementation of smoothstep
		float edge0 				= 0.45;
		float edge1 				= 0.55;
		float t 					= clamp((p.y - edge0)/(edge1 - edge0), 0.0, 1.0);
		float t1 					= 3.0*t*t - 2.0*t*t*t;
		// previous interpolation was linear. Visually it does not
		// give an appealing, smooth transition.
		// To achieve smoothness, implement a cubic Hermite polynomial
		// 3*t^2 - 2*t^3
		ret 						= t1;
	}
	else if(p.x < 4./5.) { // Part IV
		ret 						= smoothstep(0.45, 0.55, p.y);
	}
	else if(p.x < 5./5.) { // Part V
		// smootherstep, a suggestion by Ken Perlin
		float edge0 				= 0.45;
		float edge1 				= 0.55;
		float t 					= clamp((p.y - edge0)/(edge1 - edge0), 0.0, 1.0);		
		// 6*t^5 - 15*t^4 + 10*t^3
		float t1 					= t*t*t*(t*(t*6. - 15.) + 10.);
		ret 						= t1;
		// faster transition and still smoother
		// but computationally more involved.
	}	
		
	pixel 							= vec3(ret); // make a color out of return value.

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
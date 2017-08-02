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
// Tutorial 28
// RANDOMNESS
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// I don't know why, but GLSL does not have random number generators.
// This does not pose a problem if you are writing your code in
// a programming language that has random functions. That way
// you can generate the random values using the language and send
// those values to the shader via uniforms.
//
// But if you are using a system that only allows you to write
// the shader code, such as ShaderToy, then you need to write your own
// pseuo-random generators.
//
// Here is a pattern that I saw again and again in many different
// shaders at ShaderToy.
// Let's draw N different disks at random locations using this pattern.

#define PI 3.14159265359
#define TWOPI 6.28318530718

// uniforms
uniform float uTime;
uniform vec2 uRes;

// functions
float hash(float seed)
{
	// Return a "random" number based on the "seed"
    return fract(sin(seed) * 43758.5453);
}

vec2 hashPosition(float x)
{
	// Return a "random" position based on the "seed"
	return vec2(hash(x), hash(x * 1.1));
}

float disk(vec2 r, vec2 center, float radius) {
	return 1.0 - smoothstep( radius-0.005, radius+0.005, length(r-center));
}

float coordinateGrid(vec2 r) {
	vec3 axesCol = vec3(0.0, 0.0, 1.0);
	vec3 gridCol = vec3(0.5);
	float ret = 0.0;
	
	// Draw grid lines
	const float tickWidth = 0.1;
	for(float i=-2.0; i<2.0; i+=tickWidth) {
		// "i" is the line coordinate.
		ret += 1.-smoothstep(0.0, 0.005, abs(r.x-i));
		ret += 1.-smoothstep(0.0, 0.01, abs(r.y-i));
	}
	// Draw the axes
	ret += 1.-smoothstep(0.001, 0.005, abs(r.x));
	ret += 1.-smoothstep(0.001, 0.005, abs(r.y));
	return ret;
}

float plot(vec2 r, float y, float thickness) {
	return ( abs(y - r.y) < thickness ) ? 1.0 : 0.0;
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
	vec2 p 							= vUV.st;
	vec2 r 							= ( vUV.st * 2 ) - 1;
	vec2 aspect 					= uRes/uRes.x;
	r 								*= aspect;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	float xMax 						= uRes.x / uRes.y;

	vec3 bgCol 						= vec3(0.3);
	vec3 col1 						= vec3(0.216, 0.471, 0.698); // blue
	vec3 col2 						= vec3(1.00, 0.329, 0.298); // yellow
	vec3 col3 						= vec3(0.867, 0.910, 0.247); // red
	
	vec3 ret 						= bgCol;
	
	vec3 white 						= vec3(1.);
	vec3 gray 						= vec3(.3);
	if(r.y > 0.7) {
		
		// translated and rotated coordinate system
		vec2 q 						= (r-vec2(0.,0.9))*vec2(1.,20.);
		ret 						= mix(white, gray, coordinateGrid(q));
		
		// just the regular sin function
		float y 					= sin(5.*q.x) * 2.0 - 1.0;
		
		ret 						= mix(ret, col1, plot(q, y, 0.1));
	}
	else if(r.y > 0.4) {
		vec2 q 						= (r-vec2(0.,0.6))*vec2(1.,20.);
		ret 						= mix(white, col1, coordinateGrid(q));
		
		// take the decimal part of the sin function
		float y 					= fract(sin(5.*q.x)) * 2.0 - 1.0;
		
		ret 						= mix(ret, col2, plot(q, y, 0.1));
	}	
	else if(r.y > 0.1) {
		vec3 white 					= vec3(1.);
		vec2 q 						= (r-vec2(0.,0.25))*vec2(1.,20.);
		ret 						= mix(white, gray, coordinateGrid(q));
		
		// scale up the outcome of the sine function
		// increase the scale and see the transition from
		// periodic pattern to chaotic pattern
		float scale 				= 10.0;
		float y 					= fract(sin(5.*q.x) * scale) * 2.0 - 1.0;
		
		ret 						= mix(ret, col1, plot(q, y, 0.2));
	}	
	else if(r.y > -0.2) {
		vec3 white 					= vec3(1.);
		vec2 q 						= (r-vec2(0., -0.0))*vec2(1.,10.);
		ret 						= mix(white, col1, coordinateGrid(q));
		
		float seed 					= q.x;
		// Scale up with a big real number
		float y 					= fract(sin(seed) * 43758.5453) * 2.0 - 1.0;
		// this can be used as a pseudo-random value
		// These type of function, functions in which two inputs
		// that are close to each other (such as close q.x positions)
		// return highly different output values, are called "hash"
		// function.
		
		ret 						= mix(ret, col2, plot(q, y, 0.1));
	}
	else {
		vec2 q 						= (r-vec2(0., -0.6));
		
		// use the loop index as the seed
		// and vary different quantities of disks, such as
		// location and radius
		for(float i=0.0; i<6.0; i++) {
			// change the seed and get different distributions
			float seed 				= i + 0.0; 
			vec2 pos 				= (vec2(hash(seed), hash(seed + 0.5))-0.5)*3.;;
			float radius 			= hash(seed + 3.5);
			pos 					*= vec2(1.0,0.3);
			ret 					= mix(ret, col1, disk(q, pos, 0.2*radius));
		}		
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
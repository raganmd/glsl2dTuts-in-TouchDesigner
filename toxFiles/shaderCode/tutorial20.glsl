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
// Tutorial 19
// COLOR ADDITION AND SUBSTRACTION
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// How to draw a shape on top of another, and how will the layers
// below, affect the higher layers?
//
// In the previous shape drawing functions, we set the pixel
// value from the function. This time the shape function will
// just return a float value between 0.0 and 1.0 to indice the
// shape area. Later that value can be multiplied with some color
// and used in determining the final pixel color.

// A function that returns the 1.0 inside the disk area
// returns 0.0 outside the disk area
// and has a smooth transition at the radius

#define PI 3.14159265359
#define TWOPI 6.28318530718

// uniforms
uniform float uTime;
uniform vec2 uRes;
uniform float uRadius 		= 0.35;
uniform vec2 uOffset1 		= vec2(	0.75, 0.3);
uniform vec2 uOffset2 		= vec2(	1.0, 0.0);
uniform vec2 uOffset3 		= vec2(	0.8, 0.25);

// functions
float disk(vec2 r, vec2 center, float radius) {
	float distanceFromCenter = length(r-center);
	float outsideOfDisk = smoothstep( radius-0.005, radius+0.005, distanceFromCenter);
	float insideOfDisk = 1.0 - outsideOfDisk;
	return insideOfDisk;
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
	vec3 black 						= vec3(0.0);
	vec3 white 						= vec3(1.0);
	vec3 gray 						= vec3(0.3);
	vec3 col1 						= vec3(0.216, 0.471, 0.698); // blue
	vec3 col2 						= vec3(1.00, 0.329, 0.298); // red
	vec3 col3 						= vec3(0.867, 0.910, 0.247); // yellow
	
	vec3 ret;
	float d;
	
	if(p.x < 1./3.) { // Part I
		// opaque layers on top of each other
		ret 						= gray;
		// assign a gray value to the pixel first
		d 							= disk(r, vec2(-0.75,0.3), uRadius);
		ret 						= mix(ret, col1, d); // mix the previous color value with
		    						                     // the new color value according to
		    						                     // the shape area function.
		    						                     // at this line, previous color is gray.
		d 							= disk(r, vec2(-0.65,0.0), uRadius);
		ret 						= mix(ret, col2, d);
		d 							= disk(r, vec2(-0.7,-0.3), uRadius); 
		ret							= mix(ret, col3, d); // here, previous color can be gray,
		   							                     // blue or pink.
	} 
	else if(p.x < 2./3.) { // Part II
		// Color addition
		// This is how lights of different colors add up
		// http://en.wikipedia.org/wiki/Additive_color
		ret 						= black; // start with black pixels
		ret 						+= disk(r, vec2(0.0,0.3), uRadius)*col1; // add the new color
		    						                                     // to the previous color
		ret 						+= disk(r, vec2(0.1,0.0), uRadius)*col2;
		ret 						+= disk(r, vec2(0.05,-0.3), uRadius)*col3;
		// when all components of "ret" becomes equal or higher than 1.0
		// it becomes white.
	} 
	else if(p.x < 3./3.) { // Part III
		// Color substraction
		// This is how dye of different colors add up
		// http://en.wikipedia.org/wiki/Subtractive_color
		ret 						= white; // start with white
		ret 						-= disk(r, vec2(0.75,0.3), uRadius)*col1;
		ret 						-= disk(r, vec2(0.65,0.0), uRadius)* col2;
		ret 						-= disk(r, vec2(0.7,-0.25), uRadius)* col3;			
		// when all components of "ret" becomes equals or smaller than 0.0
		// it becomes black.
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
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
// Tutorial 24
// TIME, MOTION AND ANIMATION
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
// One of the inputs that a shader gets can be the time.
// In ShaderToy, "uTime" variable holds the value of the
// time in seconds since the shader is started.
//
// Let's change some variables in time!

#define PI 3.14159265359
#define TWOPI 6.28318530718

// uniforms
uniform float uTime;
uniform vec2 uRes;

// functions
float disk(vec2 r, vec2 center, float radius) {
	return 1.0 - smoothstep( radius-0.005, radius+0.005, length(r-center));
}

float rect(vec2 r, vec2 bottomLeft, vec2 topRight) {
	float ret;
	float d = 0.005;
	ret = smoothstep(bottomLeft.x-d, bottomLeft.x+d, r.x);
	ret *= smoothstep(bottomLeft.y-d, bottomLeft.y+d, r.y);
	ret *= 1.0 - smoothstep(topRight.y-d, topRight.y+d, r.y);
	ret *= 1.0 - smoothstep(topRight.x-d, topRight.x+d, r.x);
	return ret;
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
	float xMax 						= uRes.x/uRes.y;

	vec3 col1 						= vec3(0.216, 0.471, 0.698); // blue
	vec3 col2 						= vec3(1.00, 0.329, 0.298); // yellow
	vec3 col3 						= vec3(0.867, 0.910, 0.247); // red
	
	vec3 ret;
		
	if(p.x < 1./5.) { // Part I
		vec2 q 						= r + vec2(xMax*4./5.,0.);
		ret 						= vec3(0.2);
		// y coordinate depends on time
		float y 					= uTime;
		// mod constraints y to be between 0.0 and 2.0,
		// and y jumps from 2.0 to 0.0
		// substracting -1.0 makes why jump from 1.0 to -1.0
		y 							= mod(y, 2.0) - 1.0;
		ret 						= mix(ret, col1, disk(q, vec2(0.0, y), 0.1) );
	} 
	else if(p.x < 2./5.) { // Part II
		vec2 q 						= r + vec2(xMax*2./5.,0.);
		ret 						= vec3(0.3);
		// oscillation
		float amplitude 			= 0.8;
		// y coordinate oscillates with a period of 0.5 seconds
		float y 					= 0.8*sin(0.5*uTime*TWOPI);
		// radius oscillates too
		float radius 				= 0.15 + 0.05*sin(uTime*8.0);
		ret 						= mix(ret, col1, disk(q, vec2(0.0, y), radius) );		
	} 
	else if(p.x < 3./5.) { // Part III
		vec2 q 						= r + vec2(xMax*0./5.,0.);
		ret 						= vec3(0.4);
		// booth coordinates oscillates
		float x 					= 0.2*cos(uTime*5.0);
		// but they have a phase difference of PI/2
		float y 					= 0.3*cos(uTime*5.0 + PI/2.0);
		float radius 				= 0.2 + 0.1*sin(uTime*2.0);
		// make the color mixture time dependent
		vec3 color 					= mix(col1, col2, sin(uTime)*0.5+0.5);
		ret 						= mix(ret, color, rect(q, vec2(x-0.1, y-0.1), vec2(x+0.1, y+0.1)) );		
		// try different phases, different amplitudes and different frequencies
		// for x and y coordinates
	}
	else if(p.x < 4./5.) { // Part IV
		vec2 q 						= r + vec2(-xMax*2./5.,0.);
		ret 						= vec3(0.3);
		for(float i=-1.0; i<1.0; i+= 0.2) {
			float x 				= 0.2*cos(uTime*5.0 + i*PI);
			// y coordinate is the loop value
			float y 				= i;
			vec2 s 					= q - vec2(x, y);
			// each box has a different phase
			float angle 			= uTime*3. + i;
			mat2 rot 				= mat2(cos(angle), -sin(angle), sin(angle),  cos(angle));
			s 						= rot*s;
			ret 					= mix(ret, col1, rect(s, vec2(-0.06, -0.06), vec2(0.06, 0.06)) );			
		}
	}
	else if(p.x < 5./5.) { // Part V
		vec2 q 						= r + vec2(-xMax*4./5., 0.);
		ret 						= vec3(0.2);
		// let stop and move again periodically
		float speed 				= 2.0;
		float t 					= uTime*speed;
		float stopEveryAngle 		= PI/2.0;
		float stopRatio 			= 0.5;
		float t1 					= (floor(t) + smoothstep(0.0, 1.0-stopRatio, fract(t)) )*stopEveryAngle;
		
		float x 					= -0.2*cos(t1);
		float y 					= 0.3*sin(t1);
		float dx 					= 0.1 + 0.03*sin(t*10.0);
		float dy 					= 0.1 + 0.03*sin(t*10.0+PI);
		ret 						= mix(ret, col1, rect(q, vec2(x-dx, y-dy), vec2(x+dx, y+dy)) );		
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
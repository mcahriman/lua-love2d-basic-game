extern float time;
extern float dimY;
extern float distortionX;
extern float noiseIntensity = 1.7;

//mouse position
extern float mouseX = 0;
extern float mouseY = 0;

//resolution
extern float resX = 0;
extern float resY = 0;

const float PI = 3.14159265359;
const float timeDistortionCoeff = 1;


float random( vec2 p )
{
   // e^pi (Gelfond's constant)
   // 2^sqrt(2) (Gelfond–Schneider constant)
     vec2 K1 = vec2( 23.14069263277926, 2.665144142690225 );

   //return fract( cos( mod( 12345678., 256. * dot(p,K1) ) ) ); // ver1
   //return fract(cos(dot(p,K1)) * 123456.); // ver2
     return fract(cos(dot(p,K1)) * 12345.6789); // ver3
}

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
  // stub all externs

  float time = time;
  float dimY = dimY;
  float distortionX = distortionX;

  float timePhaseShift = time * distortionX; // 10 will be the speed of the effect on time axis
  float localPhaseShift = texture_coords.y * 2 * PI * distortionX; // 10 will be the speed of the effect on y axis
  float screrenPhaseShift = (screen_coords.y / dimY) * 2 * PI * distortionX; // 10 will be the speed of the effect on y axis
  float noisePhaseShift = random(texture_coords) * 2 * PI * noiseIntensity * time; // 10 will be the speed of the effect on y axis

  // get distanse from mouse position
  float mouseDist = distance(vec2(mouseX, mouseY), screen_coords);

  //get distance coeff against resolution (resX, resY)
  
  float slope = 1.5;
  float coef = (1 - smoothstep(50, 150.0, mouseDist)) * slope;
  

  float shift = texture_coords.x 
    + ( sin(screrenPhaseShift) 
    + sin(timePhaseShift) 
    + sin(localPhaseShift)  
    + sin (noisePhaseShift) * coef) * 0.01 ;

  float x  = texture_coords.x; // + shift;

  vec4 texcolor = Texel(texture, vec2(x, texture_coords.y));

  float red = (texcolor.r * (1 - coef ) * 3 + texcolor.g * coef + texcolor.b * coef) / 3 ;
  float green = (texcolor.r * coef + texcolor.g * (1 - coef) * 3 + texcolor.b * coef) / 3;
  float blue = (texcolor.r * coef + texcolor.g * coef + texcolor.b * (1 - coef) * 3) / 3;

  vec4 texcolor_desaturated = 
    vec4(
      red,
      green,
      blue,
      texcolor.a
    );

  return texcolor_desaturated;  
}


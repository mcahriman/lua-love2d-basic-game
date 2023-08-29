extern vec2 mouseVelocity = vec2(0.0, 0.0);
extern vec2 mousePosition = vec2(0.0, 0.0);
extern float time = 0.0;
uniform vec2 resolution =  vec2(0.0, 0.0);
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {

    vec2 uv = screen_coords.xy / resolution.xy;

    // get the relative texture coordinate
    vec2 texCoord = screen_coords.xy / resolution.xy;
    // get the texel for that coordinate
    vec4 texel = Texel(texture, texCoord);

    // create ripple effect
    float x = uv.x - mousePosition.x;
    float y = uv.y - mousePosition.y;
    float d = distance(mousePosition, screen_coords.xy);

    float distanceCoef = 1 - smoothstep(0.0, 100.0, d);

    float ripple = sin(d * 1.0 - time * 4.0) * 0.01 * distanceCoef;
    texCoord.x += ripple;
    texCoord.y += ripple;

    // create lense effect
    // texCoord.x += (distanceCoef) * 0.1;
    // texCoord.y += (distanceCoef) * 0.1;
    

    // mix the ripple effect with the original texture on distance from mousePosition
    float distanceFromMouse = distance(mousePosition, screen_coords.xy);
    float mixAmount = clamp((distanceFromMouse - 0.5) * 3.0, 0.0, 1.0);
    texel = mix(texel, Texel(texture, texCoord), mixAmount);

    return vec4(texel);
}
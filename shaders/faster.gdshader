shader_type canvas_item;

uniform float strength : hint_range(0, 1.0) = 0.0;
uniform float aberration : hint_range(0, 10) = 2.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);
   
    vec4 screen_color = texture(SCREEN_TEXTURE, uv);
    

    float r = texture(SCREEN_TEXTURE, uv + (uv - center) * strength * aberration * 0.01).r;
    float g = texture(SCREEN_TEXTURE, uv).g;
    float b = texture(SCREEN_TEXTURE, uv - (uv - center) * strength * aberration * 0.01).b;
    
    vec3 effect_color = vec3(r, g, b);
   	//effect_color *= 1.0 - (dist * strength * 0.3);
    
    vec3 final_color = mix(screen_color.rgb, effect_color, strength);
    
    COLOR = vec4(final_color, 1.0);
}
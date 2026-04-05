shader_type canvas_item;

uniform float strength : hint_range(0, 1.0) = 0.0;
uniform vec3 color = vec3(0, 0, 0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;
    float dist = distance(uv, vec2(0.5));
    
    vec4 screen_color = texture(SCREEN_TEXTURE, uv);
    
    // Рассчитываем силу виньетки
    float vignette = clamp(pow(dist, 2.5) * strength * 3.0, 0.0, 1.0);
    
    // МИКС: плавно переходим от цвета экрана к твоему цвету (vignette - фактор смешивания)
    vec3 final_rgb = mix(screen_color.rgb, color, vignette);
    
    COLOR = vec4(final_rgb, screen_color.a);
}
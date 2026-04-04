shader_type canvas_item;

uniform float strength : hint_range(0, 1.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;
    // Находим расстояние от центра (0.5, 0.5)
    float dist = distance(uv, vec2(0.5));
    
    // Берем оригинальный цвет экрана
    vec4 screen_color = texture(SCREEN_TEXTURE, uv);
    
    // Создаем маску виньетки: 
    // Чем дальше от центра (dist), тем сильнее эффект.
    // pow(dist, 2.5) делает центр более чистым, а края — темнее.
    float vignette = pow(dist, 2.5) * strength * 3.0;
    
    // Применяем затемнение к цветам
    vec3 final_rgb = screen_color.rgb * (1.0 - vignette);
    
    // Ограничиваем, чтобы не ушло в отрицательные значения
    final_rgb = clamp(final_rgb, 0.0, 1.0);
    
    COLOR = vec4(final_rgb, screen_color.a);
}
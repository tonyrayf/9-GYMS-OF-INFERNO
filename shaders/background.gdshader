shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 0.4;
uniform float pixel_size : hint_range(1.0, 50.0) = 15.0; 
uniform float lava_scale : hint_range(0.1, 10.0) = 1.2;

uniform int color_steps : hint_range(2, 30) = 6;
uniform float smoothness : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    // 1. Пикселизация координат (Screen Space)
    vec2 grid_uv = floor(SCREEN_UV * (1.0 / SCREEN_PIXEL_SIZE) / pixel_size) * pixel_size * SCREEN_PIXEL_SIZE;
    vec2 scaled_uv = grid_uv * lava_scale;

    // 2. Генерация шума (Плазма)
    float t = TIME * speed;
    float noise = sin(scaled_uv.x * 6.0 + t) * 0.5 + 
                  cos(scaled_uv.y * 4.0 - t * 0.7) * 0.5 + 
                  sin(length(scaled_uv - 0.5) * 8.0 + t * 0.4) * 0.3;
    
    float val = (noise + 1.3) / 2.6;

    // 3. Управление гладкостью
    float stepped = floor(val * float(color_steps)) / float(color_steps);
    val = mix(stepped, val, smoothness);

    // 4. НОВАЯ ГАММА ПОД ТВОЙ ПОЛ (Холодный ад)
    // Темные пятна - почти черные с фиолетовым отливом
    vec3 base_dark = vec3(0.05, 0.02, 0.05); 
    // Средний тон - бордовый, как засохшая кровь (подходит под красные крапинки на полу)
    vec3 base_mid  = vec3(0.4, 0.05, 0.1);  
    // Светлый тон - приглушенный красный (чтобы не выжигал глаза)
    vec3 base_light = vec3(0.7, 0.1, 0.1); 

    vec3 final_rgb;
    if (val < 0.5) {
        final_rgb = mix(base_dark, base_mid, val * 2.0);
    } else {
        final_rgb = mix(base_mid, base_light, (val - 0.5) * 2.0);
    }

    // 5. Умножаем на COLOR для управления через Modulate в инспекторе
    COLOR = vec4(final_rgb, 1.0) * COLOR;
}
shader_type canvas_item;

uniform vec2 shadow_offset = vec2(5.0, 5.0); // Смещение тени
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    // Берем ту же текстуру, но со сдвигом и перекрашиваем в черный
    vec4 shadow = texture(TEXTURE, UV - shadow_offset * TEXTURE_PIXEL_SIZE);
    shadow.rgb = shadow_color.rgb;
    shadow.a *= shadow_color.a;

    // Отрисовываем сначала тень, потом самого игрока сверху
    COLOR = mix(shadow, col, col.a);
}
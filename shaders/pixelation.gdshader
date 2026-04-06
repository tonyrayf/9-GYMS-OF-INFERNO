shader_type canvas_item;

uniform float size = 40.0; // Плотность пикселей
uniform float radius = 0.5; // Радиус круга (0.5 — в край)

void fragment() {
    // Пикселизируем UV
    vec2 uv = floor(UV * size) / size;
    
    // Считаем расстояние от центра (0.5, 0.5)
    float dist = distance(uv, vec2(0.5));
    
    // Рисуем текстуру, умножаем на цвет ноды
    vec4 tex_color = texture(TEXTURE, uv) * COLOR;
    
    // Обрезаем всё, что за радиусом (делаем круг)
    if (dist > radius) {
        tex_color.a = 0.0;
    }
    
    COLOR = tex_color;
}
shader_type canvas_item;

// Цвет свечения
uniform vec4 glow_color : source_color = vec4(1.0, 0.84, 0.0, 1.0);
// Максимальный радиус свечения в пикселях
uniform float glow_width : hint_range(0.0, 32.0) = 5.0;
// Общая интенсивность свечения
uniform float glow_intensity : hint_range(0.0, 3.0) = 1.0;
// Порог прозрачности самого спрайта
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.5;
// Количество колец выборки (больше = плавнее, но дороже)
uniform int samples : hint_range(4, 32) = 8;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec2 pixel_size = TEXTURE_PIXEL_SIZE;
    
    // Если это тело персонажа — рисуем его как есть
    if (tex_color.a > alpha_threshold) {
        COLOR = tex_color;
    } else {
        // Иначе считаем суммарное свечение от соседей
        float glow_accum = 0.0;
        
        // Проходим по нескольким кольцам на разном расстоянии
        for (int i = 1; i <= samples; i++) {
            float dist = float(i) / float(samples); // от 0 до 1
            float radius = dist * glow_width;
            
            // Чем дальше — тем меньше вклад (квадратичное затухание)
            float falloff = 1.0 - dist;
            falloff = falloff * falloff;
            
            // Проверяем 8 направлений вокруг текущего пикселя
            vec2 offset = pixel_size * radius;
            float ring_alpha = 0.0;
            
            ring_alpha = max(ring_alpha, texture(TEXTURE, UV + vec2(-offset.x, 0.0)).a);
            ring_alpha = max(ring_alpha, texture(TEXTURE, UV + vec2( offset.x, 0.0)).a);
            ring_alpha = max(ring_alpha, texture(TEXTURE, UV + vec2(0.0, -offset.y)).a);
            ring_alpha = max(ring_alpha, texture(TEXTURE, UV + vec2(0.0,  offset.y)).a);
            ring_alpha = max(ring_alpha, texture(TEXTURE, UV + vec2(-offset.x, -offset.y)).a);
            ring_alpha = max(ring_alpha, texture(TEXTURE, UV + vec2( offset.x, -offset.y)).a);
            ring_alpha = max(ring_alpha, texture(TEXTURE, UV + vec2(-offset.x,  offset.y)).a);
            ring_alpha = max(ring_alpha, texture(TEXTURE, UV + vec2( offset.x,  offset.y)).a);
            
            // Если на этом кольце есть тело — добавляем его вклад
            if (ring_alpha > alpha_threshold) {
                glow_accum = max(glow_accum, falloff);
            }
        }
        
        // Итоговый цвет свечения с учётом интенсивности
        float final_alpha = glow_accum * glow_intensity;
        COLOR = vec4(glow_color.rgb, glow_color.a * final_alpha);
    }
}
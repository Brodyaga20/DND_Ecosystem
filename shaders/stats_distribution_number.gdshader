shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.7, 0.85, 1.0, 1.0);

// Радиус ореола (в пикселях текстуры)
uniform float glow_radius : hint_range(0.0, 30.0) = 0.0;

// Интенсивность свечения
uniform float glow_intensity : hint_range(0.0, 5.0) = 0;

// Скорость пульсации
uniform float pulse_speed : hint_range(0.0, 5.0) = 5;

// Амплитуда пульсации
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.25;

// Насколько свечение «залезает» внутрь цифры. 0 = цифра чистая, 1 = цифра подсвечена изнутри
uniform float inner_bleed : hint_range(0.0, 1.0) = 0.15;

void fragment() {
    // Исходный цвет цифры (чёрный + альфа)
    vec4 base = texture(TEXTURE, UV);

    // Пульсация во времени
    float pulse = 1.0 + sin(TIME * pulse_speed * 6.283185) * pulse_amount;

    // --- Построение ореола вокруг цифры ---
    float glow_alpha = 0.0;
    const int SAMPLES = 16;
    const int RADIUS_STEPS = 6;
    float angle_step = 6.283185 / float(SAMPLES);

    for (int i = 0; i < SAMPLES; i++) {
        float angle = float(i) * angle_step;
        vec2 dir = vec2(cos(angle), sin(angle));

        for (int r = 1; r <= RADIUS_STEPS; r++) {
            float t = float(r) / float(RADIUS_STEPS);
            vec2 offset = dir * t * glow_radius * TEXTURE_PIXEL_SIZE;
            float a = texture(TEXTURE, UV + offset).a;
            glow_alpha += a * (1.0 - t);   // затухание к краю
        }
    }

    glow_alpha /= float(SAMPLES * RADIUS_STEPS);
    glow_alpha *= glow_intensity * pulse * 3.0;
    glow_alpha = clamp(glow_alpha, 0.0, 1.0) * glow_color.a;

    // --- Сборка итогового изображения ---
    // Сама цифра — оригинального цвета (чёрная). Ничего не прибавляем.
    // Ореол — только там, где цифры нет (base.a < 1). Внутри цифры свечение почти исчезает.
    float glow_mask = mix(1.0, inner_bleed, base.a);
    float final_glow_a = glow_alpha * glow_mask;

    // Смешиваем: где цифра — её цвет, где пусто — цвет свечения
    vec3 final_rgb = mix(glow_color.rgb, base.rgb, base.a);
    float final_a = max(final_glow_a, base.a);

    COLOR = vec4(final_rgb, final_a);
}
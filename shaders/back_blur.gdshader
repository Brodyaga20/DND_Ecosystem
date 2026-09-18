shader_type canvas_item;

// Экранная текстура с мипмапами для размытия
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

// Максимальная сила размытия в центре (чем больше — тем сильнее размыто в центре)
uniform float max_blur_lod : hint_range(0.0, 5.0) = 2.0;

// Где начинается затухание (0 = от самого центра)
uniform float inner : hint_range(0.0, 1.5) = 0.0;

// Где размытие полностью пропадает (1.0 ≈ края по короткой стороне)
uniform float outer : hint_range(0.05, 1.5) = 0.8;

// Кривая градиента: 1.0 = линейно, >1 = резче к центру, <1 = плавнее
uniform float falloff : hint_range(0.1, 4.0) = 0.1;

// Тонирование «матового стекла» (как в macOS/Windows 11). Alpha = 0 → без тона.
uniform vec4 tint : source_color = vec4(0.0, 0.0, 0.0, 0.0);

void fragment() {
    // Нормализованное расстояние от центра: 0 в центре, ~1 у краёв
    vec2 centered = UV - vec2(0.5);
    float d = length(centered) * 0.5;

    // Маска: 1 в центре → 0 к краю
    float mask = 1.0 - smoothstep(inner, outer, d);
    mask = pow(clamp(mask, 0.0, 1.0), falloff);

    // Размытие через mipmap-уровни с плавной интерполяцией между ними
    float lod = max_blur_lod * mask;
    float lod_low  = floor(lod);
    float lod_high = ceil(lod);
    vec3  bg_low   = textureLod(screen_texture, SCREEN_UV, lod_low).rgb;
    vec3  bg_high  = textureLod(screen_texture, SCREEN_UV, lod_high).rgb;
    vec3  blurred  = mix(bg_low, bg_high, fract(lod));

    // Тонируем размытый фон
    vec3 tinted = mix(blurred, tint.rgb, tint.a);

    // Оригинал (без размытия) — чтобы у самых краёв эффект полностью исчезал
    vec3 original = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

    COLOR.rgb = mix(original, tinted, mask);
    COLOR.a = 1.0;
}
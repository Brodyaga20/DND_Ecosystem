extends GlowSprite
class_name GlowMathSign

func _ready() -> void:
	_mat = material.duplicate() as ShaderMaterial
	print(_mat)
	if new_texture:
		sprite.texture = new_texture
	_mat.set_shader_parameter("glow_width", glow_off)
	_mat.set_shader_parameter("glow_color", glow_color)
	print(material)
	sprite.material = _mat
	area.mouse_entered.connect(_on_enter)
	area.mouse_exited.connect(_on_exit)
	area.input_event.connect(_on_area_input_event)

func _on_enter() -> void:
	is_hovered = true
	refresh()

func _on_exit() -> void:
	is_hovered = false
	refresh()

func _on_area_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("selected", self)
		refresh()

func set_selected(v: bool) -> void:
	is_selected = v
	refresh()

func refresh() -> void:
	var target := glow_off
	if is_selected:
		target = glow_selected
	elif is_hovered:
		target = glow_hover
	tween_glow(target)

func tween_glow(target: float) -> void:
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_method(
		func(v): _mat.set_shader_parameter("glow_width", v),
		_mat.get_shader_parameter("glow_width"),
		target,
		duration
	)

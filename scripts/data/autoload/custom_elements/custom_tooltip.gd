extends CanvasLayer

@export var default_style: TooltipStyle
@export var new_offset: Vector2 = Vector2(16, 16)

var _root: Control
var _panel: PanelContainer
var _vbox: VBoxContainer
var _active := false

func _ready() -> void:
	_root = Control.new()
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	_panel = PanelContainer.new()
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_panel)

	_vbox = VBoxContainer.new()
	_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_vbox.add_theme_constant_override("separation", 0)
	_panel.add_child(_vbox)

	hide()

# ---------- Public API ----------

func show_lines(lines: Array[String], style: TooltipStyle = null) -> void:
	if lines.is_empty():
		return
	var s := style if style else default_style
	if not s:
		return
	_apply_style(s)
	_build_lines(lines, s)
	
	_active = true
	# Ждём 2 кадра: первый — чтобы Label пересчитал минимум, второй — чтобы PanelContainer пересобрался
	await get_tree().process_frame
	await get_tree().process_frame
	_panel.reset_size()
	_update_position()
	show()

func hide_tooltip() -> void:
	_active = false
	hide()

# ---------- Internal ----------

func _apply_style(s: TooltipStyle) -> void:
	var sb: StyleBox
	if s.background_texture:
		var t := StyleBoxTexture.new()
		t.texture = s.background_texture
		t.texture_margin_left = s.texture_margins_left
		t.texture_margin_top = s.texture_margins_top
		t.texture_margin_right = s.texture_margins_right
		t.texture_margin_bottom = s.texture_margins_bottom
		sb = t
	elif s.style_box:
		sb = s.style_box.duplicate()
	else:
		sb = StyleBoxFlat.new()

	sb.content_margin_left = s.padding_left
	sb.content_margin_top = s.padding_top
	sb.content_margin_right = s.padding_right
	sb.content_margin_bottom = s.padding_bottom

	_panel.add_theme_stylebox_override("panel", sb)

func _build_lines(lines: Array[String], s: TooltipStyle) -> void:
	for child in _vbox.get_children():
		child.queue_free()

	for i in lines.size():
		var label := Label.new()
		label.text = lines[i]
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if s.font:
			label.add_theme_font_override("font", s.font)
		label.add_theme_font_size_override("font_size", s.font_size)
		label.add_theme_color_override("font_color", s.font_color)
		_vbox.add_child(label)

		if s.show_dividers and i < lines.size() - 1:
			_vbox.add_child(_create_divider(s))

func _create_divider(s: TooltipStyle) -> Control:
	var wrapper := MarginContainer.new()
	wrapper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wrapper.add_theme_constant_override("margin_top", s.divider_margin)
	wrapper.add_theme_constant_override("margin_bottom", s.divider_margin)

	if s.divider_texture:
		var tr := TextureRect.new()
		tr.texture = s.divider_texture
		tr.stretch_mode = TextureRect.STRETCH_SCALE
		tr.custom_minimum_size.y = s.divider_height
		tr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		wrapper.add_child(tr)
	else:
		var cr := ColorRect.new()
		cr.color = s.divider_color
		cr.custom_minimum_size.y = s.divider_height
		cr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		wrapper.add_child(cr)

	return wrapper

func _update_position() -> void:
	if not _active: return
	_panel.global_position = get_viewport().get_mouse_position() + new_offset
	var screen := get_viewport().get_visible_rect().size
	var rect := _panel.get_global_rect()
	if rect.end.x > screen.x:
		_panel.global_position.x -= rect.size.x + new_offset.x * 2
	if rect.end.y > screen.y:
		_panel.global_position.y -= rect.size.y + new_offset.y * 2

func _process(_delta: float) -> void:
	if _active:
		_update_position()

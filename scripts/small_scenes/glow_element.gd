extends Control
class_name GlowElement

signal selected(sprite: GlowElement)
signal id_selected(id: String)
signal id_pressed(id: String)

enum SelectionMode { MANUAL, RADIO, TOGGLE, FLASH }

@export var target_visual: CanvasItem
@export var selection_mode: SelectionMode = SelectionMode.MANUAL
@export var radio_group_name: String = "glow_radio_group"
@export var auto_size_visual: bool = true
@export var display_name: String = ""   # сюда пишешь id, например "agility"

@export_group("Glow Settings")
@export var glow_off: float = 0.0
@export var glow_hover: float = 5.0
@export var glow_selected: float = 14.0
@export var duration: float = 0.1
@export var glow_color: Color = Color(1, 1, 1)

var _flash_tween: Tween
var _mat: ShaderMaterial
var _tween: Tween
var is_hovered := false
var is_selected := false

func _ready() -> void:
	
	if not target_visual:
		for child in get_children():
			if child is CanvasItem:
				target_visual = child
				break

	if target_visual:
		if target_visual.material:
			_mat = target_visual.material.duplicate() as ShaderMaterial
		else:
			_mat = material.duplicate()
			
		_mat.set_shader_parameter("glow_width", glow_off)
		_mat.set_shader_parameter("glow_color", glow_color)
		target_visual.material = _mat

		if selection_mode == SelectionMode.RADIO:
			add_to_group(radio_group_name)

		if target_visual is Control:
			target_visual.item_rect_changed.connect(_update_size)
		elif target_visual is Sprite2D:
			target_visual.texture_changed.connect(_update_size)

	_update_size()

	mouse_entered.connect(_on_enter)
	mouse_exited.connect(_on_exit)
	gui_input.connect(_on_gui_input)


func _update_size() -> void:
	if not target_visual:
		return

	var visual_size := Vector2.ZERO

	if target_visual is Label:
		visual_size = target_visual.get_minimum_size()
	elif target_visual is Control:
		visual_size = target_visual.size
	elif target_visual is Sprite2D:
		if target_visual.texture:
			visual_size = target_visual.texture.get_size() * target_visual.scale

	if visual_size == Vector2.ZERO:
		return

	size = visual_size
	pivot_offset = size / 2

	if target_visual is Sprite2D:
		if target_visual.centered:
			target_visual.position = size / 2
		else:
			target_visual.position = Vector2.ZERO
	elif target_visual is Control:
		target_visual.position = Vector2.ZERO
		target_visual.size = visual_size


func _on_enter() -> void:
	is_hovered = true
	refresh()

func _on_exit() -> void:
	is_hovered = false
	refresh()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_click_behavior()
		emit_signal("selected", self)
		emit_signal("id_pressed", display_name)
		emit_signal("id_selected", display_name)

func _handle_click_behavior() -> void:
	match selection_mode:
		SelectionMode.MANUAL:
			pass

		SelectionMode.RADIO:
			get_tree().call_group(radio_group_name, "set_selected", false)
			set_selected(true)

		SelectionMode.TOGGLE:
			set_selected(!is_selected)

		SelectionMode.FLASH:
			if _flash_tween and _flash_tween.is_running():
				_flash_tween.kill()
			_flash_tween = create_tween()
			_flash_tween.tween_callback(func(): set_selected(true))
			_flash_tween.tween_interval(duration * 2)
			_flash_tween.tween_callback(func(): set_selected(false))

# ---------- Состояние ----------

func set_selected(v: bool) -> void:
	is_selected = v
	refresh()

func refresh() -> void:
	if not _mat:
		return
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

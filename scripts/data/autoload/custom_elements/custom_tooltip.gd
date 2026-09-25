extends CanvasLayer
class_name Tooltip

@onready var _panel: PanelContainer = $Panel
@onready var _label: Label = $Panel/Label

var _offset := Vector2(16, 16)
var _active := false

func _ready() -> void:
	hide()
	# Чтобы панель не ловила мышь
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _update_position() -> void:
	if not _active: return
	_panel.global_position = get_viewport().get_mouse_position() + _offset
	var screen := get_viewport().get_visible_rect().size
	var rect := _panel.get_global_rect()
	if rect.end.x > screen.x:
		_panel.global_position.x -= rect.size.x + _offset.x * 2
	if rect.end.y > screen.y:
		_panel.global_position.y -= rect.size.y + _offset.y * 2

func show_at(text: String, _ignored_pos: Vector2) -> void:
	_label.text = text
	show()
	_active = true
	await get_tree().process_frame
	_update_position()

func _process(_delta: float) -> void:
	if _active:
		_update_position()

func hide_tooltip() -> void:
	_active = false
	hide()

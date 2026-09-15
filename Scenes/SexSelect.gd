extends Node2D

@onready var man = load("res://Assets/Pictures/BackGrounds/SexSelect/Man.png")
@onready var woman = load("res://Assets/Pictures/BackGrounds/SexSelect/Noman.png")
func _ready():
	$Next.disabled = true

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/RaceSelect.tscn")
	pass # Replace with function body.


func _on_man_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_sex("man")
			change_back(man)

func _on_woman_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_sex("woman")
			change_back(woman)

func change_back(sex):
	$Background.texture = sex

func select_sex(sex: String):
	TempData.sex = sex
	match sex:
		"man":
			$Blur/Label2.text = "Мужской"
		"woman":
			$Blur/Label2.text = "Женский"

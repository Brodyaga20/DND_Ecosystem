extends Node2D

@onready var man = load("res://assets/pictures/backgrounds/sex_select/left/man_select.png")
@onready var woman = load("res://assets/pictures/backgrounds/sex_select/right/woman_select.png")
@onready var preselect_man = load("res://assets/pictures/backgrounds/sex_select/left/man_preselect.png")
@onready var preselect_woman = load("res://assets/pictures/backgrounds/sex_select/right/woman_preselect.png")
@onready var normal_left = load("res://assets/pictures/backgrounds/sex_select/left/normal.png")
@onready var normal_right = load("res://assets/pictures/backgrounds/sex_select/right/normal.png")
var selected_sex = ""
enum sex_types {MAN, WOMAN}
func _ready():
	$Next.disabled = true

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/race_select.tscn")
	pass # Replace with function body.

func _on_man_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_sex("man")
			change_left_back(man)
			change_right_back(normal_right)
			selected_sex = "man"

func _on_woman_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_sex("woman")
			change_right_back(woman)
			change_left_back(normal_left)
			selected_sex = "woman"

func change_right_back(right):
	$Backs/BackgroundRight.texture = right

func change_left_back(left):
	$Backs/BackgroundLeft.texture = left

func select_sex(sex: String):
	TempData.sex = sex
	match sex:
		"man":
			$Blur/Label2.text = "Мужской"
		"woman":
			$Blur/Label2.text = "Женский"
	$Next.disabled = false

func _on_man_area_mouse_entered() -> void:
	preselect("left", preselect_man)
	pass # Replace with function body.

func _on_woman_area_mouse_entered() -> void:
	preselect("right", preselect_woman)
	pass # Replace with function body.

func _on_man_area_mouse_exited() -> void:
	clear_select("man")

func _on_woman_area_mouse_exited() -> void:
	clear_select("woman")
	
func preselect(side: String, new_back):
	match side:
		"left":
			if selected_sex != "man":
				change_left_back(new_back)
		"right":
			if selected_sex != "woman":
				change_right_back(new_back)

func clear_select(sex):
	if selected_sex == "":
		change_left_back(normal_left)
		change_right_back(normal_right)
	if sex == "man" and selected_sex == "woman":
		change_left_back(normal_left)
	if sex == "woman" and selected_sex == "man":
		change_right_back(normal_right)

func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/personal_info.tscn")
	pass # Replace with function body.

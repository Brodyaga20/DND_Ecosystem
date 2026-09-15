extends Node2D

var subclass = ""
var wayback = ""
var selected_race_id = ""
var preselected_race_id = ""
var mixed_blood = false
var mixed_blood_name = ""
@onready var sprites = { "human": $HighlightedSprites/Human/Human, "drow": $HighlightedSprites/Drow/Drow,
						 "gnome": $HighlightedSprites/Gnome/Gnome, "chitin": $HighlightedSprites/Chitin/Chitin,
						 "avian": $HighlightedSprites/Avian/Avian, "giant": $HighlightedSprites/Giant/Giant,
						 "owlin": $HighlightedSprites/Owlin/Owlin, "aasimar": $HighlightedSprites/Aasimar/Aasimar }

func _ready():
	subclass = TempData.subclass_id
	if subclass == "mage":
		wayback = "res://scenes/mage_subclass_select.tscn"
	elif subclass == "assasin":
		wayback = "res://scenes/sogue_subclass_select.tscn"
	else:
		wayback = "res://scenes/warrior_subclass_select.tscn"
	for child in get_tree().get_nodes_in_group("characters"):
		child.visible = false
	$Next.disabled = true
	$Blur/NameLabel.text = ""
	$Blur/DescriptionLabel.text = ""

func select_race(race_id: String):
	selected_race_id = race_id
	TempData.race_id = race_id
	var race_data = DataManager.get_race_data(race_id)
	if race_data:
		if !mixed_blood:
			clear_highlight()
			$Blur/NameLabel.text = race_data["name"]
			$Blur/DescriptionLabel.text = race_data["description"]
			sprites[race_id].visible = true
		else:
			sprites[race_id].visible = !sprites[race_id].visible
		$Next.disabled = false

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(wayback)
	pass # Replace with function body.

func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sex_select.tscn")
	pass # Replace with function body.

func clear_highlight():
	for child in get_tree().get_nodes_in_group("characters"):
		child.visible = false
	pass

func _on_gnome_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_race("gnome")
	pass

func _on_chitin_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_race("chitin")
	pass

func _on_human_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_race("human")
	pass

func _on_avian_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_race("avian")
	pass

func _on_giant_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_race("giant")
	pass

func _on_aasimar_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_race("aasimar")
	pass

func _on_owlin_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_race("owlin")
	pass

func _on_drow_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_race("drow")
	pass

func _on_mixed_blood_pressed() -> void:
	if !mixed_blood:
		$Blur/NameLabel.text = "Выберите несколько рас"
		$Blur/Label.text = ""
		$Blur/DescriptionLabel.text = ""
	else:
		$Blur/NameLabel.text = ""
		$Blur/Label.text = "Выберите расу персонажа.\nРаса определяет отыгрыш, социальные\nвзаимодействия и ваше место в мире"
		$Blur/DescriptionLabel.text = ""
	mixed_blood = !mixed_blood
	clear_highlight()
	pass # Replace with function body.

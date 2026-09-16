extends Node2D

var subclass = ""
var wayback = ""
var mixed_blood = false
var mixed_blood_name = ""
var race_name = ""
var mixed_parents = []
@onready var sprites = { "human": $HighlightedSprites/Human/Human, "drow": $HighlightedSprites/Drow/Drow,
						 "gnome": $HighlightedSprites/Gnome/Gnome, "chitin": $HighlightedSprites/Chitin/Chitin,
						 "avian": $HighlightedSprites/Avian/Avian, "giant": $HighlightedSprites/Giant/Giant,
						 "owlin": $HighlightedSprites/Owlin/Owlin, "aasimar": $HighlightedSprites/Aasimar/Aasimar }

func _ready():
	$NewRaceScreen.visible = false
	subclass = TempData.subclass_id
	if subclass == "mage":
		wayback = "res://scenes/mage_subclass_select.tscn"
	elif subclass == "assasin":
		wayback = "res://scenes/rogue_subclass_select.tscn"
	else:
		wayback = "res://scenes/warrior_subclass_select.tscn"
	clear_highlight()
	$Next.disabled = true
	$Blur/NameLabel.text = ""
	$Blur/DescriptionLabel.text = ""

func select_race(race_id: String):
	var race_data = DataManager.get_race_data(race_id)
	if race_data:
		if !mixed_blood:
			clear_highlight()
			update_text(race_data)
			TempData.race_name = race_data["name"]
		if race_id != "mixed_blood" and race_id != "new_race":
			sprites[race_id].visible = !sprites[race_id].visible
		elif race_id == "new_race":
			TempData.race_name = $NewRaceScreen/NewRaceNameEdit.text
		$Next.disabled = false

func update_text(race_data):
	$Blur/NameLabel.text = race_data["name"]
	$Blur/DescriptionLabel.text = race_data["description"]

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(wayback)
	pass # Replace with function body.

func _on_next_pressed() -> void:
	go_to_sex_select()

func clear_highlight() -> void:
	for child in get_tree().get_nodes_in_group("characters"):
		child.visible = false

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
		set_mixed_blood_settings()
	else:
		set_not_mixed_blood_settings()
	mixed_blood = !mixed_blood
	clear_highlight()

func set_mixed_blood_settings() -> void:
	$Blur/NameLabel.text = ""
	$Blur/Label.text = "Выберите несколько рас"
	$Blur/DescriptionLabel.text = ""
	select_race("mixed_blood")

func set_not_mixed_blood_settings() -> void:
	$Blur/NameLabel.text = ""
	$Blur/Label.text = "Выберите расу персонажа.\nРаса определяет отыгрыш, социальные\nвзаимодействия и ваше место в мире"
	$Blur/DescriptionLabel.text = ""

func _on_new_race_pressed() -> void:
	open_new_race_dialog()

func open_new_race_dialog() -> void:
	clear_highlight()
	$NewRaceScreen.visible = true

func close_new_race_dialog():
	$NewRaceScreen.visible = false
	$Next.disabled = true

func _on_no_pressed() -> void:
	close_new_race_dialog()

func _on_yes_pressed() -> void:
	select_race("new_race")
	go_to_sex_select()

func save_parents():
	for child in sprites:
		if sprites[child].visible:
			TempData.race_parents.append(child)

func go_to_sex_select():
	save_parents()
	print(TempData.race_parents)
	get_tree().change_scene_to_file("res://scenes/sex_select.tscn")

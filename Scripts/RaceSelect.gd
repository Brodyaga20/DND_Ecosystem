extends Node2D

var subclass = ""
var wayback = ""
var selected_race_id = ""
var preselected_race_id = ""

func _ready():
	subclass = TempData.subclass_id
	if subclass == "mage":
		wayback = "res://Scenes/MageSubclassSelect.tscn"
	elif subclass == "assasin":
		wayback = "res://Scenes/RogueSubclassSelect.tscn"
	else:
		wayback = "res://Scenes/WarriorSubclassSelect.tscn"
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
		$Blur/NameLabel.text = race_data["name"]
		$Blur/DescriptionLabel.text = race_data["description"]
		$Next.disabled = false

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(wayback)
	pass # Replace with function body.

func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/SexSelect.tscn")
	pass # Replace with function body.

func clear_highlight():
	for child in get_tree().get_nodes_in_group("characters"):
		child.visible = false
	pass

func _on_gnome_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clear_highlight()
			$Gnome/Gnome.visible = true
			select_race("gnome")
	pass

func _on_chitin_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clear_highlight()
			$Chitin/Chitin.visible = true
			select_race("chitin")
	pass

func _on_human_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clear_highlight()
			$Human/Human.visible = true
			select_race("human")
	pass

func _on_aarakocra_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clear_highlight()
			$Aarakocra/Aarakocra.visible = true
			select_race("aarakocra")
	pass

func _on_giant_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clear_highlight()
			$Giant/Giant.visible = true
			select_race("giant")
	pass

func _on_aasimar_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clear_highlight()
			$Aasimar/Aasimar.visible = true
			select_race("aasimar")
	pass

func _on_owlin_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clear_highlight()
			$Owlin/Owlin.visible = true
			select_race("owlin")
	pass

func _on_drow_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clear_highlight()
			$Drow/Drow.visible = true
			select_race("drow")
	pass

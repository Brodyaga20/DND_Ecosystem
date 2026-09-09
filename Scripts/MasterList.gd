extends Node2D

var selected_char_id = null

func _ready():
	GameState.master_mode = true  # Убеждаемся, что мастер-режим активен
	update_grid()

func update_grid():
	var grid = $VBoxContainer/CharactersGrid
	# Очищаем сетку
	for child in grid.get_children():
		child.queue_free()
	
	var characters = GameManager.characters
	var count = characters.size()
	
	# Заполняем персонажами
	for c in characters:
		var card = create_character_card(c)
		grid.add_child(card)

	if count == 0:
		var label = Label.new()
		label.text = "Нет сохранённых персонажей."
		grid.add_child(label)


	selected_char_id = null
	update_buttons()

func create_character_card(char_data: Dictionary) -> Control:
	var card = Button.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var class_name_ = DataManager.get_class_data(char_data["class_id"])["name"]
	card.text = char_data["name"] + "\n" + class_name_
	card.custom_minimum_size = Vector2(150, 80)
	card.set_meta("char_id", char_data["id"])
	card.pressed.connect(_on_card_pressed.bind(char_data["id"]))
	return card

func _on_card_pressed(char_id: int):
	selected_char_id = char_id
	update_buttons()
	update_selection_highlight()

func update_selection_highlight():
	var grid = $VBoxContainer/CharactersGrid
	for child in grid.get_children():
		if child is Button and child.has_meta("char_id"):
			var id = child.get_meta("char_id")
			child.modulate = Color.YELLOW if id == selected_char_id else Color.WHITE

func update_buttons():
	var has_selected = (selected_char_id != null)
	$CharSheet.disabled = not has_selected

func _on_edit_button_pressed():
	if selected_char_id != null:
		GameState.current_character_id = selected_char_id
		# Уже в мастер-режиме, просто переходим в профиль
		get_tree().change_scene_to_file("res://scenes/Profile.tscn")



func _on_back_pressed() -> void:
	GameState.master_mode = false
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

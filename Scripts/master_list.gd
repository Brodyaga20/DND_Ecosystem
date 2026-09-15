extends Control

var selected_char_id = null
var selected_peer_id = null

func _ready():
	GameState.master_mode = true  # Убеждаемся, что мастер-режим активен
	update_grid()

func update_grid():
	var grid = $VBoxContainer/CharactersGrid
	# Очищаем сетку
	for child in grid.get_children():
		child.queue_free()
	
	var characters = ServerData.players
	var count = characters.size()
	
	for peer_id in ServerData.players.keys():
		var char_data = ServerData.players[peer_id]  # данные персонажа
		var card = create_character_card(char_data, peer_id)  # создаём карточку
		grid.add_child(card)
	
	# Заполняем персонажами


	if count == 0:
		var label = Label.new()
		label.text = "Нет сохранённых персонажей."
		grid.add_child(label)


	selected_char_id = null
	update_buttons()

func create_character_card(char_data: Dictionary, peer_id: int) -> Control:
	var card = Button.new()
	card.text = char_data["name"] + "\n" + DataManager.get_class_data(char_data["class_id"])["name"]
	# Сохраняем ID персонажа и peer_id в метаданные (для подсветки)
	card.set_meta("char_id", char_data["id"])
	card.set_meta("peer_id", peer_id)
	# При нажатии передаём ID персонажа и peer_id
	card.pressed.connect(_on_card_pressed.bind(char_data["id"], peer_id))
	return card

func _on_card_pressed(char_id: int, peer_id: int):
	selected_char_id = char_id
	selected_peer_id = peer_id
	# Сохраняем в глобальные переменные для использования в профиле
	GameState.current_character_id = char_id
	GameState.current_peer_id = peer_id
	update_buttons()        # активируем кнопку "Редактировать"
	update_selection_highlight()

func update_selection_highlight():
	var grid = $VBoxContainer/CharactersGrid
	for child in grid.get_children():
		if child is Button and child.has_meta("char_id"):
			var id = child.get_meta("char_id")
			child.modulate = Color.YELLOW if id == selected_char_id else Color.WHITE

func update_buttons():
	var has_selected = (selected_char_id != null)
	$Edit.disabled = not has_selected

func _on_edit_button_pressed():
	if selected_char_id != null:
		GameState.current_character_id = selected_char_id
		# Уже в мастер-режиме, просто переходим в профиль
		get_tree().change_scene_to_file("res://scenes/profile.tscn")



func _on_back_pressed() -> void:
	GameState.master_mode = false
	ServerData.players.clear()
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")

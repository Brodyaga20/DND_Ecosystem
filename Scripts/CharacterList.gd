extends Node2D

var selected_char_id = null  # ID выбранного персонажа

func _ready():
	update_grid()

func update_grid():
	var grid = $VBoxContainer/CharactersGrid
	# Очищаем сетку (но не удаляем её саму)
	for child in grid.get_children():
		child.queue_free()
	
	var characters = GameManager.characters
	var count = characters.size()
	
	# Заполняем персонажами
	for c in characters:
		var card = create_character_card(c)
		grid.add_child(card)
	
	# Добавляем пустые ячейки, если персонажей меньше 6, чтобы сетка не сжималась
	for i in range(count, GameManager.MAX_CHARACTERS):
		var empty = Control.new()
		empty.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		grid.add_child(empty)
	
	# Кнопка создания активна, если не достигнут лимит
	$Create.disabled = (count >= GameManager.MAX_CHARACTERS)

func create_character_card(char_data: Dictionary) -> Control:
	var card = Button.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var class_name_ = DataManager.get_class_data(char_data["class_id"])["name"]
	card.text = char_data["name"] + "\n" + class_name_
	# Настраиваем размеры (можно задать через theme)
	card.custom_minimum_size = Vector2(150, 80)
	card.pressed.connect(_on_card_pressed.bind(char_data["id"]))
	return card

func _on_card_pressed(char_id: int):
	# Выбираем персонажа
	selected_char_id = char_id
	print("Выбран персонаж:", char_id)
	GameState.current_character_id = char_id
	update_buttons()
	update_selection_highlight()

func update_selection_highlight():
	var grid = $VBoxContainer/CharactersGrid
	# Сбрасываем подсветку у всех карточек
	for child in grid.get_children():
		if child is Button:
			child.modulate = Color.WHITE
	if selected_char_id != null:
		for child in grid.get_children():
			if child is Button:
				# Находим карточку по ID (в data не храним, поэтому ищем совпадение текста? лучше хранить ID в метаданных)
				# Добавим в card метаданные при создании
				pass

func update_buttons():
	var has_selected = (selected_char_id != null)
	$Create.disabled = not has_selected
	$Delete.disabled = not has_selected


func _on_delete_confirm_dialog_confirmed():
	if selected_char_id != null:
		var success = GameManager.delete_character(selected_char_id)
		if success:
			selected_char_id = null
			update_buttons()
			update_grid()  # обновляем список
		else:
			print("Не удалось удалить персонажа")

func _on_create_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ClassSelect.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/StartScreen.tscn")


func _on_delete_pressed() -> void:
	if selected_char_id != null:
		var success = GameManager.delete_character(selected_char_id)
		if success:
			selected_char_id = null
			update_buttons()
			update_grid()  # обновляем список
		else:
			print("Не удалось удалить персонажа")

func _on_char_sheet_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/CharacterSheet.tscn")

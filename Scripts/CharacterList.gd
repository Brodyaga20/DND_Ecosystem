extends Control

var selected_char_id = null  # ID выбранного персонажа

const TEX_NORMAL   = preload("res://Assets/Pictures/Buttons/CharList/CharNormal.png")
const TEX_HOVER    = preload("res://Assets/Pictures/Buttons/CharList/CharHover.png")
const TEX_PRESSED  = preload("res://Assets/Pictures/Buttons/CharList/CharPressed.png")
var button_group: ButtonGroup

func _ready():
	button_group = ButtonGroup.new()
	button_group.allow_unpress = false   # нельзя "отжать" кликом по той же кнопке
	update_grid()

func update_grid():
	var grid = $VBoxContainer/CharactersGrid
	# Очищаем сетку (но не удаляем её саму)
	for child in grid.get_children():
		child.queue_free()
	
	set_vision()
	var characters = []
	if GameState.remote_characters.size() > 0:
		characters = GameState.remote_characters.values()
	else:
		characters = GameManager.characters
	var count = characters.size()
	# Заполняем персонажами
	for c in characters:
		var card = create_character_card(c)
		grid.add_child(card)
	
	
	# Кнопка создания активна, если не достигнут лимит
	$Create.disabled = (count >= GameManager.MAX_CHARACTERS)

func set_vision():
	$Create.visible = !GameState.is_connected_to_server
	$Delete.visible = !GameState.is_connected_to_server
	$Play.visible = !GameState.is_connected_to_server

func create_character_card(char_data: Dictionary) -> Control:
	var card = TextureButton.new()
	card.toggle_mode  = true
	card.button_group = button_group
	
	card.texture_normal        = TEX_NORMAL
	card.texture_hover         = TEX_HOVER
	card.texture_pressed       = TEX_PRESSED
	card.texture_focused       = TEX_PRESSED
	
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	var text := Label.new()
	arrange(text, card)
	var class_name_    = DataManager.get_class_data(char_data["class_id"])["name"]
	var subclass_name_ = DataManager.get_subclass_data(char_data["subclass_id"])["name"]
	text.text = char_data["name"] + "\n" + class_name_ + "\n" + subclass_name_
	card.pressed.connect(_on_card_pressed.bind(char_data["id"]))
	card.add_child(text)
	return card

func arrange(text: Label, card: TextureButton) -> Label:
	var my_font = load("res://Assets/Fonts/cinzel_bold.ttf")
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	text.size = card.texture_normal.get_size()
	text.add_theme_font_size_override("font_size", 30)
	text.add_theme_font_override("font", my_font)
	return text

func _on_card_pressed(char_id: int):
	# Выбираем персонажа
	selected_char_id = char_id
	GameState.current_character_id = char_id
	update_buttons()
	var found_peer = null
	for peer in GameState.remote_characters:
		if GameState.remote_characters[peer]["id"] == char_id:
			found_peer = peer
			break
	GameState.current_peer_id = found_peer
	# Переход на ConnectMenu или Profile (зависит от режима)


func update_buttons():
	var has_selected = (selected_char_id != null)
	$Create.disabled = not has_selected
	$Delete.disabled = not has_selected




func _on_back_pressed() -> void:
	if GameState.is_connected_to_server:
		_disconnect_from_server()
	get_tree().change_scene_to_file("res://Scenes/StartScreen.tscn")

func _disconnect_from_server():
	GameState.is_connected_to_server = false
	GameState.remote_characters.clear()
	GameState.current_peer_id = null
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
	


func _on_delete_pressed() -> void:
	if selected_char_id != null:
		var success = GameManager.delete_character(selected_char_id)
		if success:
			selected_char_id = null
			update_buttons()
			update_grid()  # обновляем список

func _on_char_sheet_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Profile.tscn")

func _on_play_pressed() -> void:
	if selected_char_id != null:
		GameState.current_character_id = selected_char_id
		GameState.master_mode = false
		get_tree().change_scene_to_file("res://Scenes/ConnectMenu.tscn")
		return
	if GameState.master_mode:
		get_tree().change_scene_to_file("res://Scenes/Profile.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/ConnectMenu.tscn")


func _on_create_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ClassSelect.tscn")
	pass # Replace with function body.

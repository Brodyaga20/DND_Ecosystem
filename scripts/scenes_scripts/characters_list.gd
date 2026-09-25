extends Control

var selected_char_id = null  # ID выбранного персонажа

const TEX_NORMAL   = preload("res://assets/pictures/buttons/character_list/char_normal.png")
const TEX_HOVER    = preload("res://assets/pictures/buttons/character_list/char_hover.png")
const TEX_PRESSED  = preload("res://assets/pictures/buttons/character_list/char_pressed.png")
var button_group: ButtonGroup

func _ready():
	update_ui_buttons()
	if !SaveSystem.can_create_character(GameState.meta):
		$Create.disabled = true
	button_group = ButtonGroup.new()
	button_group.allow_unpress = false   # нельзя "отжать" кликом по той же кнопке
	update_grid()

func update_grid():
	update_ui_buttons()
	var grid = $VBoxContainer/CharactersGrid
	for child in grid.get_children():
		child.queue_free()
	_populate_character_list()

func _populate_character_list() -> void:
	var grid = $VBoxContainer/CharactersGrid
	var ids = SaveSystem.list_character_ids()
	for id in ids:
		var c = SaveSystem.load_character(id)
		if c == null:
			continue
		var button := TextureButton.new()
		configure_char_button(button, id)
		configure_text(button, c)
		grid.add_child(button)

func configure_char_button(button: TextureButton, id: int) -> TextureButton:
	button.toggle_mode  = true
	button.button_group = button_group
	button.texture_normal        = TEX_NORMAL
	button.texture_hover         = TEX_HOVER
	button.texture_pressed       = TEX_PRESSED
	button.texture_focused       = TEX_PRESSED
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	button.pressed.connect(_on_card_pressed.bind(id))
	return button

func configure_text(button: TextureButton, c: CharacterData) -> TextureButton:
	var text := Label.new()
	arrange(text, button)
	var class_name_    = DataManager.character_classes.get_by_id(c.class_id).display_name
	#var subclass_name_ = DataManager.character_subclasses.get_by_id(c.subclass_id).display_name
	var character_name = c.character_name
	text.text = str(character_name) + "\n" + str(class_name_) + "\n"
	button.add_child(text)
	return button

func arrange(text: Label, card: TextureButton) -> Label:
	var my_font = load("res://assets/fonts/cinzel_bold.ttf")
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	text.size = card.texture_normal.get_size()
	text.add_theme_font_size_override("font_size", 30)
	text.add_theme_font_override("font", my_font)
	return text

func update_ui_buttons():
	$Create.disabled    = !SaveSystem.can_create_character(GameState.meta)
	$Play.disabled      = (selected_char_id == null)
	$Delete.disabled    = (selected_char_id == null)
	$CharSheet.disabled = (selected_char_id == null)

func _on_card_pressed(char_id: int):
	selected_char_id = char_id
	var character = SaveSystem.load_character(char_id)
	GameState.set_player_character(character)
	update_ui_buttons()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")

func _disconnect_from_server():
	GameState.is_connected_to_server = false
	GameState.remote_characters.clear()
	GameState.current_peer_id = null
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null

func _on_delete_pressed() -> void:
	SaveSystem.delete_character(selected_char_id)
	selected_char_id = null
	update_grid()

func _on_char_sheet_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/profile.tscn")

func _on_play_pressed() -> void:
	if selected_char_id != null:
		GameState.current_character_id = selected_char_id
		GameState.master_mode = false
		get_tree().change_scene_to_file("res://scenes/connect_menu.tscn")
		return
	if GameState.master_mode:
		get_tree().change_scene_to_file("res://scenes/profile.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/connect_menu.tscn")

func _on_create_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/class_select.tscn")
	pass # Replace with function body.

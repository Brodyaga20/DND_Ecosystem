# game_state.gd (Autoload)
extends Node

signal player_character_changed(character: CharacterData)

var player: CharacterData = null

func set_player_character(c: CharacterData) -> void:
	player = c
	player_character_changed.emit(c)

func clear_player_character() -> void:
	player = null
	player_character_changed.emit(null)

# --- Мета ---

func load_meta_into_state() -> void:
	var meta := SaveSystem.load_meta()
	# last_character_id здесь, если нужно для создания новых
	# активный id и т.п.

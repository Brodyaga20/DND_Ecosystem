# game_state.gd (Autoload)
extends Node

signal player_character_changed(character: PlayerData)
signal meta_changed

var player: PlayerData = null
var meta: MetaProfile

func _ready() -> void:
	meta = SaveSystem.load_meta_profile()

func set_player_character(p: PlayerData) -> void:
	player = p
	player_character_changed.emit(p)

func clear_player_character() -> void:
	player = null
	player_character_changed.emit(null)

func save_meta() -> void:
	SaveSystem.save_meta_profile(meta)
	meta_changed.emit()

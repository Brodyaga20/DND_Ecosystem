# save_system.gd (Autoload)
extends Node

const META_PATH := "user://meta.json"
const CHARACTERS_DIR := "user://characters/"
const MAX_CHARACTERS := 6

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(CHARACTERS_DIR)

# --- Meta profile ---

func save_meta_profile(profile: MetaProfile) -> bool:
	return _write_json(META_PATH, profile.to_dict())

func load_meta_profile() -> MetaProfile:
	var raw := _read_json(META_PATH, {})
	return MetaProfile.from_dict(raw)

# --- Character ---

func get_character_count(profile: MetaProfile) -> int:
	return profile.character_ids.size()

func can_create_character(profile: MetaProfile) -> bool:
	return profile.character_ids.size() < MAX_CHARACTERS

func save_character(c: CharacterData) -> bool:
	if c.id <= 0:
		push_error("Cannot save character without id")
		return false

	var path := _character_path(c.id)
	if not _write_json(path, c.to_dict()):
		return false

	var profile := load_meta_profile()
	profile.add_character_id(c.id)
	return save_meta_profile(profile)

func load_character(id: int) -> CharacterData:
	var path := _character_path(id)
	var raw := _read_json(path, {})
	if raw.is_empty():
		return null

	raw = _migrate_character(raw)

	# Пока у нас только CharacterData, но с PlayerData будет ветвление
	return PlayerData.from_dict(raw)

func delete_character(id: int) -> bool:
	var path := _character_path(id)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

	if GameState.player != null and GameState.player.id == id:
		GameState.clear_player_character()

	var profile := load_meta_profile()
	profile.remove_character_id(id)
	return save_meta_profile(profile)

func list_character_ids() -> Array[int]:
	return load_meta_profile().character_ids.duplicate()

# --- Внутреннее ---

func _character_path(id: int) -> String:
	return CHARACTERS_DIR + "%d.json" % id

func _write_json(path: String, data: Dictionary) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("Cannot open for write: %s (err %d)" % [path, FileAccess.get_open_error()])
		return false
	f.store_string(JSON.stringify(data, "\t"))
	f.close()
	return true

func _read_json(path: String, fallback: Dictionary) -> Dictionary:
	if not FileAccess.file_exists(path):
		return fallback
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("Cannot open for read: %s" % path)
		return fallback
	var text := f.get_as_text()
	f.close()
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Invalid JSON in %s" % path)
		return fallback
	return parsed

func _migrate_character(raw: Dictionary) -> Dictionary:
	var _version := int(raw.get("version", 0))
	# сюда будут добавляться миграции по версиям
	return raw

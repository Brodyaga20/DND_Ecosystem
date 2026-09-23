extends Node

const META_PATH := "user://meta.json"
const CHARACTERS_DIR := "user://characters/"
const MAX_CHARACTERS := 6

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(CHARACTERS_DIR)

# --- Мета ---

func save_meta(meta: Dictionary) -> void:
	_write_json(META_PATH, meta)

func load_meta() -> Dictionary:
	return _read_json(META_PATH, {})

# --- Персонаж ---

func get_character_count() -> int:
	var meta := load_meta()
	var ids: Array = meta.get("character_ids", [])
	return ids.size()

func can_create_character() -> bool:
	return get_character_count() < MAX_CHARACTERS

func save_character(c: CharacterData) -> bool:
	if c.id <= 0:
		push_error("Cannot save character without id")
		return false

	var path := _character_path(c.id)
	var data := c.to_dict()
	if not _write_json(path, data):
		return false

	_register_in_meta(c.id)
	return true

func load_character(id: int) -> CharacterData:
	var path := _character_path(id)
	var raw := _read_json(path, {})
	if raw.is_empty():
		return null

	raw = _migrate_character(raw)
	return CharacterData.from_dict(raw)

func delete_character(id: int) -> bool:
	var path := _character_path(id)
	if not FileAccess.file_exists(path):
		return false
	DirAccess.remove_absolute(path)
	GameState.clear_player_character()
	_unregister_in_meta(id)
	return true

func list_character_ids() -> Array[int]:
	var meta := load_meta()
	var ids: Array[int] = []
	for id in meta.get("character_ids", []):
		ids.append(int(id))
	return ids

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

func _register_in_meta(id: int) -> void:
	var meta := load_meta()
	var ids: Array[int] = []
	for existing in meta.get("character_ids", []):
		ids.append(int(existing))
	if not id in ids:
		ids.append(int(id))
	meta["character_ids"] = ids
	meta["last_character_id"] = int(id)
	save_meta(meta)

func _unregister_in_meta(id: int) -> void:
	var meta := load_meta()
	var ids: Array[int] = []
	for existing in meta.get("character_ids", []):
		ids.append(int(existing))
	print(ids)
	ids.erase(id)
	print(id, " ", ids)
	meta["character_ids"] = ids
	meta["last_character_id"] = -1
	save_meta(meta)

func _migrate_character(raw: Dictionary) -> Dictionary:
	var _version := int(raw.get("version", 0))

	return raw

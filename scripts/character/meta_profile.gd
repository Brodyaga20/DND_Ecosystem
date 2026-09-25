# meta_profile.gd
class_name MetaProfile
extends RefCounted

var character_ids: Array[int] = []
var last_character_id: int = -1
var unlocked_codex_keys: Dictionary = {}   # StringName -> true
var achievements: Dictionary = {}           # StringName -> true

func to_dict() -> Dictionary:
	var codex := {}
	for key in unlocked_codex_keys:
		codex[String(key)] = true
	var ach := {}
	for key in achievements:
		ach[String(key)] = true

	return {
		"character_ids": character_ids.duplicate(),
		"last_character_id": last_character_id,
		"unlocked_codex_keys": codex,
		"achievements": ach,
	}

static func from_dict(raw: Dictionary) -> MetaProfile:
	var m := MetaProfile.new()
	m.last_character_id = int(raw.get("last_character_id", -1))
	for id in raw.get("character_ids", []):
		m.character_ids.append(int(id))
	for key in raw.get("unlocked_codex_keys", {}):
		m.unlocked_codex_keys[StringName(key)] = true
	for key in raw.get("achievements", {}):
		m.achievements[StringName(key)] = true
	return m

# --- Мутации ---

func add_character_id(id: int) -> void:
	if id not in character_ids:
		character_ids.append(id)
	last_character_id = id

func remove_character_id(id: int) -> void:
	character_ids.erase(id)
	if last_character_id == id:
		last_character_id = -1

func next_character_id() -> int:
	# +1 к максимальному — счётчик монотонный, id не переиспользуются
	var max_id := 0
	for id in character_ids:
		max_id = max(max_id, id)
	return max_id + 1

func unlock_codex(key: StringName) -> void:
	unlocked_codex_keys[key] = true

func is_codex_unlocked(key: StringName) -> bool:
	return unlocked_codex_keys.has(key)

func unlock_achievement(key: StringName) -> void:
	achievements[key] = true

func has_achievement(key: StringName) -> bool:
	return achievements.has(key)

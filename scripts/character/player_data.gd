# player_data.gd
class_name PlayerData
extends CharacterData

const BASE_STATS_SUM = 6

var current_location_id: StringName = &""
var current_scene_path: String = ""
var quest_flags: Dictionary = {}
var playtime_seconds: float = 0.0
var last_played_unix: int = 0

func load_from_dict(raw: Dictionary) -> void:
	super(raw)                      # ← ActorData + CharacterData

	current_location_id = StringName(raw.get("current_location_id", ""))
	current_scene_path = raw.get("current_scene_path", "")

	quest_flags.clear()
	for key in raw.get("quest_flags", {}):
		quest_flags[StringName(key)] = raw["quest_flags"][key]

	playtime_seconds = float(raw.get("playtime_seconds", 0.0))
	last_played_unix = int(raw.get("last_played_unix", 0))

func to_dict() -> Dictionary:
	var d := super()                      # ← ОБЯЗАТЕЛЬНО
	d["current_location_id"] = String(current_location_id)
	d["current_scene_path"] = current_scene_path

	var flags := {}
	for key in quest_flags:
		flags[String(key)] = quest_flags[key]
	d["quest_flags"] = flags

	d["playtime_seconds"] = playtime_seconds
	d["last_played_unix"] = last_played_unix
	return d

static func from_dict(raw: Dictionary) -> PlayerData:
	var p := PlayerData.new()
	p.load_from_dict(raw)
	return p

func can_unlock_subclass():
	return (subclass_id == "" and level >= 3)

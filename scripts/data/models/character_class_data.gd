# character_class_data.gd
class_name CharacterClassData
extends RefCounted

var id: StringName
var display_name: String
var short_description: String
var long_description: String
var resource_id: StringName
var recommended_stats_distribution : StatsData
var subclass_ids: Array[StringName] = []

static func from_dict(raw: Dictionary, fallback_id: StringName = &"") -> CharacterClassData:
	var data := CharacterClassData.new()
	data.id = StringName(raw.get("id", fallback_id))
	data.display_name = raw.get("name", "")
	data.short_description = raw.get("short_description", "")
	data.long_description = raw.get("long_description", "")
	data.resource_id = StringName(raw.get("resource_id", ""))
	data.recommended_stats_distribution = StatsData.from_dict(raw.get("recommended_stats", {}))
	return data

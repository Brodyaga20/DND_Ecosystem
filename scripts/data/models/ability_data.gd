# character_class_data.gd
class_name AbilityData
extends RefCounted

var id: StringName
var display_name: String
var short_description: String
var long_description: String
var tier : int
var class_id : StringName
var action_type : StringName
var resource_cost : int
var cooldown : StringName
var duration : StringName
var usage : StringName

static func from_dict(raw: Dictionary, fallback_id: StringName = &"") -> AbilityData:
	var data := AbilityData.new()
	data.id = StringName(raw.get("id", fallback_id))
	data.display_name = raw.get("name", "")
	data.short_description = raw.get("short_description", "")
	data.long_description = raw.get("long_description", "")
	data.tier = raw.get("tier", null)
	data.class_id = raw.get("class_id", "")
	data.action_type = raw.get("action_type", "")
	data.resource_cost = raw.get("resource_cost", 0)
	data.cooldown = raw.get("cooldown", "")
	data.duration = raw.get("duration", "")
	data.usage = raw.get("usage", "")
	return data

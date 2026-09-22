# character_class_data.gd
class_name CharacterSubclassData
extends RefCounted

var id: StringName
var display_name: String
var short_description: String
var long_description: String
var resource_id: StringName
var class_id: StringName

static func from_dict(raw: Dictionary, fallback_id: StringName = &"") -> CharacterSubclassData:
	var data := CharacterSubclassData.new()
	data.id = StringName(raw.get("id", fallback_id))
	data.display_name = raw.get("name", "")
	data.short_description = raw.get("short_description", "")
	data.long_description = raw.get("long_description", "")
	data.resource_id = StringName(raw.get("resource_id", ""))
	data.class_id = StringName(raw.get("class_id", ""))
	return data

# character_class_data.gd
class_name CharacterArchetypeData
extends RefCounted

var id: StringName
var display_name: String
var short_description: String
var long_description: String
var subclass_id: StringName

static func from_dict(raw: Dictionary, fallback_id: StringName = &"") -> CharacterArchetypeData:
	var data := CharacterArchetypeData.new()
	data.id = StringName(raw.get("id", fallback_id))
	data.display_name = raw.get("name", "")
	data.short_description = raw.get("short_description", "")
	data.long_description = raw.get("long_description", "")
	data.subclass_id = StringName(raw.get("class_id", ""))
	return data

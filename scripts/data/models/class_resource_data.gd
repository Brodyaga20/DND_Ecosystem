# character_class_data.gd
class_name ClassResourceData
extends RefCounted

var id: StringName
var display_name: String
#var short_description: String
#var long_description: String
#var class_id: StringName
#var subclass_id: StringName

static func from_dict(raw: Dictionary, fallback_id: StringName = &"") -> ClassResourceData:
	var data := ClassResourceData.new()
	data.id = StringName(raw.get("id", fallback_id))
	data.display_name = raw.get("name", "")
	return data

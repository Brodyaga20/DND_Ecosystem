# stat_data.gd
class_name StatData
extends RefCounted

var id: StringName
var display_name: String
var description: String
#var icon_path: String

static func from_dict(raw: Dictionary, fallback_id: StringName = &"") -> StatData:
	var s := StatData.new()
	s.id = StringName(raw.get("id", fallback_id))
	s.display_name = raw.get("name", "")
	s.description = raw.get("description", "")
	#s.icon_path = raw.get("icon", "res://icons/stats/%s.png" % s.id)
	return s

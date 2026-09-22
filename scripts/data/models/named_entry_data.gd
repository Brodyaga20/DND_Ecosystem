# named_entry_data.gd
class_name NamedEntryData
extends RefCounted

var id: StringName
var display_name: String

static func from_dict(raw: Dictionary, fallback_id: StringName = &"") -> NamedEntryData:
	var e := NamedEntryData.new()
	e.id = StringName(raw.get("id", fallback_id))
	e.display_name = raw.get("name", "")
	return e

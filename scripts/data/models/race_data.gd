class_name RaceData
extends RefCounted

var id: StringName
var display_name: String
var description: String

# descriptor -> [min, max]
var lifespan: Dictionary = {}

static func from_dict(raw: Dictionary, fallback_id: StringName = &"") -> RaceData:
	var r := RaceData.new()
	r.id = StringName(raw.get("id", fallback_id))
	r.display_name = raw.get("name", "")
	r.description = raw.get("short_description", "")

	var ls: Dictionary = raw.get("lifespan", {})
	for key in ls:
		var range: Array = ls[key]
		if range.size() != 2:
			push_warning("Invalid lifespan range for '%s' in race %s" % [key, r.id])
			continue
		r.lifespan[StringName(key)] = [int(range[0]), int(range[1])]

	return r

func get_lifespan_range(descriptor: StringName) -> Array:
	return lifespan.get(descriptor, [])

func get_range_text(descriptor: StringName) -> String:
	var r := get_lifespan_range(descriptor)
	if r.is_empty():
		return ""
	return "%d–%d" % [r[0], r[1]]

func has_descriptor(descriptor: StringName) -> bool:
	return lifespan.has(descriptor)

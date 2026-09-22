class_name RaceRef
extends RefCounted

enum Kind { SINGLE, MIXED, CUSTOM }

var kind: Kind = Kind.SINGLE
var race_id: StringName = &""            # для SINGLE
var mixed_ids: Array[StringName] = []    # для MIXED
var custom_name: String = ""             # для CUSTOM

func to_dict() -> Dictionary:
	var mixed: Array = []
	for id in mixed_ids:
		mixed.append(String(id))
	return {
		"kind": kind,
		"race_id": String(race_id),
		"mixed_ids": mixed,
		"custom_name": custom_name,
	}

static func from_dict(raw: Dictionary) -> RaceRef:
	var r := RaceRef.new()
	r.kind = int(raw.get("kind", Kind.SINGLE)) as Kind
	r.race_id = StringName(raw.get("race_id", ""))
	for id in raw.get("mixed_ids", []):
		r.mixed_ids.append(StringName(id))
	r.custom_name = raw.get("custom_name", "")
	return r

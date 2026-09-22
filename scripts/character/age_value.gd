class_name AgeValue
extends RefCounted

enum Kind { NUMERIC, DESCRIPTOR }

var kind: Kind = Kind.NUMERIC
var number: int = 0
var label: StringName = &""   # &"young", &"mature", &"old", &"ancient"

static func numeric(n: int) -> AgeValue:
	var a := AgeValue.new()
	a.kind = Kind.NUMERIC
	a.number = n
	return a

static func descriptor(key: StringName) -> AgeValue:
	var a := AgeValue.new()
	a.kind = Kind.DESCRIPTOR
	a.label = key
	return a

func to_dict() -> Dictionary:
	return {
		"kind": kind,
		"number": number,
		"label": String(label),
	}

static func from_dict(raw: Dictionary) -> AgeValue:
	var a := AgeValue.new()
	a.kind = int(raw.get("kind", Kind.NUMERIC)) as Kind
	a.number = int(raw.get("number", 0))
	a.label = StringName(raw.get("label", ""))
	return a

class_name HpState
extends RefCounted

var current: int = 0
var max: int = 0

func to_dict() -> Dictionary:
	return { "current": current, "max": max }

static func from_dict(raw: Dictionary) -> HpState:
	var h := HpState.new()
	h.current = int(raw.get("current", 0))
	h.max = int(raw.get("max", 0))
	return h

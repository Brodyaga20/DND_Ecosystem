class_name HpState
extends RefCounted

var current_hp: int = 0
var max_hp: int = 0

func to_dict() -> Dictionary:
	return { "current_hp": current_hp, "max_hp": max_hp }

static func from_dict(raw: Dictionary) -> HpState:
	var h := HpState.new()
	h.current_hp = int(raw.get("current_hp", 0))
	h.max_hp = int(raw.get("max_hp", 0))
	return h

func get_percentage() -> int:
	return int(float(current_hp * 100) / max_hp)

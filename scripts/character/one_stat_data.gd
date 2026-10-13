# stats_data.gd
class_name OneStatData
extends RefCounted

var display_name: StringName = ""
var level: int = 0
var xp: int = 0

static func from_dict(raw: Dictionary) -> OneStatData:
	var s := OneStatData.new()
	s.display_name = StringName(raw.get("display_name", 0))
	s.level = int(raw.get("level", 0))
	s.xp = int(raw.get("xp", 0))
	return s

func to_dict() -> Dictionary:
	return {
		"display_name": display_name,
		"level": level,
		"xp": xp
	}

func xp_pool() -> int:
	return level * 2 + 10

func get_percentage() -> float:
	var pool : int = xp_pool()
	var percent = float(xp) / pool
	return percent

func add_xp(add: int) -> void:
	var pool : int = xp_pool()
	var overflow : int = 0
	if add - (pool - xp) < 0:
		xp += add
	else:
		level += 1
		overflow = add - (pool - xp)
		xp = 0
		add_xp(overflow)

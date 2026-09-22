# stats_data.gd
class_name StatsData
extends RefCounted

const KEYS: Array[StringName] = [&"power", &"agility", &"intelligence", &"luck"]

var power: int = 0
var agility: int = 0
var intelligence: int = 0
var luck: int = 0

static func from_dict(raw: Dictionary) -> StatsData:
	var s := StatsData.new()
	s.power = int(raw.get("power", 0))
	s.agility = int(raw.get("agility", 0))
	s.intelligence = int(raw.get("intelligence", 0))
	s.luck = int(raw.get("luck", 0))
	return s

func duplicate_stats() -> StatsData:
	var s := StatsData.new()
	s.power = power
	s.agility = agility
	s.intelligence = intelligence
	s.luck = luck
	return s

func add(other: StatsData) -> void:
	power += other.power
	agility += other.agility
	intelligence += other.intelligence
	luck += other.luck

static func randomize_base_stats() -> StatsData:
	var s := StatsData.new()
	var arr = RngManager.distribution_x_to_y(7, 4)
	s.power = arr[0]
	s.agility = arr[1]
	s.intelligence = arr[2]
	s.luck = arr[3]
	return s

func to_dict() -> Dictionary:
	return {
		"power": power,
		"agility": agility,
		"intelligence": intelligence,
		"luck": luck,
	}

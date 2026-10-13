# stats_data.gd
class_name RecommendedStatsData
extends RefCounted

const KEYS: Array[StringName] = [&"power", &"agility", &"intelligence", &"luck"]

static var power: int
static var agility: int
static var intelligence: int
static var luck: int

static func from_dict(raw: Dictionary) -> RecommendedStatsData:
	var s := RecommendedStatsData.new()
	s.power = raw.get("power", 0)
	s.agility = raw.get("agility", 0)
	s.intelligence = raw.get("intelligence", 0)
	s.luck = raw.get("luck", 0)
	return s

func to_dict() -> Dictionary:
	return {
		"power": power,
		"agility": agility,
		"intelligence": intelligence,
		"luck": luck,
	}

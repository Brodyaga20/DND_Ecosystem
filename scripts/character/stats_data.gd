# stats_data.gd
class_name StatsData
extends RefCounted

const KEYS: Array[StringName] = [&"power", &"agility", &"intelligence", &"luck"]

enum Stats {POWER, AGILITY, INTELLIGENCE, LUCK}

var power := OneStatData.new()
var agility := OneStatData.new()
var intelligence := OneStatData.new()
var luck := OneStatData.new()


static func from_dict(raw: Dictionary) -> StatsData:
	var s := StatsData.new()
	if raw.has("power"):
		s.power = OneStatData.from_dict(raw["power"])
	if raw.has("agility"):
		s.agility = OneStatData.from_dict(raw["agility"])
	if raw.has("intelligence"):
		s.intelligence = OneStatData.from_dict(raw["intelligence"])
	if raw.has("luck"):
		s.luck = OneStatData.from_dict(raw["luck"])
	return s

static func from_recommended(rec: RecommendedStatsData) -> StatsData:
	var s := StatsData.new()
	s.power.level = rec.power
	s.agility.level = rec.agility
	s.intelligence.level = rec.intelligence
	s.luck.level = rec.luck
	return s

func duplicate_stats() -> StatsData:
	var s := StatsData.new()
	s.power = power
	s.agility = agility
	s.intelligence = intelligence
	s.luck = luck
	return s

static func randomize_base_stats() -> StatsData:
	var s := StatsData.new()
	var arr = RngManager.distribution_x_to_y(7, 4)
	s.power.level = arr[0]
	s.agility.level = arr[1]
	s.intelligence.level = arr[2]
	s.luck.level = arr[3]
	return s

func to_dict() -> Dictionary:
	return {
		"power": power.to_dict(),
		"agility": agility.to_dict(),
		"intelligence": intelligence.to_dict(),
		"luck": luck.to_dict(),
	}

func get_percentage(stat: Stats):
	match stat:
		Stats.POWER:
			return power.level 
	pass

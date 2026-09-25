class_name MoneyState
extends RefCounted

var magic_coin: int = 0
var copper_coin: int = 0
var silver_coin: int = 0
var gold_coin: int = 0


func to_dict() -> Dictionary:
	return { "copper_coin": copper_coin,
			 "silver_coin": silver_coin,
			 "gold_coin": gold_coin,
			 "magic_coin": magic_coin }

static func from_dict(raw: Dictionary) -> MoneyState:
	var m := MoneyState.new()
	m.copper_coin   = int(raw.get("copper_coin", 0))
	m.silver_coin   = int(raw.get("silver_coin", 0))
	m.gold_coin     = int(raw.get("gold_coin", 0))
	m.magic_coin = int(raw.get("magic_coin", 0))
	return m

func absolute() -> int:
	return (copper_coin + silver_coin * 100 + gold_coin * 10000 + magic_coin * 1000000)

static func from_copper(cop: int) -> MoneyState:
	var m := MoneyState.new()
	m.magic_coin    = int(float(cop) / 1000000)
	m.gold_coin     = int(float(cop) / 10000) % 100
	m.silver_coin   = int(float(cop) / 100) % 10000
	m.copper_coin   = int(cop % 100)
	return m

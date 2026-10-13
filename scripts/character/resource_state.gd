class_name ResourceState
extends RefCounted

var amount: int = 0
var max_amount: int = 0
var min_amount: int = 0
var display_name: String = ""
var resource_id: StringName

func to_dict() -> Dictionary:
	return { "amount": amount,
			 "max_amount": max_amount,
			 "min_amount": min_amount,
			 "display_name": display_name }

static func from_dict(raw: Dictionary) -> ResourceState:
	var m := ResourceState.new()
	m.amount       = int(raw.get("amount", 0))
	m.max_amount   = int(raw.get("max_amount", 0))
	m.min_amount   = int(raw.get("min_amount", 0))
	m.display_name = str(raw.get("display_name", ""))
	return m

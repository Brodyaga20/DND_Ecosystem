class_name EquipmentLoadout
extends RefCounted

# Слоты. Используем StringName-константы, а не enum, чтобы ключи словаря
# были читаемыми в JSON и не ломались при перестановке enum.
const HEAD         := &"head"
const BODY         := &"body"
const HANDS        := &"hands"
const SHOULDERS    := &"shoulders"
const LEGS         := &"legs"
const KNEES        := &"knees"
const BOOTS        := &"boots"

const EARRING      := &"earring"
const BROOCH       := &"brooch"
const BRACELET     := &"bracelet"
const RING         := &"ring"
const BELT         := &"belt"

const ALL_SLOTS: Array[StringName] = [
	HEAD, BODY, HANDS, SHOULDERS, LEGS, KNEES, BOOTS,
	EARRING, BROOCH, BRACELET, RING, BELT,
]

# slot -> item_id
var slots: Dictionary = {}

func get_item(slot: StringName) -> StringName:
	return slots.get(slot, &"")

func set_item(slot: StringName, item_id: StringName) -> void:
	if item_id == &"":
		slots.erase(slot)
	else:
		slots[slot] = item_id

func is_empty() -> bool:
	return slots.is_empty()

func to_dict() -> Dictionary:
	var out := {}
	for slot in slots:
		out[String(slot)] = String(slots[slot])
	return out

static func from_dict(raw: Dictionary) -> EquipmentLoadout:
	var e := EquipmentLoadout.new()
	for slot in raw:
		var sid := StringName(slot)
		if sid not in ALL_SLOTS:
			push_warning("Unknown equipment slot in save: %s" % slot)
			continue
		e.slots[sid] = StringName(raw[slot])
	return e

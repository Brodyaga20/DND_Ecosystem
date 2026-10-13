# actor_data.gd
class_name ActorData
extends RefCounted

var id: int = 0
var created_at_unix: int = 0
var character_name: String = ""
var hp: HpState
var stats: StatsData
var money: MoneyState
var active_effects: Array[ActiveEffect] = []
var ability_ids: Array[StringName] = []
var inventory: Array[InventoryItem] = []
var equipment: EquipmentLoadout
var SAVE_VERSION: int = 1

func _init() -> void:
	hp = HpState.new()
	stats = StatsData.new()
	money = MoneyState.new()
	equipment = EquipmentLoadout.new()

func load_from_dict(raw: Dictionary) -> void:
	id = int(raw.get("id", 0))
	created_at_unix = int(raw.get("created_at_unix", 0))
	character_name = raw.get("character_name", "")

	if raw.has("hp"):
		hp = HpState.from_dict(raw["hp"])
	if raw.has("money"):
		money = MoneyState.from_dict(raw["money"])
	if raw.has("stats"):
		stats = StatsData.from_dict(raw["stats"])
	if raw.has("equipment"):
		equipment = EquipmentLoadout.from_dict(raw["equipment"])

	active_effects.clear()
	for e in raw.get("active_effects", []):
		active_effects.append(ActiveEffect.from_dict(e))

	ability_ids.clear()
	for a in raw.get("ability_ids", []):
		ability_ids.append(StringName(a))

	inventory.clear()
	for i in raw.get("inventory", []):
		inventory.append(InventoryItem.from_dict(i))

func to_dict() -> Dictionary:
	var effects: Array = []
	for e in active_effects:
		effects.append(e.to_dict())

	var abilities: Array = []
	for a in ability_ids:
		abilities.append(String(a))

	var items: Array = []
	for i in inventory:
		items.append(i.to_dict())

	return {
		"version": SAVE_VERSION,
		"id": id,
		"created_at_unix": created_at_unix,
		"character_name": character_name,
		"hp": hp.to_dict(),
		"money": money.to_dict(),
		"stats": stats.to_dict(),
		"active_effects": effects,
		"ability_ids": abilities,
		"inventory": items,
		"equipment": equipment.to_dict(),
	}

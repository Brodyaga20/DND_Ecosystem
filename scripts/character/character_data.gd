class_name CharacterData
extends RefCounted

signal stats_changed
signal hp_changed
signal effects_changed
signal inventory_changed
signal equipment_changed
signal resource_changed

const SAVE_VERSION := 1

# --- Идентификация ---
var id: int = 0
var created_at_unix: int = 0       # Time.get_unix_time_from_system()

# --- Класс ---
var class_id: StringName = &""
var subclass_id: StringName = &""
var archetype_id: StringName = &""

# --- Базовое ---
var character_name: String = ""
var race: RaceRef
var age: AgeValue
var sex: String = &""

# --- Ресурсы ---
#var class_resource: ClassResourceState
var hp: HpState
var stats: StatsData

# --- Личное ---
var personal: PersonalInfo

# --- Динамика ---
var active_effects: Array[ActiveEffect] = []
var ability_ids: Array[StringName] = []
var inventory: Array[InventoryItem] = []
var equipment: EquipmentLoadout

func _init() -> void:
	race = RaceRef.new()
	age = AgeValue.new()
	#class_resource = ClassResourceState.new()
	hp = HpState.new()
	stats = StatsData.new()
	personal = PersonalInfo.new()
	equipment = EquipmentLoadout.new()

# --- Мутации с сигналами ---

func set_hp(current: int) -> void:
	hp.current = clampi(current, 0, hp.max)
	hp_changed.emit()

func add_effect(effect: ActiveEffect) -> void:
	for existing in active_effects:
		if existing.effect_id == effect.effect_id:
			existing.stacks += effect.stacks
			effects_changed.emit()
			return
	active_effects.append(effect)
	effects_changed.emit()

func remove_effect(effect_id: StringName) -> bool:
	for i in range(active_effects.size()):
		if active_effects[i].effect_id == effect_id:
			active_effects.remove_at(i)
			effects_changed.emit()
			return true
	return false

func learn_ability(ability_id: StringName) -> bool:
	if ability_id in ability_ids:
		return false
	ability_ids.append(ability_id)
	return true

func forget_ability(ability_id: StringName) -> bool:
	var idx := ability_ids.find(ability_id)
	if idx == -1:
		return false
	ability_ids.remove_at(idx)
	return true

func add_item(item: InventoryItem) -> void:
	for existing in inventory:
		if existing.item_id == item.item_id:
			existing.quantity += item.quantity
			inventory_changed.emit()
			return
	inventory.append(item)
	inventory_changed.emit()

func remove_item(item_id: StringName, amount: int = 1) -> bool:
	for i in range(inventory.size()):
		var it := inventory[i]
		if it.item_id == item_id:
			it.quantity -= amount
			if it.quantity <= 0:
				inventory.remove_at(i)
			inventory_changed.emit()
			return true
	return false

func equip(slot: StringName, item_id: StringName) -> void:
	equipment.set_item(slot, item_id)
	equipment_changed.emit()

func unequip(slot: StringName) -> void:
	equipment.set_item(slot, &"")
	equipment_changed.emit()

# --- Сериализация ---

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
		"class_id": String(class_id),
		"subclass_id": String(subclass_id),
		"archetype_id": String(archetype_id),
		"character_name": character_name,
		"race": race.to_dict(),
		"age": age.to_dict(),
		"sex": String(sex),
		#"class_resource": class_resource.to_dict(),
		"hp": hp.to_dict(),
		"stats": stats.to_dict(),
		"personal": personal.to_dict(),
		"active_effects": effects,
		"ability_ids": abilities,
		"inventory": items,
		"equipment": equipment.to_dict(),
	}

static func from_dict(raw: Dictionary) -> CharacterData:
	var c := CharacterData.new()
	c.id = int(raw.get("id", 0))
	c.created_at_unix = int(raw.get("created_at_unix", 0))
	c.class_id = StringName(raw.get("class_id", ""))
	c.subclass_id = StringName(raw.get("subclass_id", ""))
	c.archetype_id = StringName(raw.get("archetype_id", ""))
	c.character_name = raw.get("character_name", "")
	c.gender = StringName(raw.get("gender", ""))

	if raw.has("race"):
		c.race = RaceRef.from_dict(raw["race"])
	if raw.has("age"):
		c.age = AgeValue.from_dict(raw["age"])
	#if raw.has("class_resource"):
		#c.class_resource = ClassResourceState.from_dict(raw["class_resource"])
	if raw.has("hp"):
		c.hp = HpState.from_dict(raw["hp"])
	if raw.has("stats"):
		c.stats = StatsData.from_dict(raw["stats"])
	if raw.has("personal"):
		c.personal = PersonalInfo.from_dict(raw["personal"])
	if raw.has("equipment"):
		c.equipment = EquipmentLoadout.from_dict(raw["equipment"])

	for e in raw.get("active_effects", []):
		c.active_effects.append(ActiveEffect.from_dict(e))
	for a in raw.get("ability_ids", []):
		c.ability_ids.append(StringName(a))
	for i in raw.get("inventory", []):
		c.inventory.append(InventoryItem.from_dict(i))

	return c

# character_data.gd
class_name CharacterData
extends ActorData

signal resource_changed(resource_id: StringName)

var class_id: StringName = &""
var subclass_id: StringName = &""
var archetype_id: StringName = &""
var race: RaceRef
var age: AgeValue
var sex: StringName = &""
var level: int = 1
var class_resources: Dictionary = {}
var personal: PersonalInfo

func _init() -> void:
	super()                         # обязательно, иначе hp/stats/equipment = null
	race = RaceRef.new()
	age = AgeValue.new()
	personal = PersonalInfo.new()

func load_from_dict(raw: Dictionary) -> void:
	super(raw)                      # ← ActorData-часть

	class_id = StringName(raw.get("class_id", ""))
	subclass_id = StringName(raw.get("subclass_id", ""))
	archetype_id = StringName(raw.get("archetype_id", ""))
	sex = StringName(raw.get("sex", ""))
	level = int(raw.get("level", 1))
	
	if raw.has("race"):
		race = RaceRef.from_dict(raw["race"])
	if raw.has("age"):
		age = AgeValue.from_dict(raw["age"])
	class_resources.clear()
	for res_id in raw.get("class_resources", {}):
		var res_raw: Dictionary = raw["class_resources"][res_id]
		var res := ResourceState.from_dict(res_raw)
		# resource_id в JSON не хранится отдельным полем,
		# ключ словаря и есть id — проставляем руками
		res.resource_id = StringName(res_id)
		class_resources[StringName(res_id)] = res
	if raw.has("personal"):
		personal = PersonalInfo.from_dict(raw["personal"])
	print(class_resources)

func to_dict() -> Dictionary:
	var d := super()
	d["class_id"] = String(class_id)
	d["subclass_id"] = String(subclass_id)
	d["archetype_id"] = String(archetype_id)
	d["sex"] = String(sex)
	d["level"] = level
	d["race"] = race.to_dict()
	d["age"] = age.to_dict()
	var resources := {}
	for res_id in class_resources:
		resources[String(res_id)] = class_resources[res_id].to_dict()
	d["class_resources"] = resources
	d["personal"] = personal.to_dict()
	return d

static func from_dict(raw: Dictionary) -> CharacterData:
	var c := CharacterData.new()
	c.load_from_dict(raw)
	return c

func get_resource(id: StringName) -> ResourceState:
	return class_resources.get(id)

func has_resource(id: StringName) -> bool:
	return class_resources.has(id)

func get_resources_in_order() -> Array[ResourceState]:
	# Возвращает ресурсы в порядке, заданном подклассом.
	# Если подкласс не найден — возвращает в произвольном порядке (как есть).
	var out: Array[ResourceState] = []
	var sub = DataManager.subclasses.get_by_id(subclass_id) if subclass_id != &"" else null
	if sub == null:
		for res in class_resources.values():
			out.append(res)
		return out
	for res_id in sub.resource_ids:
		var res: ResourceState = class_resources.get(res_id)
		if res != null:
			out.append(res)
	return out

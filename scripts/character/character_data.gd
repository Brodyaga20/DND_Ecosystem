# character_data.gd
class_name CharacterData
extends ActorData

var class_id: StringName = &""
var subclass_id: StringName = &""
var archetype_id: StringName = &""
var race: RaceRef
var age: AgeValue
var sex: StringName = &""
var level: int = 1
#var class_resource: ClassResourceState
var personal: PersonalInfo

func _init() -> void:
	super()                         # обязательно, иначе hp/stats/equipment = null
	race = RaceRef.new()
	age = AgeValue.new()
	#class_resource = ClassResourceState.new()
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
	#if raw.has("class_resource"):
		#class_resource = ClassResourceState.from_dict(raw["class_resource"])
	if raw.has("personal"):
		personal = PersonalInfo.from_dict(raw["personal"])

func to_dict() -> Dictionary:
	var d := super()                # ← ActorData-часть
	d["class_id"] = String(class_id)
	d["subclass_id"] = String(subclass_id)
	d["archetype_id"] = String(archetype_id)
	d["sex"] = String(sex)
	d["level"] = level
	d["race"] = race.to_dict()
	d["age"] = age.to_dict()
	#d["class_resource"] = class_resource.to_dict()
	d["personal"] = personal.to_dict()
	return d

static func from_dict(raw: Dictionary) -> CharacterData:
	var c := CharacterData.new()
	c.load_from_dict(raw)
	return c

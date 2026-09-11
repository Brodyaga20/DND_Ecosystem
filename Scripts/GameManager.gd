extends Node

const CHARACTERS_FILE = "user://characters.json"
const MAX_CHARACTERS = 6

var characters = []  # массив словарей

func _ready():
	load_characters()
	print(characters)

func load_characters():
	var file = FileAccess.open(CHARACTERS_FILE, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		var json = JSON.parse_string(text)
		if json:
			characters = json
		else:
			characters = []
			save_characters()
	else:
		characters = []
		save_characters()

func save_characters():
	var file = FileAccess.open(CHARACTERS_FILE, FileAccess.WRITE)
	if file:
		var json = JSON.stringify(characters, "\t")
		file.store_string(json)
		file.close()

func add_character(name: String, class_id: String, subclass_id: String, stats: Dictionary, background: String = "", traits: String = "", starting_gear: Array = []):
	if characters.size() >= MAX_CHARACTERS:
		return null  # или false
	var new_char = {
		"id": int(Time.get_unix_time_from_system() * 1000),  # уникальный ID
		"name": name,
		"class_id": class_id,
		"subclass_id": subclass_id,
		"archetype_id": null,
		"stats": stats,
		"resources": null, # позже заполним из данных подкласса
		"background": background,
		"traits": traits,
		"starting_gear": starting_gear,
		"hp_current": 40 + stats.get("strength", 0) * 10,  # начальное ХП
		"hp_max": 40 + stats.get("strength", 0) * 10,
		"created": Time.get_datetime_string_from_system(),
		"locked": false,
		"abilities_known": [DataManager.get_start_ability_for_subclass(subclass_id)["id"]]
	}


	var resource = DataManager.get_resource_from_subclass(subclass_id).duplicate(true)
	resource["amount"] = 0
	new_char["resources"] = resource
	characters.append(new_char)
	save_characters()
	return new_char

func delete_character(id: int):
	for i in range(characters.size()):
		if characters[i]["id"] == id:
			characters.remove_at(i)
			save_characters()
			return true
	return false

func get_character(id: int):
	for c in characters:
		if c["id"] == id:
			return c
	return null

extends Node

var classes = []
var subclasses = []
var archetypes = []
var abilities = []
var resource 

func _ready():
	load_data()

func load_data():
	var file = FileAccess.open("res://Data/Content.json", FileAccess.READ)
	if file:
		var text = file.get_as_text()
		var json = JSON.parse_string(text)
		if json:
			classes = json["classes"]
			subclasses = json["subclasses"]
			archetypes = json["archetypes"]
			abilities = json.get("abilities", [])

func get_class_data(id: String):
	for c in classes:
		if c["id"] == id:
			return c
	return null

func get_subclass_data(id: String):
	for s in subclasses:
		if s["id"] == id:
			return s
	return null

func get_archetype_data(id: String):
	for a in archetypes:
		if a["id"] == id:
			return a
	return null

func get_ability(id: String):
	for a in abilities:
		if a["id"] == id:
			return a
	return null

func get_resource_from_subclass(id: String):
	for s in subclasses:
		if s["id"] == id:
			print(s["resource"])
			return s["resource"]
	return null

func get_start_ability_for_subclass(subclass: String):
	for a in abilities:
		if a["direction"] == subclass and a["tier"] == 0:
			return a


func get_subclasses_for_class(class_id: String):
	var result = []
	for s in subclasses:
		if s["class_id"] == class_id:
			result.append(s)
	return result

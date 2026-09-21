extends Node

var classes = []
var subclasses = []
var archetypes = []
var abilities = []
var races = []
var ages_periods = []
var stats = []
var resource 

func _ready():
	load_data()

func load_data():
	var file = FileAccess.open("res://data/content.json", FileAccess.READ)
	if file:
		var text = file.get_as_text()
		var json = JSON.parse_string(text)
		if json:
			classes = json["classes"]
			subclasses = json["subclasses"]
			archetypes = json["archetypes"]
			races = json["races"]
			abilities = json["abilities"]
			ages_periods = json["ages_periods_names"]
			stats = json["stats"]

func get_name_from_age_period_id(id: String):
	for a in ages_periods:
		if a["id"] == id:
			return a["name"]
	return null

func get_data_from_stat_id(id: String):
	for s in stats:
		if s["id"] == id:
			return s
	return null

func get_class_data(id: String) -> Dictionary:
	for c in classes:
		if c["id"] == id:
			return c
	return {}

func get_class_name_from_id(id: String):
	return get_class_data(id)["name"]

func get_class_description_from_id(id: String):
	return get_class_data(id)["description"]

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

func get_race_data(id: String):
	for r in races:
		if r["id"] == id:
			return r
	return null

func get_resource_from_subclass(id: String):
	for s in subclasses:
		if s["id"] == id:
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

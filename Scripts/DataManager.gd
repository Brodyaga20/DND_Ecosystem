extends Node

var classes = []
var subclasses = []
var archetypes = []

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
			print("DataManager: данные загружены")
		else:
			print("Ошибка парсинга JSON")
	else:
		print("Файл content.json не найден")

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

func get_subclasses_for_class(class_id: String):
	var result = []
	for s in subclasses:
		if s["class_id"] == class_id:
			result.append(s)
	return result

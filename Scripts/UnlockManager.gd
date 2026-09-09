extends Node

const UNLOCK_FILE = "user://unlocked.json"

var unlocked = {
	"classes": [],
	"subclasses": [],
	"archetypes": [],
	"items": [],
	"spells": []
}
var empty_unlocks = {
	"classes": [],
	"subclasses": [],
	"archetypes": [],
	"items": [],
	"spells": []
}

func _ready():
	load_unlocks()

func load_unlocks():
	var file = FileAccess.open(UNLOCK_FILE, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		var json = JSON.parse_string(text)
		if json:
			unlocked = json
			print("UnlockManager: загружено разблокировок")
		else:
			print("UnlockManager: ошибка парсинга unlock.json, создаём новый")
			save_unlocks()
	else:
		print("UnlockManager: файл unlock.json не найден, создаём новый")
		save_unlocks()

func save_unlocks():
	var file = FileAccess.open(UNLOCK_FILE, FileAccess.WRITE)
	if file:
		var json = JSON.stringify(unlocked, "\t")
		file.store_string(json)
		file.close()
		print("UnlockManager: сохранено в файл")

func is_class_unlocked(class_id: String) -> bool:
	return class_id in unlocked["classes"]

func is_subclass_unlocked(subclass_id: String) -> bool:
	return subclass_id in unlocked["subclasses"]

func is_archetype_unlocked(archetype_id: String) -> bool:
	return archetype_id in unlocked["archetypes"]

func unlock_class(class_id: String):
	if not is_class_unlocked(class_id):
		unlocked["classes"].append(class_id)
		save_unlocks()

func unlock_subclass(subclass_id: String):
	if not is_subclass_unlocked(subclass_id):
		unlocked["subclasses"].append(subclass_id)
		save_unlocks()

func unlock_archetype(archetype_id: String):
	if not is_archetype_unlocked(archetype_id):
		unlocked["archetypes"].append(archetype_id)
		save_unlocks()

func lock_everything() -> void:
	var file = FileAccess.open(UNLOCK_FILE, FileAccess.WRITE)
	if file:
		unlocked = empty_unlocks
		var json = JSON.stringify(unlocked, "\t")
		file.store_string(json)
		file.close()
		print("UnlockManager: сохранено")
	return

func set_unlocks_from_server(data: Dictionary):
	unlocked = data
	save_unlocks()

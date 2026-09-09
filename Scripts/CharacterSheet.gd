extends Node2D

var character_id = null
var character_data = null

func _ready():
	character_id = GameState.current_character_id
	if character_id == null:
		# Если ID не передан, возвращаемся в список
		get_tree().change_scene_to_file("res://scenes/CharacterList.tscn")
		return
	
	character_data = GameManager.get_character(character_id)
	if character_data == null:
		print("Персонаж не найден!")
		get_tree().change_scene_to_file("res://scenes/CharacterList.tscn")
		return
	
	update_display()

func update_display():
	var class_data = DataManager.get_class_data(character_data["class_id"])
	var subclass_data = DataManager.get_subclass_data(character_data["subclass_id"])
	
	$Name.text = character_data["name"]
	$Class.text = class_data["name"] + " - " + subclass_data["name"]
	#$VBoxContainer/HPLabel.text = "ХП: %d / %d" % [character_data["hp_current"], character_data["hp_max"]]
	var selected_subclass = character_data["subclass_id"]
	# Статы
	var stats = character_data["stats"]
	$VBoxContainer/StrengthLabel.text = "Сила: " + str(int(stats["strength"]))
	$VBoxContainer/AgilityLabel.text = "Ловкость: " + str(int(stats["dexterity"]))
	$VBoxContainer/IntelligenceLabel.text = "Интеллект: " + str(int(stats["intelligence"]))
	$VBoxContainer/LuckLabel.text = "Удача: " + str(int(stats["luck"]))
	print(character_data)
	# Предыстория и особенности
	$History.text = character_data.get("background", "")
	$Traits.text = character_data.get("traits", "")
	$Avatar.texture = load("res://Assets/Avatars/" + selected_subclass + ".png")
	# Снаряжение (пока список)
	#var gear = character_data.get("starting_gear", [])
	#$VBoxContainer/GearList.clear()
	#for item_id in gear:
		#var item = ItemDatabase.get_item(item_id)
		#if item:
			#$VBoxContainer/GearList.add_item(item["name"])

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/CharacterList.tscn")

func _on_edit_button_pressed():
	# Переключаем режим редактирования (имя, предыстория, особенности)
	# Можно сделать простой диалог или отдельную сцену редактирования
	pass

extends Node2D

var character_id = null
var character_data = null
var mode = "look"

func _ready():
	$NameEdit.visible = false
	$HistoryEdit.visible = false
	$TraitsEdit.visible = false
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
	match mode:
		"look":
			mode = "edit"
			$Back.disabled = true
			if !character_data["locked"]:
				$Name.visible = false
				$History.visible = false
				$Traits.visible = false
				$NameEdit.text = $Name.text
				$NameEdit.visible = true
				$HistoryEdit.text = $History.text
				$HistoryEdit.visible = true
				$TraitsEdit.text = $Traits.text
				$TraitsEdit.visible = true
		"edit":
			mode = "look"
			$Back.disabled = false
			$NameEdit.visible = false
			$HistoryEdit.visible = false
			$TraitsEdit.visible = false
			$Name.visible = true
			$History.visible = true
			$Traits.visible = true
			save_data()

func save_data():
	var new_name = $NameEdit.text
	if new_name == "":
		print("Имя не может быть пустым!")
		return
	
	var new_background = $HistoryEdit.text
	var new_traits = $TraitsEdit.text
	
	# Обновляем данные в character_data
	character_data["name"] = new_name
	character_data["background"] = new_background
	character_data["traits"] = new_traits
	
	# Сохраняем весь массив персонажей в файл
	GameManager.save_characters()
	
	# Обновляем отображение (чтобы Label показали новые значения)
	update_display()
	
	# Выходим из режима редактирования

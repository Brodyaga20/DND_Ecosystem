extends Control

var character_id = null
var mode = "look"
var is_master = false
var peer_id
var char_data = GameState.player

const null_glow_color := Color(0, 0, 0)
const active_glow_color := Color(1, 1, 1)

const null_glow_width := 5
const active_glow_width := 15

func _ready():
	$Editable/Name/NameEdit.visible = false
	$Editable/History/HistoryEdit.visible = false
	$Editable/Traits/TraitsEdit.visible = false
	if char_data == null:
		get_tree().change_scene_to_file("res://scenes/characters_list.tscn")
	set_vision()
	update_display()

func set_vision():
	$MasterEdit.visible = is_master

func update_display():
	update_pictures()
	
	#var stats = character_data["stats"]
	#var resource = character_data["resources"]
	#var abilities = character_data.get("abilities_known", [])
	#update_data(selected_subclass)
	#update_stats(stats)
	#update_resources(resource)
	#update_abilities(abilities)
	$Editable/Name/Name.text = char_data.character_name
	
	
	# Снаряжение (пока список)
	#var gear = character_data.get("starting_gear", [])
	#$VBoxContainer/GearList.clear()
	#for item_id in gear:
		#var item = ItemDatabase.get_item(item_id)
		#if item:
			#$VBoxContainer/GearList.add_item(item["name"])

func update_pictures():
	update_class()
	update_subclass()
	update_archetype()

func update_class():
	var selected_class = DataManager.character_classes.get_by_id(char_data.class_id)
	var class_path : String
	if selected_class != null:
		class_path = "res://assets/pictures/profile/class/" + str(char_data.class_id) + ".png"
		$Class/Sprite.texture = load(class_path)

func update_subclass():
	var selected_subclass = DataManager.character_subclasses.get_by_id(char_data.subclass_id)
	var subclass_path : String
	if selected_subclass != null:
		subclass_path = "res://assets/pictures/profile/subclass/" + str(char_data.subclass_id) + ".png"
		$Subclass/Sprite.texture = load(subclass_path)
		$Subclass.glow_hover = 15
		$Subclass.update_shader_parameter("glow_color", active_glow_color)
		$Subclass.update_shader_parameter("glow_width", active_glow_width)
	else:
		$Subclass/Sprite.texture = load("res://assets/pictures/profile/subclass/locked.png")
		$Subclass.update_shader_parameter("glow_color", null_glow_color)
		$Subclass.update_shader_parameter("glow_width", null_glow_width)

func update_archetype():
	var selected_archetype = DataManager.character_archetypes.get_by_id(char_data.archetype_id)
	var archetype_path : String
	if selected_archetype != null:
		archetype_path = "res://assets/pictures/profile/subclass/" + str(char_data.archetype_id) + ".png"
		$Archetype/Sprite.texture = load(archetype_path)
		$Archetype.update_shader_parameter("glow_color", active_glow_color)
		$Archetype.update_shader_parameter("glow_width", active_glow_width)
	else:
		print("no archetype")
		$Archetype/Sprite.texture = load("res://assets/pictures/profile/archetype/locked.png")
		$Archetype.update_shader_parameter("glow_color", null_glow_color)
		$Archetype.update_shader_parameter("glow_width", null_glow_width)
		print($Archetype.glow_color)

func update_stats(stats):
	$StatsContainer/StrengthLabel.text = "Сила: " + str(int(stats["strength"]))
	$StatsContainer/AgilityLabel.text = "Ловкость: " + str(int(stats["dexterity"]))
	$StatsContainer/IntelligenceLabel.text = "Интеллект: " + str(int(stats["intelligence"]))
	$StatsContainer/LuckLabel.text = "Удача: " + str(int(stats["luck"]))

func update_resources(resource):
	$Resource/ResourceName.text = resource["name"]
	$Resource/ResourceAmount.text = str(resource["amount"])
	#$HP/ResourceAmount.text = "%d / %d" % [character_data["hp_current"], character_data["hp_max"]]

func update_abilities(abilities):
	$Abilities/Abilities.clear()
	for id in abilities:
		var ab = DataManager.get_ability(id)
		if ab:
			$Abilities/Abilities.add_item(ab["name"])
			$Abilities/Abilities.set_item_tooltip(-1, ab["short_desc"])
		else:
			$Abilities/Abilities.add_item(id + " (неизвестно)")

func _on_back_button_pressed():
	if !is_master:
		get_tree().change_scene_to_file("res://scenes/characters_list.tscn")
		return
	get_tree().change_scene_to_file("res://scenes/master_list.tscn")

func _on_edit_button_pressed():
	match mode:
		"look":
			mode = "edit"
			$buttons/Back.disabled = true
			#if !character_data["locked"]:
				#$Editable/Name/Name.visible = false
				#$Editable/History/History.visible = false
				#$Editable/Traits/Traits.visible = false
				#$Editable/Name/NameEdit.text = $Editable/Name/Name.text
				#$Editable/Name/NameEdit.visible = true
				#$Editable/History/HistoryEdit.text = $Editable/History/History.text
				#$Editable/History/HistoryEdit.visible = true
				#$Editable/Traits/TraitsEdit.text = $Editable/Traits/Traits.text
				#$Editable/Traits/TraitsEdit.visible = true
		"edit":
			mode = "look"
			$buttons/Back.disabled = false
			$Editable/Name/NameEdit.visible = false
			$Editable/History/HistoryEdit.visible = false
			$Editable/Traits/TraitsEdit.visible = false
			$Editable/Name/Name.visible = true
			$Editable/History/History.visible = true
			$Editable/Traits/Traits.visible = true
			save_data()

func save_data():
	var new_name = $Editable/Name/NameEdit.text
	if new_name == "":
		return
	
	var new_background = $Editable/History/HistoryEdit.text
	var new_traits = $Editable/Traits/TraitsEdit.text
	
	# Обновляем данные в character_data
	#character_data["name"] = new_name
	#character_data["background"] = new_background
	#character_data["traits"] = new_traits
	
	# Сохраняем весь массив персонажей в файл
	#GameManager.save_characters()
	
	# Обновляем отображение (чтобы Label показали новые значения)
	update_display()
	
	# Выходим из режима редактирования

func _on_hp_apply_pressed() -> void:
	if not is_master: return
	var input = $MasterEdit/HPEdit.text
	if input == "": return
	var delta = int(input)
	#character_data["hp_current"] += delta
	# Не даём упасть ниже 0
	#if character_data["hp_current"] < 0:
		#character_data["hp_current"] = 0
	# Не даём превысить максимум
	#if character_data["hp_current"] > character_data["hp_max"]:
		#character_data["hp_current"] = character_data["hp_max"]
	#$MasterEdit/HPEdit.text = ""  # очищаем поле
	#GameManager.save_characters()
	update_display()
	#if is_master and multiplayer.is_server():
		#NetworkManager.update_character.rpc(character_data, peer_id)
	pass # Replace with function body.


func _on_res_apply_pressed() -> void:
	if not is_master: return
	var input = $MasterEdit/ResEdit.text
	if input == "": return
	var delta = int(input)
	#if character_data["resources"].size() == 0: return
	#if not character_data["resources"].has("amount"): return
	#character_data["resources"]["amount"] += delta
	# Ограничения по минимуму/максимуму можно взять из данных подкласса
	#var subclass_data = DataManager.get_subclass_data(character_data["subclass_id"])
	#if subclass_data and subclass_data.has("resource"):
		#var min_val = subclass_data["resource"].get("min", 0)
		#var max_val = subclass_data["resource"].get("max", 10)
		#if character_data["resources"]["amount"] < min_val:
			#character_data["resources"]["amount"] = min_val
		#if character_data["resources"]["amount"] > max_val:
			#character_data["resources"]["amount"] = max_val
	#$MasterEdit/ResEdit.text = ""
	#GameManager.save_characters()
	#update_display()

func refresh_data():
	# Перезагружаем данные из GameState.remote_characters или GameManager
	if GameState.current_peer_id != null:
		# Если это удалённый персонаж, берём из remote_characters
		var remote_data = GameState.remote_characters.get(GameState.current_peer_id)
		#if remote_data:
			#character_data = remote_data
		#else:
			# возможно, персонаж удалён – вернуться в список
			#get_tree().change_scene_to_file("res://scenes/characters_list.tscn")
			#return
	#else:
		# Локальный персонаж – из GameManager
		#if not character_data:
			#get_tree().change_scene_to_file("res://scenes/characters_list.tscn")
			#return
	update_display()

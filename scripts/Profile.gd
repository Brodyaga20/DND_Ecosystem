extends Control

var character_id = null
var mode = "look"
var is_master = false
var peer_id
var char_data := GameState.player
var abilities := char_data.ability_ids

const null_glow_color := Color(0, 0, 0)
const active_glow_color := Color(1, 1, 1)

const null_glow_width := 5
const active_glow_width := 15

enum CardTypes {CLASS, SUBCLASS, ARCHETYPE}

func _ready():
	var hp_line = $HpSubstrate/HpLine
	if char_data == null:
		get_tree().change_scene_to_file("res://scenes/characters_list.tscn")
	hp_line.region_enabled = true
	set_vision()
	update_display()

func set_vision():
	$MasterEdit.visible = is_master

func update_display():
	update_name()
	update_cards()
	update_money()
	update_abilities()
	update_hp()
	#var stats = character_data["stats"]
	#var resource = character_data["resources"]
	#var abilities = character_data.get("abilities_known", [])
	#update_data(selected_subclass)
	#update_stats(stats)
	#update_resources(resource)
	#update_abilities(abilities)
	
	
	# Снаряжение (пока список)
	#var gear = character_data.get("starting_gear", [])
	#$VBoxContainer/GearList.clear()
	#for item_id in gear:
		#var item = ItemDatabase.get_item(item_id)
		#if item:
			#$VBoxContainer/GearList.add_item(item["name"])

func update_name():
	$NameSubstrate/Label.text = str(GameState.player.character_name)

func update_hp():
	$HpSubstrate/GlowElement2.hover_text = str(GameState.player.hp.current_hp) + "/" + str(GameState.player.hp.max_hp)
	$HpSubstrate/HPLabel.text = str(GameState.player.hp.current_hp)
	var percent = GameState.player.hp.get_percentage()
	var width = int(percent * 2.12 + 9)
	$HpSubstrate/HpLine.region_rect = Rect2(0, 0, width, 50)
	pass

func update_cards():
	update_class()
	update_subclass()
	update_archetype()
	update_abilities()

func update_money():
	$MoneySubstrate/Coins/MagicCoin/Amount.text = str(GameState.player.money.magic_coin)
	$MoneySubstrate/Coins/GoldCoin/Amount.text= str(GameState.player.money.gold_coin)
	$MoneySubstrate/Coins/SilverCoin/Amount.text = str(GameState.player.money.silver_coin)
	$MoneySubstrate/Coins/CopperCoin/Amount.text = str(GameState.player.money.copper_coin)

func update_abilities():
	if !abilities.is_empty():
		for i in clampi(abilities.size(), 0, 3):
			update_abilitiy_cards(i)

func update_abilitiy_cards(number: int):
	var sprite: Sprite2D
	var ability_tier = DataManager.abilities.get_by_id(abilities[number]).tier
	sprite = $RightSubstrate/AbilitiesSubstrate/Control.get_child(number).get_child(0)
	var sprite_root = sprite.get_parent()
	var path : String = "res://assets/pictures/abilities/" + str(ability_tier) + "/" + abilities[number] + ".png"
	var ability_name = DataManager.abilities.get_by_id(abilities[number]).display_name
	var hover_text = " " + ability_name + " "
	sprite_root.has_tooltip = true
	sprite_root.hover_text = hover_text
	sprite.texture = load(path)
	pass

func update_class():
	var selected_class = DataManager.character_classes.get_by_id(char_data.class_id)
	if selected_class != null:
		configure_unlocked_card($ProgressCards/Class/Sprite, CardTypes.CLASS)
	else:
		configure_locked_card($ProgressCards/Class/Sprite)

func update_subclass():
	var selected_subclass = DataManager.character_subclasses.get_by_id(char_data.subclass_id)
	if selected_subclass != null:
		configure_unlocked_card($ProgressCards/Subclass/Sprite, CardTypes.SUBCLASS)
	else:
		configure_locked_card($ProgressCards/Subclass/Sprite)

func update_archetype():
	var selected_archetype = DataManager.character_archetypes.get_by_id(char_data.archetype_id)
	if selected_archetype != null:
		configure_unlocked_card($ProgressCards/Archetype/Sprite, CardTypes.ARCHETYPE)
	else:
		configure_locked_card($ProgressCards/Archetype/Sprite)

func configure_unlocked_card(sprite: Sprite2D, type: CardTypes):
	var path : String
	var id : String
	var data : RefCounted
	match type:
		CardTypes.CLASS:
			id = str(char_data.class_id)
			path = "res://assets/pictures/profile/class/" + id + ".png"
			data = DataManager.character_classes.get_by_id(id)
		CardTypes.SUBCLASS:
			id = str(char_data.subclass_id)
			path = "res://assets/pictures/profile/subclass/" + id + ".png"
			data = DataManager.character_subclasses.get_by_id(id)
		CardTypes.ARCHETYPE:
			id = str(char_data.subclass_id)
			path = "res://assets/pictures/profile/archetype/" + id + ".png"
			data = DataManager.character_archetypes.get_by_id(id)
	var role_name := str(data.display_name)
	var sprite_root = sprite.get_parent()
	sprite.texture = load(path)
	sprite_root.has_tooltip = true
	var text = " " + role_name + " "
	sprite_root.hover_text = text

func configure_locked_card(sprite: Sprite2D):
	var sprite_root : GlowElement
	sprite_root = sprite.get_parent()
	var text_node : Label
	for c in sprite_root.get_children():
		if c.name == "Label":
			text_node = sprite_root.get_child(1)
			text_node.text = "???"
	sprite.texture = load("res://assets/pictures/profile/locked.png")
	sprite_root.update_shader_parameter("glow_color", null_glow_color)
	sprite_root.update_shader_parameter("glow_width", null_glow_width)
	pass

func update_stats(stats):
	$StatsContainer/StrengthLabel.text = "Сила: " + str(int(stats["strength"]))
	$StatsContainer/AgilityLabel.text = "Ловкость: " + str(int(stats["dexterity"]))
	$StatsContainer/IntelligenceLabel.text = "Интеллект: " + str(int(stats["intelligence"]))
	$StatsContainer/LuckLabel.text = "Удача: " + str(int(stats["luck"]))

func update_resources(resource):
	$Resource/ResourceName.text = resource["name"]
	$Resource/ResourceAmount.text = str(resource["amount"])
	#$HP/ResourceAmount.text = "%d / %d" % [character_data["hp_current"], character_data["hp_max"]]

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
	update_display()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/characters_list.tscn")

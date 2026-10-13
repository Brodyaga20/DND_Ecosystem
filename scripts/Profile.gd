extends Control

var hp_atlas := AtlasTexture.new()
var mode = "look"
var is_master = false
var peer_id
var char_data := GameState.player
var abilities := char_data.ability_ids


const null_glow_color := Color(0, 0, 0)
const active_glow_color := Color(1, 1, 1)
const unlockable_glow_color := Color(1, 1, 0)

const null_glow_width := 5
const active_glow_width := 15
const unlockable_normal_glow_width := 10
const unlockable_hover_glow_width := 16

enum CardTypes {CLASS, SUBCLASS, ARCHETYPE}

const BASE_STAT_SUM := 6
const MAX_LEVEL := 100

const GLOW_SHADER_MATERIAL := "res://shaders/shader_materials/glow_element.tres"
const CHARACTER_LIST_SCENE := "res://scenes/characters_list.tscn"

const BERSERKER_FILL_OFFSET := Vector2(-155, 7)

@onready var level_label: Label = $StatsSubstract/Level
@onready var total_progress: TextureProgressBar = $StatsSubstract/ProgressBar
@onready var hp_line_texture: TextureRect = $ResourcesSubstrate/HP/HpLine
@onready var hp_atlas_texture_path: Texture2D = load("res://assets/pictures/profile/hp/hp_line.png")
@onready var ability_container : HBoxContainer = $RightSubstrate/AbilitiesSubstrate/AbilityContainer
@onready var hp_label : Label = $ResourcesSubstrate/HP/HPLabel

@onready var class_card_sprite: Sprite2D = $ProgressCards/Class/Sprite
@onready var subclass_card_sprite: Sprite2D = $ProgressCards/Subclass/Sprite
@onready var archetype_card_sprite: Sprite2D = $ProgressCards/Archetype/Sprite
@onready var apotheosis_card_sprite: Sprite2D = $ProgressCards/Apotheosis/Sprite

@onready var resource_scale_sprite : Sprite2D = $ResourcesSubstrate/ClassResource/Scale
@onready var slots_container : HBoxContainer = $ResourcesSubstrate/ClassResource/Slots
@onready var stat_ui_nodes: Dictionary = {
	"power": {
		"control": $StatsSubstract/Power,
		"label": $StatsSubstract/Power/Number,
		"bar": $StatsSubstract/Power/LevelProgress
	},
	"agility": {
		"control": $StatsSubstract/Agility,
		"label": $StatsSubstract/Agility/Number,
		"bar": $StatsSubstract/Agility/LevelProgress
	},
	"intelligence": {
		"control": $StatsSubstract/Intelligence,
		"label": $StatsSubstract/Intelligence/Number,
		"bar": $StatsSubstract/Intelligence/LevelProgress
	},
	"luck": {
		"control": $StatsSubstract/Luck,
		"label": $StatsSubstract/Luck/Number,
		"bar": $StatsSubstract/Luck/LevelProgress
	}
}

func _ready():
	if char_data == null:
		get_tree().change_scene_to_file(CHARACTER_LIST_SCENE)
	hp_atlas.atlas = hp_atlas_texture_path
	hp_line_texture.texture = hp_atlas
	update_display()

func update_display():
	update_name()
	update_cards()
	update_money()
	update_abilities()
	update_hp()
	update_stats()
	if GameState.player.subclass_id:
		update_subclass_resource_scale()
		update_subclass_resource_display()
	

func update_subclass_resource_scale():
	var scale_texture : Texture2D
	if GameState.player.subclass_id:
		scale_texture = load("res://assets/pictures/profile/class_resource_scales/" + str(GameState.player.subclass_id) + ".png")
		resource_scale_sprite.texture = scale_texture

func update_subclass_resource_display():
	match GameState.player.subclass_id:
		#"paladin":
			#set_paladin_dot()
		#"master":
			#add_master_soul_and_body_bars()
			#fill_master_soul_and_body()
		#"knight":
			#fill_knight_durability()
		#"commander":
			#fill_commander_leadership()
		"berserker":
			#add_berserker_bar()
			fill_berserker_rage()

func fill_berserker_rage():
	var bar := TextureProgressBar.new()
	bar.texture_progress = load("res://assets/pictures/profile/class_resource_scales/berserker_filled.png")
	bar.fill_mode = TextureProgressBar.FillMode.FILL_LEFT_TO_RIGHT
	bar.value = 100
	bar.position = BERSERKER_FILL_OFFSET
	$ResourcesSubstrate/ClassResource.add_child(bar)

func update_stats() -> void:
	var stats = GameState.player.stats
	var max_percentage: float = 0.0
	var stat_sum: int = 0

	for stat_name in stat_ui_nodes.keys():
		var value = stats.get(stat_name).level
		var xp = stats.get(stat_name).xp
		var percentage =  stats.get(stat_name).get_percentage()
		var pool = stats.get(stat_name).xp_pool()
		var tooltip_text = str(xp) + "/" + str(pool)
		stat_sum += value
		stat_ui_nodes[stat_name]["label"].text = str(value)
		stat_ui_nodes[stat_name]["bar"].value = percentage * 100
		stat_ui_nodes[stat_name]["control"].has_tooltip = true
		stat_ui_nodes[stat_name]["control"].tooltip_lines.clear()
		stat_ui_nodes[stat_name]["control"].tooltip_lines.append(tooltip_text)
		#stat_sum += value
		
		if percentage * 100 > max_percentage:
			max_percentage = percentage * 100

	var level = clampi(int(stat_sum - BASE_STAT_SUM), 0, MAX_LEVEL)
	level_label.text = str(level)
	print(max_percentage)
	total_progress.value = max_percentage
	GameState.player.level = level


func update_name():
	$NameSubstrate/Label.text = str(GameState.player.character_name)

func update_hp():
	hp_label.text = str(GameState.player.hp.current_hp) + "/" + str(GameState.player.hp.max_hp)
	var percent = GameState.player.hp.get_percentage()
	var width = int(percent * hp_atlas.get_width()/100)
	hp_atlas.region = Rect2(0, 0, width, hp_atlas.get_height())
	#$HpSubstrate/HpLine.texture = Rect2(0, 0, width, 50)
	pass

func update_cards():
	update_class()
	update_subclass()
	update_archetype()
	#update_apotheosis()

func update_money():
	$MoneySubstrate/Coins/MagicCoin/Amount.text = str(GameState.player.money.magic_coin)
	$MoneySubstrate/Coins/GoldCoin/Amount.text= str(GameState.player.money.gold_coin)
	$MoneySubstrate/Coins/SilverCoin/Amount.text = str(GameState.player.money.silver_coin)
	$MoneySubstrate/Coins/CopperCoin/Amount.text = str(GameState.player.money.copper_coin)

func update_abilities():
	if !abilities.is_empty():
		for i in clampi(abilities.size(), 0, 3):
			add_abilitiy_card(i)

func add_abilitiy_card(number: int):
	var sprite := Sprite2D.new()
	var ability_id = GameState.player.ability_ids[number]
	var tier := str(DataManager.abilities.get_by_id(ability_id).tier)
	var path := str("res://assets/pictures/abilities/" + tier + "/" + ability_id + ".png")
	sprite.texture = load(path)
	var glow_element := GlowElement.new()
	glow_element.material = load(GLOW_SHADER_MATERIAL)
	glow_element.add_child(sprite)
	glow_element.custom_minimum_size = sprite.get_rect().size
	ability_container.add_child(glow_element)

func add_effect_card(number: int):
	var sprite := Sprite2D.new()
	var ability_id = GameState.player.ability_ids[number]
	var tier := str(DataManager.abilities.get_by_id(ability_id).tier)
	var path := str("res://assets/pictures/abilities/" + tier + "/" + ability_id + ".png")
	sprite.texture = load(path)
	var glow_element := GlowElement.new()
	glow_element.material = load(GLOW_SHADER_MATERIAL)
	glow_element.add_child(sprite)
	glow_element.custom_minimum_size = sprite.get_rect().size
	ability_container.add_child(glow_element)

func add_familiar_card(number: int):
	var sprite := Sprite2D.new()
	var ability_id = GameState.player.ability_ids[number]
	var tier := str(DataManager.abilities.get_by_id(ability_id).tier)
	var path := str("res://assets/pictures/abilities/" + tier + "/" + ability_id + ".png")
	sprite.texture = load(path)
	var glow_element := GlowElement.new()
	glow_element.material = load(GLOW_SHADER_MATERIAL)
	glow_element.add_child(sprite)
	glow_element.custom_minimum_size = sprite.get_rect().size
	ability_container.add_child(glow_element)

func update_class():
	var selected_class = DataManager.character_classes.get_by_id(char_data.class_id)
	if selected_class != null:
		configure_unlocked_card(class_card_sprite, CardTypes.CLASS)
	else:
		configure_locked_card(class_card_sprite)

func update_subclass():
	var selected_subclass = DataManager.character_subclasses.get_by_id(char_data.subclass_id)
	if selected_subclass != null:
		configure_unlocked_card(subclass_card_sprite, CardTypes.SUBCLASS)
	else:
		configure_locked_card(subclass_card_sprite)
		if GameState.player.can_unlock_subclass():
			configure_unlockable_card(subclass_card_sprite)

func update_archetype():
	var selected_archetype = DataManager.character_archetypes.get_by_id(char_data.archetype_id)
	if selected_archetype != null:
		configure_unlocked_card(archetype_card_sprite, CardTypes.ARCHETYPE)
	else:
		configure_locked_card(archetype_card_sprite)

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
	sprite_root.tooltip_lines.append(text)

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
	sprite_root.glow_hover = null_glow_width
	pass

func configure_unlockable_card(sprite: Sprite2D):
	var sprite_root : GlowElement
	sprite_root = sprite.get_parent()
	var text_node : Label
	for c in sprite_root.get_children():
		if c.name == "Label":
			text_node = sprite_root.get_child(1)
			text_node.text = "ДОСТУПНО:\nПОДКЛАСС"
	sprite.texture = load("res://assets/pictures/profile/locked.png")
	sprite_root.update_shader_parameter("glow_color", unlockable_glow_color)
	sprite_root.update_shader_parameter("glow_width", unlockable_normal_glow_width)
	sprite_root.glow_off = unlockable_normal_glow_width
	sprite_root.glow_hover = unlockable_hover_glow_width
	pass

func update_resources(resource):
	$Resource/ResourceName.text = resource["name"]
	$Resource/ResourceAmount.text = str(resource["amount"])
	#$HP/ResourceAmount.text = "%d / %d" % [character_data["hp_current"], character_data["hp_max"]]

func _on_edit_button_pressed():
	match mode:
		"look":
			mode = "edit"
		"edit":
			mode = "look"

func save_data():
	update_display()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(CHARACTER_LIST_SCENE)


func _on_plus_pressed() -> void:
	GameState.player.stats.power.add_xp($StatsSubstract/Power/Add.value)
	update_stats()
	update_cards()

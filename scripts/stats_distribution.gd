extends Node2D

var max_start_points := 7
var remaining_points := 7
var selected_stat := ""
var preselected_stat := ""
var selected_id := ""

@onready var sprites_root: Node2D = $Bowls
@onready var math_signs_root: Node2D = $MainNumber
@onready var main_number: Label = $MainNumber/MainNumberContainer/SubViewport/MainNumber

@onready var numbers := {
	"power":        $SmallNumbers/Power,
	"intelligence": $SmallNumbers/Intelligence,
	"agility":      $SmallNumbers/Agility,
	"luck":         $SmallNumbers/Luck,
}

@onready var stat_colors := {
	"power":        Color(1.0, 0.5, 0.5),
	"intelligence": Color(0.5, 0.5, 1.0),
	"agility":      Color(0.5, 0.8, 0.5),
	"luck":         Color(1.0, 0.85, 0.4),
}

func _ready() -> void:
	update_ui()
	clear()
	$Next.disabled = true

	for child in sprites_root.get_children():
		if child is GlowElement:
			child.id_selected.connect(_on_stat_bowl_selected)
		
	for child in math_signs_root.get_children():
		if child is GlowElement:
			child.id_pressed.connect(_on_plus_minus_pressed)

func clear() -> void:
	main_number.text = ""
	$MainNumber.visible = false
	$Blur/CentralTitle.text = ""
	$Blur/CentralDescription.text = ""
	selected_id = ""

func update_ui() -> void:
	update_derived_stats()

func update_derived_stats() -> void:
	#var strength = $Stats/Strength/SpinBox.value
	#var agility = $Stats/Agility/SpinBox.value
	#var intelligence = $Stats/Intelligence/SpinBox.value
	#var luck = $Stats/Luck/SpinBox.value
	#$Derivatives/Numbers/Health.text = str(int(40 + strength * 10))
	# ... (оставил закомментированным как было)
	pass

func _on_back_pressed() -> void:
	var class_id = TempData.class_id
	match class_id:
		"warrior":
			get_tree().change_scene_to_file("res://scenes/WarriorSubclassSelect.tscn")
		"rogue":
			get_tree().change_scene_to_file("res://scenes/RogueSubclassSelect.tscn")
		"mage":
			get_tree().change_scene_to_file("res://scenes/MageSubclassSelect.tscn")

func _on_next_pressed() -> void:
	if $Name/Entering.text != "":
		TempData.character_name = $Name/Entering.text
		TempData.stats = {
			"power":        $Stats/Strength/SpinBox.value,
			"agility":      $Stats/Agility/SpinBox.value,
			"intelligence": $Stats/Intelligence/SpinBox.value,
			"luck":         $Stats/Luck/SpinBox.value,
		}
		TempData.history = $History/Text.text
		TempData.traits = $Traits/Text.text
		var _new_char = GameManager.add_character(
			TempData.character_name,
			TempData.class_id,
			TempData.subclass_id,
			TempData.stats,
			TempData.history,
			TempData.traits
		)
		TempData.reset()
		get_tree().change_scene_to_file("res://scenes/CharacterList.tscn")

func update_central_labels() -> void:
	update_selected_stat_text()
	update_main_number()

func update_selected_stat_text() -> void:
	if selected_id == "":
		$Blur/CentralTitle.text = ""
		$Blur/CentralDescription.text = ""
		return
	var data = DataManager.get_data_from_stat_id(selected_id)
	$Blur/CentralTitle.text = data["name"]
	$Blur/CentralDescription.text = data["description"]

func update_main_number() -> void:
	if selected_id == "" or not numbers.has(selected_id):
		return
	main_number.text = numbers[selected_id].text
	$MainNumber/MainNumberContainer.material.set_shader_parameter(
		"glow_color", stat_colors[selected_id]
	)

func _on_stat_bowl_selected(id: String) -> void:
	if id == "":
		return
	if id == selected_id:
		return
	selected_id = id
	$MainNumber.visible = true
	update_central_labels()

func _on_plus_minus_pressed(id: String):
	match id:
		"plus":
			main_number.text = str(int(main_number.text) + 1)
		"minus":
			main_number.text = str(int(main_number.text) - 1)
	update_selected_stat()
	pass

func update_selected_stat():
	numbers[selected_id].text = main_number.text
	pass

func check_sum():
	var power = int($SmallNumbers/Power.text)
	var agility = int($SmallNumbers/Agility.text)
	var intelligence = int($SmallNumbers/Intelligence.text)
	var luck = int($SmallNumbers/Luck.text)
	var sum = power + agility + intelligence + luck
	return sum

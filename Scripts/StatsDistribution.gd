extends Node2D
var max_start_points = 7
var remaining_points = 7

func _ready():
	var class_data = DataManager.get_class_data(TempData.class_id)
	var subclass_data = DataManager.get_subclass_data(TempData.subclass_id)
	$SublassSelected.text = "Выбранный вами подкласс: " + class_data["name"] + " - " + subclass_data["name"]
	$Stats/Strength/SpinBox.value = 0
	$Stats/Agility/SpinBox.value = 0
	$Stats/Intelligence/SpinBox.value = 0
	$Stats/Luck/SpinBox.value = 0
	update_ui()
	$Save.disabled = true

func update_ui():
	var total = sum_stats()
	remaining_points = max_start_points - total
	if remaining_points >= 0:
		$Stats/RemainingLabel.text = "Для создания стартового персонажа осталось " + str(int(remaining_points)) + " очков.\nВы можете создать персонажа сильнее или слабее стартового, если мастер разрешит."
	else:
		$Stats/RemainingLabel.text = "Ваш персонаж имеет на " + str(int(-remaining_points)) + " очков больше стартового.\nЭто нормально, если мастер разрешит."
	update_derived_stats()
	$Save.disabled = $Name/Entering.text == ""

func update_derived_stats():
	var strength = $Stats/Strength/SpinBox.value
	var agility = $Stats/Agility/SpinBox.value
	var intelligence = $Stats/Intelligence/SpinBox.value
	var luck = $Stats/Luck/SpinBox.value
	$Derivatives/Numbers/Health.text = str(int(40 + strength * 10))
	$Derivatives/Numbers/Melee.text = str(int(strength))
	$Derivatives/Numbers/LightMelee.text = str(int(agility))
	$Derivatives/Numbers/Range.text = str(int(agility))
	$Derivatives/Numbers/Magic.text = str(int(intelligence))
	$Derivatives/Numbers/Heal.text = str(int(intelligence))
	$Derivatives/Numbers/Defence.text = str(int(floor(strength/2)))
	$Derivatives/Numbers/DefencePierceing.text = str(int(floor(agility * 1.5)))
	$Derivatives/Numbers/Move.text = str(int(floor(2 + agility/2)))
	$Derivatives/Numbers/Reroll.text = str(int(floor((luck + 1)/2)))
	$Derivatives/Numbers/RerollBonus.text = str(int(floor(luck/2)))
	$Derivatives/Numbers/ActiveSlots.text = str(int(3 + intelligence))
	pass

func sum_stats() -> int:
	return $Stats/Strength/SpinBox.value + $Stats/Agility/SpinBox.value + $Stats/Intelligence/SpinBox.value + $Stats/Luck/SpinBox.value

func _on_spin_value_changed(_value):
	update_ui()

func _on_entering_text_changed(_new_text: String) -> void:
	update_ui()

func _on_back_pressed() -> void:
	var class_id = TempData.class_id
	match class_id:
		"warrior":
			get_tree().change_scene_to_file("res://Scenes/WarriorSubclassSelect.tscn")
		"rogue":
			get_tree().change_scene_to_file("res://Scenes/RogueSubclassSelect.tscn")
		"mage":
			get_tree().change_scene_to_file("res://Scenes/MageSubclassSelect.tscn")

func ask_for_stats():
	pass

func _on_save_pressed() -> void:
	if remaining_points != 0:
		ask_for_stats()
		return
	if $Name/Entering.text != "":
		TempData.character_name = $Name/Entering.text
		TempData.stats = {
			"strength": $Stats/Strength/SpinBox.value,
			"dexterity": $Stats/Agility/SpinBox.value,
			"intelligence": $Stats/Intelligence/SpinBox.value,
			"luck": $Stats/Luck/SpinBox.value
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
		get_tree().change_scene_to_file("res://Scenes/CharacterList.tscn")
	
	pass

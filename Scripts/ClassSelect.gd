extends Control

var selected_class_id = ""

func _ready():
	TempData.reset()
	# Деактивируем кнопку "Далее" изначально
	$Next.disabled = true
	# Убираем описание
	$DescriptionLabel.text = ""

func _on_warrior_button_pressed():
	select_class("warrior")

func _on_rogue_button_pressed():
	select_class("rogue")

func _on_mage_button_pressed():
	select_class("mage")

func select_class(class_id: String):
	selected_class_id = class_id
	var class_data = DataManager.get_class_data(class_id)
	if class_data:
		$DescriptionLabel.text = class_data["description"]
		TempData.class_id = class_id
		$Next.disabled = false
		# Можно подсветить выбранную кнопку (например, изменить цвет)
		highlight_button(class_id)

func highlight_button(class_id: String):
	# Сбросить цвет всех кнопок
	$WarriorButton.modulate = Color.WHITE
	$RogueButton.modulate = Color.WHITE
	$MageButton.modulate = Color.WHITE
	# Подсветить выбранную
	match class_id:
		"warrior": $WarriorButton.modulate = Color.YELLOW
		"rogue": $RogueButton.modulate = Color.YELLOW
		"mage": $MageButton.modulate = Color.YELLOW


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/CharacterList.tscn")


func _on_next_pressed() -> void:
	match selected_class_id:
		"warrior":
			get_tree().change_scene_to_file("res://Scenes/WarriorSubclassSelect.tscn")
		"rogue":
			get_tree().change_scene_to_file("res://Scenes/RogueSubclassSelect.tscn")
		"mage":
			get_tree().change_scene_to_file("res://Scenes/MageSubclassSelect.tscn")

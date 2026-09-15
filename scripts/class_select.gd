extends Control

var selected_class_id = ""

func _ready():
	TempData.reset()
	# Деактивируем кнопку "Далее" изначально
	$Next.disabled = true
	# Убираем описание
	$Blur/DescriptionLabel.text = ""

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
		$Blur/DescriptionLabel.text = class_data["description"]
		TempData.class_id = class_id
		$Next.disabled = false

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/character_list.tscn")


func _on_next_pressed() -> void:
	match selected_class_id:
		"warrior":
			get_tree().change_scene_to_file("res://scenes/warrior_subclass_select.tscn")
		"rogue":
			get_tree().change_scene_to_file("res://scenes/rogue_subclass_select.tscn")
		"mage":
			get_tree().change_scene_to_file("res://scenes/mage_subclass_select.tscn")

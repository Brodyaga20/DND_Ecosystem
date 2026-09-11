extends Control

var selected_subclass_id = ""
const selected_class_id = "rogue"

func _ready():
	$Next.disabled = true
	$Blur/DescriptionLabel.text = ""

func _on_sharpshooter_button_pressed():
	select_subclass("sharpshooter")

func _on_killer_button_pressed():
	select_subclass("killer")

func _on_trapper_button_pressed():
	select_subclass("trapper")

func _on_duelist_button_pressed():
	select_subclass("duelist")

func select_subclass(subclass_id: String):
	selected_subclass_id = subclass_id
	var subclass_data = DataManager.get_subclass_data(subclass_id)
	if subclass_data:
		$Blur/DescriptionLabel.text = subclass_data["description"]
		TempData.subclass_id = subclass_id
		$Next.disabled = false
		# Можно подсветить выбранную кнопку (например, изменить цвет)



func _on_next_button_pressed():
	if selected_subclass_id != "":
		get_tree().change_scene_to_file("res://Scenes/StatsDistribution.tscn")
		UnlockManager.unlock_class(selected_class_id)
		UnlockManager.unlock_subclass(selected_subclass_id)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ClassSelect.tscn")

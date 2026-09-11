extends Control

var selected_subclass_id = ""
const selected_class_id = "warrior"

func _ready():
	$Next.disabled = true
	$Blur/DescriptionLabel.text = ""

func _on_paladin_button_pressed():
	select_subclass("paladin")

func _on_knight_button_pressed():
	select_subclass("knight")

func _on_berserker_button_pressed():
	select_subclass("berserker")

func _on_captain_button_pressed():
	select_subclass("captain")

func select_subclass(subclass_id: String):
	selected_subclass_id = subclass_id
	var class_data = DataManager.get_subclass_data(subclass_id)
	if class_data:
		$Blur/DescriptionLabel.text = class_data["description"]
		TempData.subclass_id = subclass_id
		$Next.disabled = false



func _on_next_button_pressed():
	if selected_subclass_id != "":
		get_tree().change_scene_to_file("res://Scenes/StatsDistribution.tscn")
		UnlockManager.unlock_class(selected_class_id)
		UnlockManager.unlock_subclass(selected_subclass_id)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ClassSelect.tscn")

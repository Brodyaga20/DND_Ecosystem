extends Control

var selected_subclass_id = ""
const selected_class_id = "mage"

func _ready():
	$Next.disabled = true
	$DescriptionLabel.text = ""

func _on_necromancer_button_pressed():
	select_subclass("necromancer")

func _on_elementalist_button_pressed():
	select_subclass("elementalist")

func _on_mentalist_button_pressed():
	select_subclass("mentalist")

func _on_spiritualist_button_pressed():
	select_subclass("spiritualist")

func select_subclass(subclass_id: String):
	selected_subclass_id = subclass_id
	var class_data = DataManager.get_subclass_data(subclass_id)
	if class_data:
		$DescriptionLabel.text = class_data["description"]
		TempData.subclass_id = subclass_id
		$Next.disabled = false
		# Можно подсветить выбранную кнопку (например, изменить цвет)
		highlight_button(subclass_id)

func highlight_button(class_id: String):
	# Сбросить цвет всех кнопок
	$NecromancerButton.modulate = Color.WHITE
	$ElementalistButton.modulate = Color.WHITE
	$MentalistButton.modulate = Color.WHITE
	$SpiritualistButton.modulate = Color.WHITE
	# Подсветить выбранную
	match class_id:
		"necromancer": $NecromancerButton.modulate = Color.YELLOW
		"elementalist": $ElementalistButton.modulate = Color.YELLOW
		"mentalist": $MentalistButton.modulate = Color.YELLOW
		"spiritualist": $SpiritualistButton.modulate = Color.YELLOW



func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/ClassSelect.tscn")


func _on_next_pressed() -> void:
	if selected_subclass_id != "":
		get_tree().change_scene_to_file("res://Scenes/StatsDistribution.tscn")
		UnlockManager.unlock_class(selected_class_id)
		UnlockManager.unlock_subclass(selected_subclass_id)

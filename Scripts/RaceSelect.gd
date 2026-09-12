extends Control

var subclass = ""
var wayback = ""
var selected_race_id = ""

func _ready():
	subclass = TempData.subclass_id
	if subclass == "mage":
		wayback = "res://Scenes/MageSubclassSelect.tscn"
	elif subclass == "assasin":
		wayback = "res://Scenes/RogueSubclassSelect.tscn"
	else:
		wayback = "res://Scenes/WarriorSubclassSelect.tscn"
	TempData.reset()  # сброс временных данных
	$Next.disabled = true
	$Blur/NameLabel.text = ""
	$Blur/DescriptionLabel.text = ""


	

func _on_gnome_button_pressed() -> void:
	select_race("gnome")

func _on_chitin_button_pressed():
	select_race("chitin")

func _on_human_button_pressed() -> void:
	select_race("human")

func _on_aarakokra_button_pressed() -> void:
	select_race("aarakocra")

func _on_giant_button_pressed() -> void:
	select_race("giant")

func _on_aasimar_button_pressed() -> void:
	select_race("aasimar")

func _on_owlin_button_pressed() -> void:
	select_race("owlin")

func _on_drow_button_pressed() -> void:
	select_race("drow")

func select_race(race_id: String):
	selected_race_id = race_id
	TempData.race_id = race_id
	var race_data = DataManager.get_race_data(race_id)
	if race_data:
		$Blur/NameLabel.text = race_data["name"]
		$Blur/DescriptionLabel.text = race_data["description"]
		$Next.disabled = false

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(wayback)
	pass # Replace with function body.


func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/SexSelect.tscn")
	pass # Replace with function body.

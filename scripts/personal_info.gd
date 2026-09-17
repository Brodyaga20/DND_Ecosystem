extends Node2D


func _ready():
	$Age/AdditionalAgeInfo.visible = false
	$Age/AdditionalAgeInfo/AgeRange.text = ""

func _on_young_pressed() -> void:
	set_ages("young")

func _on_mature_pressed() -> void:
	set_ages("mature")

func _on_old_pressed() -> void:
	set_ages("old")

func _on_ancient_pressed() -> void:
	set_ages("ancient")

func set_ages(period: String):
	var min_age = TempData.race_ages[period][0]
	var max_age = TempData.race_ages[period][1]
	var text = "Для выбранной расы это от " + str(min_age) + " до " + str(max_age) + " лет"
	$Age/AdditionalAgeInfo/AgeRange.text = text
	$Age/AdditionalAgeInfo.visible = true

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sex_select.tscn")

extends Node2D

func _ready():
	# Можно добавить приветствие или музыку
	pass

func _on_play_button_pressed():
	# Переход к списку персонажей
	get_tree().change_scene_to_file("res://Scenes/CharacterList.tscn")

func _on_guide_button_pressed() -> void:
		# Переход к справочнику
	get_tree().change_scene_to_file("res://Scenes/GuideBook.tscn")


func _on_button_pressed() -> void:
	UnlockManager.lock_everything()

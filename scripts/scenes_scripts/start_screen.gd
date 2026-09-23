extends Control

func _ready():
	# Можно добавить приветствие или музыку
	pass

func _on_play_button_pressed():
	# Переход к списку персонажей
	get_tree().change_scene_to_file("res://scenes/characters_list.tscn")

func _on_guide_button_pressed() -> void:
		# Переход к справочнику
	get_tree().change_scene_to_file("res://scenes/guide_book.tscn")


func _on_button_pressed() -> void:
	UnlockManager.lock_everything()


func _on_exit_pressed() -> void:
	exit()

func exit():
	get_tree().quit()

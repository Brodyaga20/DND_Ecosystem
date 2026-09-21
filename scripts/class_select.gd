extends Control

var selected_class_id = ""
@onready var sprites_root = $Sprites
func _ready():
	TempData.reset()
	# Деактивируем кнопку "Далее" изначально
	$Next.disabled = true
	# Убираем описание
	$Blur/DescriptionLabel.text = ""
	$Blur/NameLabel.text = ""
	for sprite in sprites_root.get_children():
		if sprite is GlowElement:
			sprite.id_selected.connect(_on_class_selected)

func _on_class_selected(id: String):
	if id == "":
		return
	if id == selected_class_id:
		return
	selected_class_id = id
	print(selected_class_id)
	$Next.disabled = false
	update_labels()
	pass

func update_labels():
	$Blur/NameLabel.text = DataManager.get_class_name_from_id(selected_class_id)
	$Blur/DescriptionLabel.text = DataManager.get_class_description_from_id(selected_class_id)
	pass

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
	get_tree().change_scene_to_file("res://scenes/race_select.tscn")

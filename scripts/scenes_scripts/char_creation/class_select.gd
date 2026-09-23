extends Control

var selected_class_id = ""
@onready var sprites_root = $Sprites
func _ready():
	TempData.reset()
	$Next.disabled = true
	$Blur/DescriptionLabel.text = ""
	$Blur/NameLabel.text = ""
	for sprite in sprites_root.get_children():
		if sprite is GlowElement:
			sprite.id_selected.connect(_on_class_selected)

func _on_class_selected(id: String, is_selected: bool):
	if id == "":
		return
	if id == selected_class_id:
		return
	selected_class_id = id
	$Next.disabled = false
	update_labels()
	pass

func update_labels():
	var cls: CharacterClassData = DataManager.character_classes.get_by_id(selected_class_id)
	$Blur/NameLabel.text = cls.display_name
	$Blur/DescriptionLabel.text = cls.short_description

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/characters_list.tscn")
	TempData.reset()

func _on_next_pressed() -> void:
	TempData.char_data.class_id = selected_class_id
	get_tree().change_scene_to_file("res://scenes/race_select.tscn")

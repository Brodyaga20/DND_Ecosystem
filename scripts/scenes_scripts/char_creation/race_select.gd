extends Node2D


var single_race_id := ""
var mixed_race_ids: Array[StringName] = []
var custom_race_name := ""
@onready var sprites_root = $Sprites

enum RaceModes {SINGLE, MIXED, CUSTOM}

var mode := RaceModes.SINGLE

func _ready():
	$NewRaceScreen.visible = false
	$Next.disabled = true
	$Blur/NameLabel.text = ""
	$Blur/DescriptionLabel.text = ""
	for sprite in sprites_root.get_children():
		if sprite is GlowElement:
			sprite.id_selected.connect(_on_race_selected)

func _on_race_selected(id: String, is_selected: bool) -> void:
	match mode:
		RaceModes.SINGLE:
			single_race_id = id
		RaceModes.MIXED:
			if is_selected:
				mixed_race_ids.append(id)
			else:
				mixed_race_ids.erase(id)
	var race = DataManager.races.get_by_id(id)
	update_text(race)
	enable_transition()

func enable_transition() -> void:
	$Next.disabled = false

func disable_transition() -> void:
	$Next.disabled = true

func update_text(race):
	match mode:
		RaceModes.SINGLE:
			$Blur/NameLabel.text = race.display_name
			$Blur/DescriptionLabel.text = race.description
		RaceModes.MIXED:
			$Blur/NameLabel.text = "Потомок нескольких рас"
			$Blur/DescriptionLabel.text = "Удивительные существа, которые могут быть наделены совершенно разнообразными и нестандартными качествами и навыками."

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/class_select.tscn")

func _on_next_pressed() -> void:
	go_to_next_page()

func _on_mixed_blood_pressed() -> void:
	match mode:
		RaceModes.SINGLE:
			set_mixed_blood_mode()
		RaceModes.MIXED:
			set_single_mode()

func set_mixed_blood_mode():
	mode = RaceModes.MIXED
	update_labels()
	for sprite in sprites_root.get_children():
		if sprite is GlowElement:
			sprite.selection_mode = sprite.SelectionMode.TOGGLE
			sprite.set_selected(false)

func set_single_mode():
	mode = RaceModes.SINGLE
	update_labels()
	for sprite in sprites_root.get_children():
		if sprite is GlowElement:
			sprite.selection_mode = sprite.SelectionMode.RADIO
			sprite.set_selected(false)

func update_labels():
	match mode:
		RaceModes.SINGLE:
			$Blur/NameLabel.text = ""
			$Blur/Label.text = "Выберите расу персонажа.\nРаса определяет отыгрыш, социальные\nвзаимодействия и ваше место в мире"
			$Blur/DescriptionLabel.text = ""
		RaceModes.MIXED:
			$Blur/NameLabel.text = ""
			$Blur/Label.text = "Выберите несколько рас"
			$Blur/DescriptionLabel.text = ""

func _on_new_race_pressed() -> void:
	open_new_race_dialog()

func open_new_race_dialog() -> void:
	mode = RaceModes.CUSTOM
	$NewRaceScreen.visible = true

func close_new_race_dialog():
	$NewRaceScreen.visible = false
	$Next.disabled = true

func _on_no_pressed() -> void:
	close_new_race_dialog()

func _on_yes_pressed() -> void:
	custom_race_name = $NewRaceScreen/NewRaceNameEdit.text
	go_to_next_page()

func save_parents():
	match mode:
		RaceModes.SINGLE:
			TempData.char_data.race.kind = RaceRef.Kind.SINGLE
			TempData.char_data.race.race_id = single_race_id
		RaceModes.MIXED:
			TempData.char_data.race.kind = RaceRef.Kind.MIXED
			TempData.char_data.race.mixed_ids = mixed_race_ids
		RaceModes.CUSTOM:
			TempData.char_data.race.kind = RaceRef.Kind.CUSTOM
			TempData.char_data.race.custom_name = custom_race_name

func go_to_next_page():
	save_parents()
	get_tree().change_scene_to_file("res://scenes/sex_select.tscn")

extends Node2D

var age_period = null
var _old_text: String = ""

func _ready():
	$Age/AdditionalAgeInfo.visible = false
	$Age/AdditionalAgeInfo/AgeRange.text = ""
	$Next.disabled = true

func _on_young_pressed() -> void:
	set_ages("young")

func _on_mature_pressed() -> void:
	set_ages("mature")

func _on_old_pressed() -> void:
	set_ages("old")

func _on_ancient_pressed() -> void:
	set_ages("ancient")

func set_ages(period: String):
	enable_next_button_if_legit()
	age_period = period
	$Age/AdditionalAgeInfo/ExactAgeEdit.placeholder_text = DataManager.get_name_from_age_period_id(period)
	var min_age = TempData.race_ages[period][0]
	var max_age = TempData.race_ages[period][1]
	var text = "Для выбранной расы это от " + str(min_age) + " до " + str(max_age) + " лет"
	$Age/AdditionalAgeInfo/AgeRange.text = text
	$Age/AdditionalAgeInfo.visible = true

func enable_next_button_if_legit():
	if $NameEdit.text != "" and age_period != null:
		$Next.disabled = false
	else:
		$Next.disabled = true

func _on_name_edit_text_changed(_new_text: String) -> void:
	enable_next_button_if_legit()
	pass # Replace with function body.

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sex_select.tscn")

func _on_next_pressed() -> void:
	save_data_to_temp()
	get_tree().change_scene_to_file("res://scenes/stats_distribution.tscn")
	pass # Replace with function body.

func save_data_to_temp():
	var age
	var character_name = $NameEdit.text
	var history = $History/HistoryEdit.text
	var traits = $Traits/TraitsEdit.text
	var goal = $Goal/GoalEdit.text
	var secret = $Secret/SecretEdit.text
	if $Age/AdditionalAgeInfo/ExactAgeEdit.text == "" or int($Age/AdditionalAgeInfo/ExactAgeEdit.text) < 12:
		age = DataManager.get_name_from_age_period_id(age_period)
	else:
		age = int($Age/AdditionalAgeInfo/ExactAgeEdit.text)
	TempData.age = age
	TempData.character_name = character_name
	TempData.history = history
	TempData.traits = traits
	TempData.goal = goal
	TempData.secret = secret
	pass

func _on_exact_age_edit_text_changed(new_text: String) -> void:
	var text = $Age/AdditionalAgeInfo/ExactAgeEdit.text
	# Если текст пустой или является допустимым целым числом
	if new_text.is_empty() or new_text.is_valid_int():
		_old_text = new_text
	else:
		# Возвращаем предыдущее корректное значение
		$Age/AdditionalAgeInfo/ExactAgeEdit.text = _old_text
		# Перемещаем курсор в конец
		$Age/AdditionalAgeInfo/ExactAgeEdit.caret_column = text.length()

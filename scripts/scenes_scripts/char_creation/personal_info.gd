extends Node2D

var age_period = null
var _old_text: String = ""

func _ready():
	$Age/AdditionalAgeInfo.visible = false
	$Age/AdditionalAgeInfo/AgeRange.text = ""
	$Next.disabled = true

func _on_young_pressed() -> void:
	set_ages_text("young")

func _on_mature_pressed() -> void:
	set_ages_text("mature")

func _on_old_pressed() -> void:
	set_ages_text("old")

func _on_ancient_pressed() -> void:
	set_ages_text("ancient")

func set_ages_text(period: String):
	enable_next_button_if_legit()
	age_period = period
	var arr = [0, 0]
	var race_kind = TempData.char_data.race.kind
	var text := ""
	var min_age : int = 0 
	var max_age : int = 0 
	match race_kind:
		RaceRef.Kind.SINGLE:
			arr = DataManager.races.get_by_id(TempData.char_data.race.race_id).get_lifespan_range(period)
			min_age = arr[0]
			max_age = arr[1]
			text = "Для выбранной расы это от " + str(min_age) + " до " + str(max_age) + " лет"
		RaceRef.Kind.MIXED:
			for i in TempData.char_data.race.mixed_ids:
				for j in range(2):
					arr[j] += DataManager.races.get_by_id(i).get_lifespan_range(period)[j]
			for j in range(2):
				arr[j] = int(arr[j]/(TempData.char_data.race.mixed_ids.size()))
			min_age = arr[0]
			max_age = arr[1]
			text = "Для комбинации рас это от " + str(min_age) + " до " + str(max_age) + " лет"
	$Age/AdditionalAgeInfo/ExactAgeEdit.placeholder_text = DataManager.age_periods.get_name(period)
	$Age/AdditionalAgeInfo/AgeRange.text = text
	$Age/AdditionalAgeInfo.visible = true

func enable_next_button_if_legit():
	if $NameEdit.text != "" and age_period != null:
		$Next.disabled = false
	else:
		$Next.disabled = true

func _on_name_edit_text_changed(_new_text: String) -> void:
	enable_next_button_if_legit()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sex_select.tscn")

func _on_next_pressed() -> void:
	save_data_to_temp()
	get_tree().change_scene_to_file("res://scenes/stats_distribution.tscn")

func save_data_to_temp():
	var age:AgeValue= AgeValue.new()
	var character_name = $NameEdit.text
	var backstory = $History/HistoryEdit.text
	var traits = $Traits/TraitsEdit.text
	var life_goal = $Goal/GoalEdit.text
	var secret = $Secret/SecretEdit.text
	if $Age/AdditionalAgeInfo/ExactAgeEdit.text == "":
		age.kind = AgeValue.Kind.DESCRIPTOR
		age = AgeValue.descriptor(DataManager.age_periods.get_name(age_period))
	else:
		var exact_age := int($Age/AdditionalAgeInfo/ExactAgeEdit.text)
		age.kind = AgeValue.Kind.NUMERIC
		age = AgeValue.numeric(exact_age)
	TempData.char_data.character_name = character_name
	TempData.char_data.personal.backstory = backstory
	TempData.char_data.personal.traits = traits
	TempData.char_data.personal.life_goal = life_goal
	TempData.char_data.personal.secret = secret

func _on_exact_age_edit_text_changed(new_text: String) -> void:
	validate_change(new_text)

func validate_change(new_text: String):
	var text = $Age/AdditionalAgeInfo/ExactAgeEdit.text
	if new_text.is_empty() or new_text.is_valid_int():
		_old_text = new_text
	else:
		$Age/AdditionalAgeInfo/ExactAgeEdit.text = _old_text
		$Age/AdditionalAgeInfo/ExactAgeEdit.caret_column = text.length()

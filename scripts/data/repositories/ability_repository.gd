class_name AbilityRepository
extends Repository

func _make_item(raw: Dictionary, fallback_id: StringName):
	return AbilityData.from_dict(raw, fallback_id)

class_name RacesRepository
extends Repository

func _make_item(raw: Dictionary, fallback_id: StringName):
	return RaceData.from_dict(raw, fallback_id)

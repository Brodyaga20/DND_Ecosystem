# character_class_repository.gd
class_name StatsRepository
extends Repository

func _make_item(raw: Dictionary, fallback_id: StringName):
	return StatData.from_dict(raw, fallback_id)

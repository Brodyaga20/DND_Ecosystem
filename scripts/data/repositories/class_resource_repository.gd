# character_class_repository.gd
class_name ClassResourceRepository
extends Repository

func _make_item(raw: Dictionary, fallback_id: StringName):
	return ClassResourceData.from_dict(raw, fallback_id)

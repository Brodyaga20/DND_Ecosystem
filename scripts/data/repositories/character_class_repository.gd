# character_class_repository.gd
class_name CharacterClassRepository
extends Repository

func _make_item(raw: Dictionary, fallback_id: StringName):
	return CharacterClassData.from_dict(raw, fallback_id)

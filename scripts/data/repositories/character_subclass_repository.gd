# character_class_repository.gd
class_name CharacterSubclassRepository
extends Repository

func _make_item(raw: Dictionary, fallback_id: StringName):
	return CharacterSubclassData.from_dict(raw, fallback_id)

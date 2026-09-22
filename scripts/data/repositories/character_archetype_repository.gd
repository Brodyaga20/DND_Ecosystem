class_name CharacterArchetypeRepository
extends Repository

func _make_item(raw: Dictionary, fallback_id: StringName):
	return CharacterArchetypeData.from_dict(raw, fallback_id)

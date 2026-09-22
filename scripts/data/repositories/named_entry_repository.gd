# named_entry_repository.gd
class_name NamedEntryRepository
extends Repository

func _make_item(raw: Dictionary, fallback_id: StringName):
	return NamedEntryData.from_dict(raw, fallback_id)

func get_name(id: StringName) -> String:
	var e = get_by_id(id)
	return e.display_name if e else String(id)

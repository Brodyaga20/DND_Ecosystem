class_name Repository
extends RefCounted

var _by_id: Dictionary = {}       # StringName -> T
var _ordered: Array = []          # стабильный порядок

func load_from(path: String) -> void:
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		push_error("Cannot read " + path)
		return
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Invalid JSON: " + path)
		return
	_by_id.clear()
	_ordered.clear()
	for key in parsed:
		var raw: Dictionary = parsed[key]
		var item = _make_item(raw, StringName(key))
		if item == null:
			continue
		if _by_id.has(item.id):
			push_error("Duplicate id %s in %s" % [item.id, path])
			continue
		_by_id[item.id] = item
		_ordered.append(item)

# Переопределяется в наследниках
func _make_item(raw: Dictionary, fallback_id: StringName):
	return null

func get_by_id(id: StringName):
	return _by_id.get(id)

func has(id: StringName) -> bool:
	return _by_id.has(id)

func all() -> Array:
	return _ordered.duplicate()

func count() -> int:
	return _ordered.size()

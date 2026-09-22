# codex_provider.gd
class_name CodexProvider
extends RefCounted

func type() -> StringName:
	return &""

func make_key(id: StringName) -> StringName:
	return StringName("%s:%s" % [type(), id])

func entries() -> Array[CodexEntry]:
	return []

func make_entry(id: StringName) -> CodexEntry:
	return null

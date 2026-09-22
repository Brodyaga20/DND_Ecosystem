class_name ActiveEffect
extends RefCounted

var effect_id: StringName      # ссылка на EffectData
var source: String = ""        # "Забинтован союзником", "Проклятие мага"
var remaining: int = -1        # -1 = бесконечно, иначе — раунды/ходы
var stacks: int = 1
var notes: String = ""

func to_dict() -> Dictionary:
	return {
		"effect_id": String(effect_id),
		"source": source,
		"remaining": remaining,
		"stacks": stacks,
		"notes": notes,
	}

static func from_dict(raw: Dictionary) -> ActiveEffect:
	var e := ActiveEffect.new()
	e.effect_id = StringName(raw.get("effect_id", ""))
	e.source = raw.get("source", "")
	e.remaining = int(raw.get("remaining", -1))
	e.stacks = int(raw.get("stacks", 1))
	e.notes = raw.get("notes", "")
	return e

# class_resource_data.gd
class_name ClassResourceData
extends RefCounted

# --- Идентификация ---
var id: StringName = &""

# --- Тексты ---
var display_name: String = ""
var short_description: String = ""
var long_description: String = ""

# --- Тип модели данных ---
var model_type: StringName = &"int_range"

# --- Визуал ---
var visual_type: StringName = &"gradient"
var visual_direction: StringName = &"normal"
var visual_mode: StringName = &"max"

# --- Поведение ---
var behavior_id: StringName = &""

# --- Границы ---
var min_amount: int = 0
var max_amount: int = -1            # -1 = без максимума
var max_source: StringName = &""    # "" = статический max, иначе формула
var starting_amount: int = 0

# --- Сброс ---
var reset_trigger: StringName = &"never"
var reset_to: Variant = 0           # int | "max" | "starting"

# --- Параметры поведения ---
var params: Dictionary = {}

# --- Удобные флаги ---

func has_max() -> bool:
	return max_amount >= 0 or max_source != &""

func is_static_max() -> bool:
	return max_source == &""

func has_reset() -> bool:
	return reset_trigger != &"never"

# --- Парсинг ---

static func from_dict(raw: Dictionary, fallback_id: StringName = &"") -> ClassResourceData:
	var d := ClassResourceData.new()

	d.id = StringName(raw.get("id", fallback_id))
	d.display_name = raw.get("name", "")
	d.short_description = raw.get("short_description", "")
	d.long_description = raw.get("long_description", "")

	d.model_type = StringName(raw.get("model_type", "int_range"))
	d.behavior_id = StringName(raw.get("behavior_id", ""))

	var visual: Dictionary = raw.get("visual", {})
	d.visual_type = StringName(visual.get("type", "gradient"))
	d.visual_direction = StringName(visual.get("direction", "normal"))
	d.visual_mode = StringName(visual.get("mode", "max"))

	d.min_amount = int(raw.get("min", 0))
	d.max_amount = int(raw.get("max", -1))
	d.max_source = StringName(raw.get("max_source", ""))
	d.starting_amount = int(raw.get("starting", 0))

	var reset: Dictionary = raw.get("reset", {})
	d.reset_trigger = StringName(reset.get("trigger", "never"))
	d.reset_to = reset.get("to", 0)

	d.params = raw.get("params", {}).duplicate(true)

	_validate(d, raw)
	return d

static func _validate(d: ClassResourceData, raw: Dictionary) -> void:
	if d.id == &"":
		push_error("ClassResourceData without id: %s" % raw)
	if d.min_amount > 0 and d.max_amount >= 0 and d.min_amount > d.max_amount:
		push_error("Resource %s: min > max (%d > %d)" % [d.id, d.min_amount, d.max_amount])
	if d.starting_amount < d.min_amount:
		push_warning("Resource %s: starting < min" % d.id)
	if d.max_amount >= 0 and d.starting_amount > d.max_amount:
		push_warning("Resource %s: starting > max" % d.id)
	if d.reset_trigger != &"never" and not raw.get("reset", {}).has("to"):
		push_warning("Resource %s: reset without 'to', will default to 0" % d.id)

# --- Отладочный вывод ---

func _to_string() -> String:
	return "ClassResourceData(%s, %s, min=%d, max=%d)" % [
		id, model_type, min_amount, max_amount
	]

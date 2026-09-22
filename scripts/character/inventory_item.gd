class_name InventoryItem
extends RefCounted

var item_id: StringName = &""
var quantity: int = 1
var notes: String = ""

func to_dict() -> Dictionary:
	return {
		"item_id": String(item_id),
		"quantity": quantity,
		"notes": notes,
	}

static func from_dict(raw: Dictionary) -> InventoryItem:
	var i := InventoryItem.new()
	i.item_id = StringName(raw.get("item_id", ""))
	i.quantity = int(raw.get("quantity", 1))
	i.notes = raw.get("notes", "")
	return i

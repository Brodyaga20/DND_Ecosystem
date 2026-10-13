# game_state.gd (Autoload)
extends Node

signal player_character_changed(character: PlayerData)
signal meta_changed

var player: PlayerData = null
var meta: MetaProfile

func _ready() -> void:
	update_meta_state()

# --- Управление игроком ---

func set_player_character(p: PlayerData) -> void:
	player = p
	player_character_changed.emit(p)

func clear_player_character() -> void:
	player = null
	player_character_changed.emit(null)

func update_meta_state() -> void:
	meta = SaveSystem.load_meta_profile()
	meta_changed.emit()

func save_meta() -> void:
	if meta != null:
		SaveSystem.save_meta_profile(meta)
		meta_changed.emit()

# --- Логика создания/удаления персонажей (Координация) ---

func get_character_count() -> int:
	if meta == null: return 0
	return meta.character_ids.size()

func can_create_character() -> bool:
	if meta == null: return false
	return meta.character_ids.size() < SaveSystem.MAX_CHARACTERS

func create_character(c: CharacterData) -> bool:
	if not can_create_character():
		push_warning("Достигнут лимит персонажей!")
		return false

	# 1. Сохраняем данные самого персонажа в отдельный файл
	if not SaveSystem.save_character_data(c):
		return false

	# 2. Обновляем мету в оперативной памяти
	meta.add_character_id(c.id)

	# 3. Сохраняем обновленную мету на диск
	SaveSystem.save_meta_profile(meta)
	
	# 4. Уведомляем UI об изменениях
	meta_changed.emit()
	return true

func delete_character(id: int) -> bool:
	# 1. Удаляем файл с данными персонажа
	if not SaveSystem.delete_character_data(id):
		return false

	# 2. Если удаляем текущего активного игрока, очищаем его состояние
	if player != null and player.id == id:
		clear_player_character()

	# 3. Обновляем мету в оперативной памяти
	meta.remove_character_id(id)

	# 4. Сохраняем обновленную мету на диск
	SaveSystem.save_meta_profile(meta)
	
	# 5. Уведомляем UI
	meta_changed.emit()
	return true

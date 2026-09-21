extends Node

var network_character = []

# Этот скрипт будет доступен на всех узлах

func _ready():
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


@rpc("any_peer", "call_local")
func send_my_character(char_data: Dictionary):
	if not multiplayer.is_server():
		return
	var sender = multiplayer.get_remote_sender_id()
	ServerData.players[sender] = char_data
	network_character.append(char_data)
	if multiplayer.is_server():
		var scene = get_tree().current_scene
		if scene and scene.name == "MasterList":
			if scene.has_method("update_grid"):
				scene.update_grid()
	update_characters_for_all.rpc(ServerData.players)

@rpc("call_local")

func update_characters_for_all(players_data: Dictionary):
	GameState.remote_characters = players_data
	var scene = get_tree().current_scene
	if scene and scene.name == "CharacterList":
		if scene.has_method("update_grid"):
			scene.update_grid()
	if scene and scene.name == "MasterList":
		if scene.has_method("update_grid"):
			scene.update_grid()
	elif scene and scene.name == "Profile":
		if scene.has_method("refresh_data"):
			scene.refresh_data()

@rpc("any_peer", "call_local")
func update_character(updated_char: Dictionary, target_peer: int):
	if not multiplayer.is_server():
		return
	# Обновляем в ServerData
	if ServerData.players.has(target_peer):
		ServerData.players[target_peer] = updated_char
		# Рассылаем всем клиентам
		update_characters_for_all.rpc(ServerData.players)
		# Обновляем сетку мастерской
		var scene = get_tree().current_scene
		if scene and scene.name == "MasterMode":
			if scene.has_method("update_grid"):
				scene.update_grid()

func _on_server_disconnected():
	GameState.is_connected_to_server = false
	GameState.remote_characters.clear()
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")

func _on_peer_disconnected(id):
	NetworkManager.network_character.clear()
	if multiplayer.is_server():
		if ServerData.players.has(id):
			ServerData.players.erase(id)
			# Рассылаем обновлённый список всем
			NetworkManager.update_characters_for_all.rpc(ServerData.players)
			NetworkManager.update_character.rpc(ServerData.players, 1)

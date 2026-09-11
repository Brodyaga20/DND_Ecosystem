extends Control

var peer = ENetMultiplayerPeer.new()

func _ready():
	print("im here")
	# Подключаем сетевые сигналы
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connected_to_server.connect(_on_client_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _on_host_pressed():
	# === МАСТЕР: запускаем сервер ===
	var error = peer.create_server(4242, 4)
	if error != OK:
		return
	multiplayer.multiplayer_peer = peer
	
	GameState.master_mode = true
	ServerData.players.clear()  # очищаем старых игроков
	
	# Переходим в мастерскую
	get_tree().change_scene_to_file("res://Scenes/MasterList.tscn")

func _on_connect_pressed():
	# === КЛИЕНТ: подключаемся ===
	print("try to connect")
	var ip = $IPLineEdit.text
	if ip == "":
		ip = "127.0.0.1"
	var error = peer.create_client(ip, 4242)
	if error != OK:
		print("no connect")
		return
	multiplayer.multiplayer_peer = peer

# ---- СИГНАЛЫ ПОДКЛЮЧЕНИЯ ----

func _on_client_connected():
	# Клиент успешно подключился
	GameState.is_connected_to_server = true
	# Далее отправка персонажа
	var char_id = GameState.current_character_id
	var char_data = GameManager.get_character(char_id)
	if char_data:
		if not char_data.get("locked", false):
			char_data["locked"] = true
			GameManager.save_characters()
	NetworkManager.send_my_character.rpc_id(1, char_data)
	get_tree().change_scene_to_file("res://Scenes/CharacterList.tscn")



func _on_peer_connected(_id):
	if not multiplayer or not multiplayer.is_server():
		return




func _on_connection_failed():
	multiplayer.multiplayer_peer = null



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/CharacterList.tscn")
	pass # Replace with function body.

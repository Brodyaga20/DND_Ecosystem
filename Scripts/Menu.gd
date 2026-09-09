extends Node

var peer = ENetMultiplayerPeer.new()
var is_server = false

func _ready():
	# Сигналы для отслеживания подключений
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

# Пример: отправляем выбор архетипа всем игрокам (вызывается на клиенте)
func send_archetype_choice(archetype_name: String):
	if not is_server:
		# Клиент отправляет запрос на сервер
		rpc_id(1, "_server_receive_archetype", archetype_name)
	else:
		# Если сервер сам выбирает, просто вызываем свою функцию
		_update_archetype(archetype_name)

# ======== ПРИЁМ ДАННЫХ (RPC) ========

@rpc("any_peer", "call_local")
func _server_receive_archetype(archetype_name: String):
	if is_server:
		var caller_id = multiplayer.get_remote_sender_id()
		print("Получен архетип от клиента ", caller_id, ": ", archetype_name)
		# Здесь можно сохранить в БД и разослать подтверждение всем
		_update_archetype.rpc(archetype_name, caller_id)

@rpc("call_local")
func _update_archetype(archetype_name: String, target_id: int = 0):
	# Эта функция вызывается на всех клиентах (и сервере) для обновления UI
	print("Обновление архетипа для ", target_id, " -> ", archetype_name)
	# Здесь обновляешь интерфейс у конкретного игрока или всех
	# target_id = 0 означает "все"
	if target_id == 0 or multiplayer.get_unique_id() == target_id:
		# Например, меняем текст на экране
		$SendData.text = "Архетип выбран: " + archetype_name

# ======== ОБРАБОТЧИКИ ПОДКЛЮЧЕНИЙ ========

func _on_peer_connected(id: int):
	print("Игрок ", id, " подключился")
	if is_server:
		# Сервер может разослать текущие данные новичку
		pass

func _on_peer_disconnected(id: int):
	print("Игрок ", id, " отключился")


func _on_host_button_down() -> void:
	peer.create_server(4242, 4)  # порт 4242, максимум 4 игрока
	multiplayer.multiplayer_peer = peer
	is_server = true
	$Label.text = "Сервер запущен"
	print("Сервер запущен на порту 4242")




func _on_connect_pressed() -> void:
	var ip = $LineEdit.text
	if ip == "":
		ip = "127.0.0.1"
	peer.create_client(ip, 4242)
	multiplayer.multiplayer_peer = peer
	$Label.text = "Подключение к " + ip


func _on_send_data_pressed() -> void:
	send_archetype_choice("Guardian Angel")

extends Node

const PORT:int = 4433
var paused:bool = true
var is_multiplayer:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Start paused.
	get_tree().paused = paused
	# You can save bandwidth by disabling server relay and peer notifications.
	multiplayer.server_relay = false

	# Automatically start the server in headless mode.
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server.")
		_on_host_pressed.call_deferred()
	
	#multiplayer.peer_disconnected.connect(_on_disconnection)
	multiplayer.server_disconnected.connect(_on_disconnection)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connection_successful)


func _on_host_pressed() -> void:
	# Start as server.
	host_game()


func _on_connect_pressed() -> void:
	join_game()


func _on_singleplayer_pressed() -> void:
	start_game()


func _on_disconnection():
	print("Disconnected!")
	%MainUI.visible = true


func _on_connection_failed():
	_on_disconnection()


func _on_connection_successful():
	print("Connection Successful")


func host_game(port:int=PORT):
	print("Pressed host")
	is_multiplayer = true
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	print("Server Hosted")
	start_game()


func join_game(port:int=PORT):
	# Start as client.
	is_multiplayer = true
	print("Pressed connect")
	var ip_address : String = %Remote.text
	if ip_address == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, port)
	print("Connection Status :", peer.get_connection_status())
	print("CONNECTED: ", ENetMultiplayerPeer.ConnectionStatus.CONNECTION_CONNECTED)
	print("CONNECTING: ", ENetMultiplayerPeer.ConnectionStatus.CONNECTION_CONNECTING)
	print("DISCONNECTED: ", ENetMultiplayerPeer.ConnectionStatus.CONNECTION_DISCONNECTED)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	print("Game Joined")
	start_game()


func start_game():
	# Hide the UI and unpause to start the game.
	%MainUI.hide()
	get_tree().paused = false
	paused = false
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server() or is_multiplayer == false:
		change_level.call_deferred(load("res://level.tscn"))


func change_level(scene: PackedScene):
	# Remove old level if any.
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	if scene != null:
		level.add_child(scene.instantiate())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		print("Game Menu action pressed")
		paused = !paused
		%GameMenuUI.visible = paused
		get_tree().paused = paused


func _on_quit_level_button_pressed() -> void:
	change_level(null)
	%MainUI.visible = true
	%GameMenuUI.visible = false
	paused = true
	is_multiplayer = false
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	get_tree().paused = true


func _on_resume_level_button_pressed() -> void:
	%GameMenuUI.visible = false
	paused = false
	get_tree().paused = paused

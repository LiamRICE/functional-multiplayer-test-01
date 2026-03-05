extends Node

const PORT:int = 4433
var paused:bool = true
var is_multiplayer:bool = false
var is_host:bool = false

# SteamLobby variables
var lobby_id:int = -1
var is_joining:bool = false

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
	
	print("Steam initialised: ", Steam.steamInit(480, true))
	Steam.initRelayNetworkAccess()
	Steam.lobby_created.connect(_on_steam_lobby_created)
	Steam.lobby_joined.connect(_on_steam_lobby_joined)


func _on_host_pressed() -> void:
	# Start as server.
	host_game()


func _on_connect_pressed() -> void:
	# Start as client.
	join_game()


func _on_singleplayer_pressed() -> void:
	start_game()


func _on_disconnection():
	print("Disconnected!")
	change_level(null)
	%UI.return_to_main_menu()
	paused = true
	is_multiplayer = false
	is_host = false
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	get_tree().paused = true


func _on_connection_failed():
	_on_disconnection()


func _on_connection_successful():
	print("Connection Successful")


func host_game(port:int=PORT):
	### LOCALHOST VERSION ###
	print("Initialising localhost... ")
	is_multiplayer = true
	is_host = true
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	print("Server Hosted")
	start_game()


func host_game_steam():
	### STEAMWORKS VERSION ###
	print("Initialising Steam lobby...")
	var max_players = int(%NumPlayersSpinBox.value)
	Steam.createLobby(Steam.LobbyType.LOBBY_TYPE_PUBLIC, max_players)
	is_multiplayer = true
	is_host = true


func join_game(port:int=PORT):
	### LOCALHOST VERSION ###
	# Start as client.
	is_multiplayer = true
	print("Initialising connection...")
	var ip_address : String = %Remote.text
	if ip_address == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	print("Game Joined")
	start_game()


func join_game_steam():
	### STEAMWORKS VERSION ###
	print("Initialising Steam Client connection...")
	is_joining = true
	var join_lobby_id:int = int(%Remote.text)
	Steam.joinLobby(join_lobby_id)


func start_game():
	# Hide the UI and unpause to start the game.
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
		%LobbyInfoLabel.text = str(self.lobby_id)
		%GameMenuUI.visible = paused
		get_tree().paused = paused


func _on_steam_lobby_created(result:int, new_lobby_id:int):
	if result == Steam.Result.RESULT_OK:
		self.lobby_id = new_lobby_id
		
		var peer := SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_host()
		
		multiplayer.multiplayer_peer = peer
		print("Steam Lobby Created with ID = ", new_lobby_id)
		start_game()
	else:
		print("Failed to initialise Steam Lobby.")


func _on_steam_lobby_joined(new_lobby_id:int, permissions:int, blocked:bool, result:int):
	if !is_joining:
		return
	
	if result == Steam.Result.RESULT_OK:
		self.lobby_id = new_lobby_id
		var peer := SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_client(Steam.getLobbyOwner(new_lobby_id))
		multiplayer.multiplayer_peer = peer
		is_joining = false
		print("Steam Lobby ", new_lobby_id, " Joined.")
		start_game()
	else:
		print("Failed to join Steam Lobby.")


func _on_quit_level_button_pressed() -> void:
	_on_disconnection()


func _on_resume_level_button_pressed() -> void:
	%GameMenuUI.visible = false
	paused = false
	get_tree().paused = paused


func _on_quit_game_button_pressed() -> void:
	print("Quit button pressed")
	get_tree().quit()


func get_steam_lobby_info() -> Dictionary:
	var lobby_info := {
		"lobby_id": self.lobby_id
	}
	return lobby_info

extends Control

var MainUI:CanvasLayer
var SettingsUI:CanvasLayer
var GameMenuUI:CanvasLayer
var CreateServerUI:CanvasLayer
var JoinServerUI:CanvasLayer
var GameplayUI:CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainUI = %MainUI
	SettingsUI = %SettingsUI
	GameMenuUI = %GameMenuUI
	CreateServerUI = %CreateServerUI
	JoinServerUI = %JoinServerUI
	GameplayUI = %GameplayUI
	return_to_main_menu()


func set_connect_options(steam_initialised:bool = false):
	# Set the server and join options to "Steam" and "LAN" if Steam is initialised, or just "LAN" if not
	var options:Array = []
	if steam_initialised:
		options.append("Steam")
	options.append("LAN")
	var i:int = 0
	for option in options:
		%CreateServerOptionButton.add_item(option)
		%CreateServerOptionButton.set_item_metadata(i, {"name":option})
		%JoinServerOptionButton.add_item(option)
		%JoinServerOptionButton.set_item_metadata(i, {"name":option})
		i += 1
	# Set default selected item
	if len(options) > 0:
		%CreateServerOptionButton.select(0)
		%JoinServerOptionButton.select(0)


func _on_settings_button_pressed() -> void:
	MainUI.visible = false
	SettingsUI.visible = true


func _on_confirm_button_pressed() -> void:
	MainUI.visible = true
	SettingsUI.visible = false


func _on_back_button_pressed() -> void:
	return_to_main_menu()


func _on_host_pressed() -> void:
	MainUI.visible = false
	CreateServerUI.visible = true


func _on_connect_pressed() -> void:
	MainUI.visible = false
	JoinServerUI.visible = true


func _on_start_server_button_pressed() -> void:
	CreateServerUI.visible = false
	GameplayUI.visible = true


func _on_join_server_button_pressed() -> void:
	JoinServerUI.visible = false
	GameplayUI.visible = true


func return_to_main_menu() -> void:
	MainUI.visible = true
	SettingsUI.visible = false
	GameMenuUI.visible = false
	CreateServerUI.visible = false
	JoinServerUI.visible = false
	GameplayUI.visible = false


func _on_singleplayer_pressed() -> void:
	MainUI.visible = false
	GameplayUI.visible = true

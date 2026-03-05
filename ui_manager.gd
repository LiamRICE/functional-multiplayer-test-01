extends Control

var MainUI:CanvasLayer
var SettingsUI:CanvasLayer
var GameMenuUI:CanvasLayer
var CreateServerUI:CanvasLayer
var JoinServerUI:CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainUI = %MainUI
	SettingsUI = %SettingsUI
	GameMenuUI = %GameMenuUI
	CreateServerUI = %CreateServerUI
	JoinServerUI = %JoinServerUI


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


func _on_join_server_button_pressed() -> void:
	JoinServerUI.visible = false


func return_to_main_menu() -> void:
	MainUI.visible = true
	SettingsUI.visible = false
	GameMenuUI.visible = false
	CreateServerUI.visible = false
	JoinServerUI.visible = false

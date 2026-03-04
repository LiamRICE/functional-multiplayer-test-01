extends Control

var MainUI:Control
var SettingsUI:Control
var GameMenuUI:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainUI = %MainUI
	SettingsUI = %SettingsUI
	GameMenuUI = %GameMenuUI


func _on_settings_button_pressed() -> void:
	MainUI.visible = false
	SettingsUI.visible = true


func _on_confirm_button_pressed() -> void:
	MainUI.visible = true
	SettingsUI.visible = false

extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func initialise_game_ui(player_name:String, player_max_health:float = 100):
	$BottomRightBar/Label.text = player_name
	$BottomRightBar/HealthBar.max_value = player_max_health
	$BottomRightBar/HealthBar.value = player_max_health


func update_healthbar(new_value:float):
	$BottomRightBar/HealthBar.value = new_value

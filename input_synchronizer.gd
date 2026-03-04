extends MultiplayerSynchronizer

@export var input_direction := {"move":Vector2.ZERO, "mouse":Vector2.ZERO}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_position = $"..".get_global_mouse_position()
	input_direction = {
		"move": Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"),
		"mouse": mouse_position
	}
	

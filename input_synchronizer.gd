extends MultiplayerSynchronizer

@export var input_direction := {"move":Vector2.ZERO, "mouse":Vector2.ZERO}
var BulletSpawn : Marker2D
var Player : CharacterBody2D
const BULLET_FORCE : float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	Player = $".."
	BulletSpawn = Player.get_node("BulletSpawn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_position = $"..".get_global_mouse_position()
	input_direction = {
		"move": Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"),
		"mouse": mouse_position
	}
	
	if Input.is_action_just_pressed("shoot"):
		var position = BulletSpawn.global_position
		var direction = (Player.get_global_mouse_position() - Player.global_position).normalized() * BULLET_FORCE
		var rotation = Player.rotation
		shoot_bullet.rpc_id(1, position, direction, rotation)


@rpc("any_peer", "call_local", "reliable")
func shoot_bullet(position:Vector2, direction:Vector2, rotation:float):
	if not multiplayer.is_server():
		return
	
	print("Player ", Player.name, " spawning bullet...")
	Player.bullet_fired.emit(position, direction, rotation)

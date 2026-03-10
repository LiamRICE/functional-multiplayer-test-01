extends CharacterBody2D

signal bullet_fired(position:Vector2, direction:Vector2, rotation:float)

const SPEED = 100
@export var health:float = 100

# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$InputSynchronizer.set_multiplayer_authority(id)

# Player synchronized input.
@onready var input = $InputSynchronizer

func _ready():
	# Set the camera as current if we are this player.
	if player == multiplayer.get_unique_id():
		$Camera2D.make_current()
		$HealthBar.value_changed.connect(get_tree().get_first_node_in_group("GameplayUI").update_healthbar)
	# Only process on server.
	# EDIT: Let the client simulate player movement too to compesate network input latency.
	# set_physics_process(multiplayer.is_server())


func _physics_process(_delta):
	# Handle movement.
	var input_mouse = input.input_direction.get("mouse")
	var input_move = input.input_direction.get("move")
	var direction = Vector2(input_move.x, input_move.y).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	look_at(input_mouse)


@rpc("any_peer", "call_local", "reliable")
func take_damage(damage:float):
	self.health = self.health - damage
	$HealthBar.value = self.health
	print("Player ", self, " suffered ", str(damage), " damage.")
	print("Health = ", int(self.health))

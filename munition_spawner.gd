extends MultiplayerSpawner

# Constants
const SPAWN_RANDOM := 50.0
const bullet_scene:String = "res://bullet.tscn"
var spawn_node:Node2D


func _ready() -> void:
	var path = self.spawn_path
	spawn_node = get_node(path)


func add_bullet(position:Vector2, direction:Vector2, rotation:float):
	if not multiplayer.is_server():
		return
	
	var bullet : RigidBody2D = preload(bullet_scene).instantiate()

	# Spawn bullet with impulse.
	bullet.position = position
	bullet.rotation = rotation
	bullet.apply_impulse(direction, position)
	spawn_node.add_child(bullet, true)
	print("Bullet spawned by ", multiplayer.get_unique_id())

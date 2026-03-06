extends MultiplayerSpawner

# Constants
const SPAWN_RANDOM := 50.0
var spawn_node:Node2D


func _ready() -> void:
	var path = self.spawn_path
	spawn_node = get_node(path)


func add_player(id: int):
	print("Peer ", id, " connected.")
	var character = preload("res://player.tscn").instantiate()
	# Set player id.
	character.player = id
	# Randomize character position.
	var pos := Vector2.from_angle(randf() * 2 * PI)
	character.position = Vector2(pos.x * SPAWN_RANDOM * randf(), pos.y * SPAWN_RANDOM * randf())
	character.name = str(id)
	spawn_node.add_child(character, true)


func del_player(id: int):
	if not spawn_node.has_node(str(id)):
		return
	spawn_node.get_node(str(id)).queue_free()

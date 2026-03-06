extends MultiplayerSpawner

# Constants
const SPAWN_RANDOM := 50.0
const character_scene:String = "res://player.tscn"
var spawn_node:Node2D
var munition_spawner:MultiplayerSpawner


func _ready() -> void:
	var path = self.spawn_path
	spawn_node = get_node(path)
	munition_spawner = $"../MunitionSpawner"


func add_player(id: int):
	print("Peer ", id, " connected.")
	var character = preload(character_scene).instantiate()
	# Set player id.
	character.player = id
	# Randomize character position.
	var pos := Vector2.from_angle(randf() * 2 * PI)
	character.position = Vector2(pos.x * SPAWN_RANDOM * randf(), pos.y * SPAWN_RANDOM * randf())
	character.name = str(id)
	character.bullet_fired.connect(munition_spawner.add_bullet)
	spawn_node.add_child(character, true)


func del_player(id: int):
	if not spawn_node.has_node(str(id)):
		return
	spawn_node.get_node(str(id)).queue_free()

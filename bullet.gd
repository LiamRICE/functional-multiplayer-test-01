extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(deal_damage_to)


func deal_damage_to(entity:Node):
	print("Collided with ", entity)
	queue_free()

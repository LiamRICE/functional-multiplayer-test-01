extends RigidBody2D

var timer : Timer
var tracking_time : float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $Timer
	body_entered.connect(deal_damage_to)
	timer.timeout.connect(delete_self)
	timer.wait_time = tracking_time
	timer.start()


func deal_damage_to(entity:Node):
	print("Collided with ", entity)
	delete_self()


func delete_self():
	queue_free()

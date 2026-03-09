extends Area2D

var timer : Timer
var tracking_time : float = 5

var move_direction : Vector2 = Vector2.ZERO
var move_speed : float = 100
var damage : float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $Timer
	body_entered.connect(deal_damage_to)
	timer.timeout.connect(delete_self)
	timer.wait_time = tracking_time
	timer.start()


func init(bullet_position:Vector2, direction:Vector2, bullet_rotation:float, speed:float = 100):
	self.position = bullet_position
	self.move_direction = direction
	self.rotation = bullet_rotation
	self.move_speed = speed


func _physics_process(delta: float) -> void:
	self.global_position = self.global_position + move_direction.normalized() * move_speed * delta


func deal_damage_to(entity:Node):
	print("Bullet ", self, " collided with ", entity)
	if entity.has_method("take_damage"):
		entity.take_damage.rpc_id(1, self.damage)
	delete_self()


func delete_self():
	queue_free()

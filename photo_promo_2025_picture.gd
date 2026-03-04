extends Node2D

var speed:float = 50
var timer:float = 5
var move_right:bool = true


func _ready() -> void:
	print("Photo ready")


func _process(delta: float) -> void:
	if timer <= 0:
		timer = 5
		move_right = not(move_right)
	
	if move_right:
		position.x += speed * delta
	else:
		position.x -= speed * delta
	
	timer = timer - delta

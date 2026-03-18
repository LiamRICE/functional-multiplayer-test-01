extends Node2D

var rooms:Array = []
var weapons:Array = []


func get_room_of_type():
	pass


func get_total_power_consumption():
	pass


func get_power_generation() -> float:
	return 0


func set_power_budget(room:Room, budget:float):
	if self.get_total_power_consumption() + (budget - room.get_power_budget()) <= self.get_power_generation():
		room.set_power_budget(budget)


func get_atmosphere_generation():
	pass

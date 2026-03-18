class_name Room
extends Node

# Room Information
@export_category("Room Metadata")
@export var room_name:String
@export_category("Room Power & Function")
@export var power_requirement:float
@export var power_budget:float
@export var function_level:float
@export_category("Room Systems")
@export var systems:Array[System]


func load_data(resource:RoomResource):
	print(resource.room_name)
	# initialise room information from resource


func set_power_budget(budget:float):
	self.power_budget = budget


func get_power_budget() -> float:
	return self.power_budget

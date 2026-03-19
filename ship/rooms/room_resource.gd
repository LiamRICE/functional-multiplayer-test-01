class_name RoomResource
extends Resource

@export_category("Room Metadata")
@export var room_name:String
@export_category("Room Power & Function")
@export var power_requirement:float
@export_category("Room Systems")
@export var systems:Array[SystemResource]

class_name ShipResource
extends Resource

@export_category("Metadata")
@export var ship_name:String
@export_category("Default Rooms")
@export var default_room_spawn_order:Array[Vector2]
@export var default_rooms:Array[RoomResource]
@export_category("Optional Rooms")
@export var optional_room_spawn_order:Array[Vector2]
@export var room_slots:Array[Dictionary]

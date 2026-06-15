class_name SaveUtils


static func write_player_setting(setting_name:String, setting_value:Variant):
	var data := _read_data("player_settings")
	data[setting_name] = setting_value
	_write_data("player_settings", data)


static func read_player_setting(setting_name:String) -> Variant:
	var data := _read_data("player_settings")
	if setting_name in data.keys():
		return data.get(setting_name)
	else:
		return null


static func _read_data(filename:String) -> Dictionary:
	var file = FileAccess.open("user://"+filename+".dat", FileAccess.READ)
	if file != null:
		var content = file.get_as_text()
		var json_content : Dictionary = JSON.parse_string(content)
		return json_content
	else:
		return Dictionary()


static func _write_data(filename:String, data:Dictionary):
	var file := FileAccess.open("user://"+filename+".dat", FileAccess.WRITE)
	var content = JSON.stringify(data)
	file.store_string(content)

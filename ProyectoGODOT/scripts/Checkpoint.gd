extends Node

var last_position = null
var save_game_filepath = "res://assets/savefile"


func _save_game():
	
	var data_directory = {
		"last_position" : last_position
	}
	
	var save_file = File.new()
	save_file.open(save_game_filepath, File.WRITE)
	save_file.store_line(to_json(data_directory))	
	save_file.close()


func _load_game():
	var save_file = File.new()   
	if not save_file.file_exists(save_game_filepath):
		print("No hay partida guardada")
		last_position = Vector2(13280, -1652)
		get_tree().change_scene("res://scenes/World.tscn")
	else:
		save_file.open(save_game_filepath,File.READ)
		var data_dictionnary_loaded = parse_json(save_file.get_line())
		#print(data_dictionnary_loaded["last_position"])
		#last_position = data_dictionnary_loaded["last_position"]
		get_tree().change_scene("res://scenes/World.tscn")
		
func _new_game():
	last_position = null
	get_tree().change_scene("res://scenes/World.tscn")

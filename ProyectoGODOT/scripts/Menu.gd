extends Node

func _ready():
	$VBoxContainer/VBoxContainer/Start.grab_focus()

func _on_Start_pressed():
	Checkpoint._new_game()
	get_tree().change_scene("res://scenes/World.tscn")


func _on_Options_pressed():
	Checkpoint._load_game()
	#print("Options pressed")
	


func _on_Exit_pressed():
	get_tree().quit()

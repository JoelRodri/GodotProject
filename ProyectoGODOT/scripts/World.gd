extends Node2D

func _enter_tree():
	if Checkpoint.last_position:
		$Player.global_position = Checkpoint.last_position


func _on_Area2D_body_entered(body):
	if body.get_name() == "TileMap":
		pass
	else:
		body.die()

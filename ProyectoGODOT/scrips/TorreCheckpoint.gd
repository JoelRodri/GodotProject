extends Area2D

var used: bool = false

func _ready():
	if used == false:
		$AnimationPlayer.play("Off")
	else:
		$AnimationPlayer.play("On")

func _on_Area2D_body_entered(body):
	if used == false:
		$AnimationPlayer.play("On")
		Checkpoint.last_position = global_position

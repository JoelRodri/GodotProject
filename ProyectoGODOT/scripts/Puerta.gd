extends Node2D



func _ready():
	$Path2D/PathFollow2D/AnimationPlayer.play("oscilar")


func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		body.damage(0.5,true)

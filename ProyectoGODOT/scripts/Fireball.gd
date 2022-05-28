extends Area2D

const SPEED = 100
var velocity = Vector2()
func _ready():
	$Timer.start()

func _physics_process(delta):
	velocity.x = SPEED * delta
	translate(velocity)
	$AnimatedSprite.play("shoot")

#func _on_VisibilityNotifier2D_screen_exited():
	#queue_free()

func _on_Timer_timeout():
	queue_free() # Replace with function body.


func _on_Fireball_body_entered(body):
	if body.get_name() == "Player":
		body.damage(1,true) # Replace with function body.

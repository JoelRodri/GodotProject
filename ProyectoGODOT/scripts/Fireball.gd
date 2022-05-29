extends Area2D

const SPEED = 200
var velocity = Vector2()
var mirando = true

func _ready():
	$Timer.start()

func _physics_process(delta):
	if mirando:
		velocity.x = SPEED * delta
	else:
		velocity.x = -SPEED * delta
	
	translate(velocity)
	$AnimatedSprite.play("shoot")

#func _on_VisibilityNotifier2D_screen_exited():
	#queue_free()

func _on_Timer_timeout():
	queue_free() # Replace with function body.


func _on_Fireball_body_entered(body):
	if body.get_name() == "Player":
		body.damageWithoutKnock(1) # Replace with function body.
		
func _mirando(watch: bool):
	if watch:
		mirando = true
	else:
		mirando = false
		scale.x = -scale.x

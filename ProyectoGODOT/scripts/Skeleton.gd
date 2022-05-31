extends KinematicBody2D

var is_moving_left = true

var gravity =  10 
var velocity = Vector2(0, 0)
var life: float = 3
var speed = 32 

var knockforce = 1000
var knockback = Vector2.ZERO
var takedamage = false


func _ready():
	$AnimationPlayer.play("Run")

func _process(_delta):
	if takedamage:
		knockback = knockback.move_toward(Vector2.ZERO, 200 * _delta)
		knockback = move_and_slide(knockback, Vector2.UP)
		
	if $AnimationPlayer.current_animation == "Attack":
		return
	move_character()
	detect_turn_around()
	detect_turn_around2()
	
func move_character():
	velocity.x = speed if is_moving_left else -speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x

func detect_turn_around2():
	if $RayCast2D2.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x

func hit():
	$AttackDetector.monitoring = true

func end_of_hit():
	$AttackDetector.monitoring = false
	
func start_walk():
	$AnimationPlayer.play("Run")

func _on_PlayerDetector_body_entered(body):
	if body.get_name() == "Player":
		$AnimationPlayer.play("Attack")
	
func _on_AttackDetector_body_entered(body):
	if body.get_name() == "Player":
		body.damage(1,is_moving_left)
		

func die():
	queue_free()

func damage(dam: float,watching: bool):
	knockbackFunc(watching)
	life -= dam
	if life <= 0:
		die()
		
func knockbackFunc(watching: bool):
	takedamage = true
	if watching:
		knockback = Vector2.RIGHT * 200
	else:
		knockback = Vector2.LEFT * 200

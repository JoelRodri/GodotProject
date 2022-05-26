extends KinematicBody2D
const FIREBALL = preload("res://scenes/Fireball.tscn")
const STONE = preload("res://scenes/Skeleton.tscn")

export(int) var hitpoints = 100
var max_hitpoints = hitpoints
signal life_boss_changed(boss_life)

var gravity =  10 
var velocity = Vector2(0, 0)

var speed = 96 
var speedBull = 5000

var jump = false
var fall = false

var left = false
var right = false

var proceso = false

var bull = false

var chaseRight = null
var chaseLeft = null

func _ready():
#	connect("life_changed", get_parent().get_node("UI/Life"), "on_player_life_changed")
#	emit_signal("life_changed", max_hmaearts)
	connect("life_boss_changed",get_parent().get_node("UIboss/LifeBoss"), "on_boss_life_changed")
	emit_signal("life_boss_changed", max_hitpoints)

func _physics_process(delta):
	
	if chaseRight:
		move_characterRight()

	if chaseLeft:
		move_characterLeft()
		
	if jump:
		move_character()
	else:
		velocity.x = 0
		velocity = move_and_slide(velocity, Vector2.UP)
	if fall:
		move_character2()
	else:
		velocity.x = 0
		velocity = move_and_slide(velocity, Vector2.UP)
	if left:
		move_characterLeft()
	else:
		velocity.x = 0
		velocity = move_and_slide(velocity, Vector2.UP)
	if right:
		move_characterRight()
	else:
		velocity.x = 0
		velocity = move_and_slide(velocity, Vector2.UP)
	if bull:
		move_characterLikeABull()
	else:
		velocity.x = 0
		velocity = move_and_slide(velocity, Vector2.UP)
		
	gravity_character()
	
	if Input.is_action_just_pressed("test_key"):
			_shoot()

func move_character():
	velocity.x = -speed
	velocity.y = -speed/2
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
func move_character2():
	velocity.x = speed
	velocity.y = -speed/2
	velocity = move_and_slide(velocity, Vector2.UP)
	
func move_characterLeft():
	velocity.x = -speed
	velocity = move_and_slide(velocity, Vector2.UP)
	
func move_characterRight():
	velocity.x = speed
	velocity = move_and_slide(velocity, Vector2.UP)
	

func gravity_character():
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _jump_Start():
	jump = true
	
func _jump_End():
	jump = false
	
func _fall_Start():
	fall = true
	
func _fall_End():
	fall = false
	
func _left_Start():
	left = true
	
func _left_End():
	left = false
	
func _right_Start():
	right = true
	
func _right_End():
	right= false

func _Bull_Start():
	bull = true
	
func _Bull_End():
	bull= false

	
func _on_PlayerDetector_body_entered(body):

	if !proceso:
		if body.get_name() == "Player":
			proceso = true
			$AnimationPlayer.play("Attack_Projectile")
			yield(get_node("AnimationPlayer"), "animation_finished")
			$AnimationPlayer.play("Jump")
			yield(get_node("AnimationPlayer"), "animation_finished")
			$AnimationPlayer.play("Fall")
			yield(get_node("AnimationPlayer"), "animation_finished")
			$AnimationPlayer.play("Bull_Charge")
			yield(get_node("AnimationPlayer"), "animation_finished")
			proceso = false
	
func attack_proyectile():
	var count = 3
	
	while count > 0:
		_shoot()
		print(" %d seconds" % count)
		count -= 1
		yield(get_tree().create_timer(1.0), "timeout") 
	
func _shoot():
	var fireball = FIREBALL.instance()
	get_parent().add_child(fireball)
	fireball.position = $Position2D.global_position
	$BossStones/Timer.start()
	
func die():
	queue_free()
	
func _eartquake():
	Globals.camera.shake(50,1,50)
	
func _on_Timer_timeout():
	shoot_stone() 

func shoot_stone():
	var stone_ins = STONE.instance()
	get_parent().add_child(stone_ins)
	stone_ins.position = get_random_position()
	#stone_ins.global_position = get_random_position()
	#call_deferred("add_child",stone_ins)
	$BossStones/Timer.stop()

func get_random_position():
	$BossStones/PathFollow2D.unit_offset = randf()
	return $BossStones/PathFollow2D.global_position
	
func move_characterLikeABull():
	velocity.x = speed*10 #if is_moving_left else -speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)


func damage(dam: int) -> void:
	hitpoints -= dam
	emit_signal("life_boss_changed", hitpoints)
	if hitpoints <= 0:
		die()


func _on_Area2DRight_body_entered(body):
	if body.get_name() == "Player":
		print("funciona")
		#print(body.position.x)
		#print(velocity.x)
		#print(velocity.x - body.position.x)
		if velocity.x - body.position.x < 0:
			chaseRight = true
			chaseLeft = false
			print("XD")
		else:
			chaseLeft = true
			chaseRight = false
			print("XD2")


		


func _on_Area2DLeft_body_entered(body):
	if body.get_name() == "Player":
		print("funciona")
		#print(body.position.x)
		#print(velocity.x)
		#print(velocity.x - body.position.x)
		if velocity.x - body.position.x < 0:
			chaseRight = true
			chaseLeft = false
			print("XD")
		else:
			chaseLeft = true
			chaseRight = false
			print("XD2")

extends KinematicBody2D
const FIREBALL = preload("res://scenes/Fireball.tscn")
const STONE = preload("res://scenes/Skeleton.tscn")

export(int) var hitpoints = 100
var max_hitpoints = hitpoints
signal life_boss_changed(boss_life)

var gravity =  10 
var velocity = Vector2(0, 0)
var atk = 1

var speed = 96 
var speedBull = 192

var jump = false
var fall = false

var left = false
var right = false

var proceso = false

var bull = false
var bullInvert = false

var chaseRight = null
var chaseLeft = null

var mirando = true

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

	if bullInvert:
		move_characterLikeABullInvert()
	else:
		velocity.x = 0
		velocity = move_and_slide(velocity, Vector2.UP)
	gravity_character()
	

func move_character():
	velocity.x = -speed*2
	velocity.y = -speed/3

	velocity = move_and_slide(velocity, Vector2.UP)
	
func move_character2():
	velocity.x = speed*2
	velocity.y = -speed/3
	
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

func _BullInvert_Start():
	bullInvert = true
	
func _BullInvert_End():
	bullInvert= false

	
func _on_PlayerDetector_body_entered(body):

	if !proceso:
		if body.get_name() == "Player":
			proceso = true
			_randomAbility()
	
func _spawn_Timer():
	var count = 1
	
	while count > 0:
		#_shoot()
		$BossStones/Timer.start()
		#print(" %d seconds" % count)
		count -= 1
		yield(get_tree().create_timer(1.0), "timeout") 
	
func _shoot():
	var fireball = FIREBALL.instance()
	get_parent().add_child(fireball)
	fireball.position = $Position2D.global_position
	fireball._mirando(mirando)

func _shootBig():
	var fireball = FIREBALL.instance()
	get_parent().add_child(fireball)
	fireball.position = $Position2D.global_position
	fireball.scale.y = 2
	fireball.scale.x = 2
	fireball._mirando(mirando)
func die():
	
	right = false
	left = false
	$AnimationPlayer.play("Dead")
	
	$".".collision_layer = false
	$".".collision_mask = false
	yield(get_node("AnimationPlayer"), "animation_finished")
	
	var count = 50
	
	while count > 0:
		$AudioStreamPlayer2D.set_volume_db(count-55)
		count -= 5
		yield(get_tree().create_timer(0.5), "timeout") 
	
	queue_free()
	
func _eartquake():
	Globals.camera.shake(100,1,200)
	_spawn_Timer()
	#$BossStones/Timer.start()
	
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
	velocity.x = speedBull*10 #if is_moving_left else -speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func move_characterLikeABullInvert():
	velocity.x = -speedBull*10 
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _healing():
	var count = 4
	
	while count > 0:
		#_shoot()
		#print(" %d seconds" % count)
		count -= 1
		hitpoints+=3
		emit_signal("life_boss_changed", hitpoints)
		yield(get_tree().create_timer(0.5), "timeout") 

func damage(dam: int) -> void:
	hitpoints -= dam
	emit_signal("life_boss_changed", hitpoints)
	if hitpoints <= 0:
		die()
		
func _whereWatching():
	if !proceso:
		$Area2DLeft.collision_layer = false
		$Area2DLeft.collision_mask = false
		if !mirando:
			left = true
			right = false
		else:
			left = false
			right = true
		
		$Area2DLeft.collision_layer = true
		$Area2DLeft.collision_mask = true

func _on_Area2DLeft_body_entered(body):
	if !proceso:
		if body.get_name() == "Player":
			if mirando:
				left = true
				right = false
				mirando = false
			else:
				left = false
				right = true
				mirando = true
			
			scale.x = -scale.x
		
#		if (velocity.x - body.position.x) > 0:
#			chaseLeft = true
#			chaseRight = null

func _on_Area2DRight_body_entered(body):
	pass
#	if body.get_name() == "Player":
#		right = true
#		left = false
#
#		mirando = true
#		scale.x = -scale.x
#		mirando = true
#		if (velocity.x - body.position.x) <= 0:
#			chaseRight = true
#			chaseLeft = null

func _on_Thornmail_body_entered(body):
	if body.get_name() == "Player":
		body.damage(atk,mirando)
	# Replace with function body.
	
func _randomAbility():

	var x = randi()%4+1
	#x = 3
	match x:
		1:
			right = false
			left = false
			$AnimationPlayer.play("Attack_Projectile")
			yield(get_node("AnimationPlayer"), "animation_finished")
			
		2:
			if mirando:
				$AnimationPlayer.play("Fall")
				yield(get_node("AnimationPlayer"), "animation_finished")
				scale.x = -scale.x
				$AnimationPlayer.play("Jump")
				yield(get_node("AnimationPlayer"), "animation_finished")
				$AnimationPlayer.play("Rest")
				yield(get_node("AnimationPlayer"), "animation_finished")
				mirando = false
				
			else:
				$AnimationPlayer.play("Jump")
				yield(get_node("AnimationPlayer"), "animation_finished")
				scale.x = -scale.x
				$AnimationPlayer.play("Fall")
				yield(get_node("AnimationPlayer"), "animation_finished")
				$AnimationPlayer.play("Rest")
				yield(get_node("AnimationPlayer"), "animation_finished")
				mirando = true
				
		3:
			right = false
			left = false
			$AnimationPlayer.play("Healing")
			yield(get_node("AnimationPlayer"), "animation_finished")
			#print("SE CURA")
		4:
			atk = 3
			if mirando:
				$AnimationPlayer.play("Bull_Charge")
				yield(get_node("AnimationPlayer"), "animation_finished")
			else:
				$AnimationPlayer.play("Bull_ChargeInvert")
				yield(get_node("AnimationPlayer"), "animation_finished")
			atk = 1
	proceso = false
#	$AnimationPlayer.play("Attack_Projectile")
#	yield(get_node("AnimationPlayer"), "animation_finished")
#	$AnimationPlayer.play("Jump")
#	yield(get_node("AnimationPlayer"), "animation_finished")
#	$AnimationPlayer.play("Fall")
#	yield(get_node("AnimationPlayer"), "animation_finished")
#	$AnimationPlayer.play("Bull_Charge")
#	yield(get_node("AnimationPlayer"), "animation_finished")

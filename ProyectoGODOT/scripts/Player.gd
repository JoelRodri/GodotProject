extends KinematicBody2D
#const FIREBALL = preload("res://scenes/Fireball.tscn")
enum {MOVING, STOP}

signal life_changed(player_hearts)


var speed = Vector2(300, 800)
var gravity = 1000
var velocity = Vector2()
var attack = false
var inmortal = false
var state = MOVING
var knockforce = 1000
var knockback = Vector2.ZERO
var mirando = true

var max_hearts: int = 2
var hearts: float = max_hearts

onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	$AnimationPlayer.play("Idle")
	$BlinkAnimationPlayer.play("stop")
	$Sprite.rotation_degrees = 0
	#$Sprite.position = Vector2(0,-8)
	connect("life_changed", get_parent().get_node("UI/Life"), "on_player_life_changed")
	emit_signal("life_changed", max_hearts)

func _on_VisibilityNotifier2D_screen_exited():
#	get_tree().reload_current_scene()
	pass

func _physics_process(delta):
	
	
	var is_jump_interrupted = Input.is_action_just_released("player_jump") and velocity.y < 0.0
	var direction = get_direction()
	calculate_move_velocity(direction, is_jump_interrupted)
	if(state == STOP):
		velocity.x = 0
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if inmortal:
		knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
		knockback = move_and_slide(knockback, Vector2.UP)
		
	set_animation()
	set_flip()
	
	
	if Input.is_action_just_pressed("player_atack"):
		attack = true
		yield(get_node("AnimationPlayer"), "animation_finished")
		attack = false



#   Metodo proyectil(fireball)
#	if Input.is_action_just_pressed("test_key"):
#		var fireball = FIREBALL.instance()
#		get_parent().add_child(fireball)
#		fireball.position = $Position2D.global_position
	
	
func die():
	state = STOP
	$AnimationPlayer.play("Die")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().reload_current_scene()
	

func set_flip():
	if velocity.x == 0:
		return
	if velocity.x < 0:
		if mirando:
			scale.x = -scale.x
			mirando = false
	else:
		if !mirando:
			scale.x = -scale.x
			mirando = true
			
	#Antigüo codigo para voltear solamente el sprite del Personaje
	#If Simplificado
	#$Sprite.flip_h = true  if velocity.x < 0 else false
#	if velocity.x < 0:
#		$Sprite.flip_h = true
#		$Sprite.position.x = -9
#	else:
#		$Sprite.flip_h = false
#		$Sprite.position.x = 9
	


func set_animation():
	if state == STOP:
		return
		
	var anim_name = "Idle"
	if velocity.x != 0:
		anim_name = "Run"
	if !is_on_floor():
		anim_name = "Jump"
	if attack:
		anim_name = "Attack"
	
	$AnimationPlayer.play(anim_name)


func calculate_move_velocity(direction, is_jump_interrupted):
	var new_velo = velocity
	new_velo.x = speed.x * direction.x
	new_velo.y += gravity * get_physics_process_delta_time()
	if direction.y == -1:
		new_velo.y = speed.y * direction.y
	if is_jump_interrupted:
		new_velo.y = 0.0
	
	velocity = new_velo

func get_direction():
	return Vector2(
		Input.get_action_strength("player_right") - Input.get_action_strength("player_left"),
		-1.0 if Input.is_action_just_pressed("player_jump") and is_on_floor() else 0.0)
#Dialogo
func set_active(active):
	set_physics_process(active)
	set_process(active)
	set_process_input(active)

func hit():
	$AttackDetector.monitoring = true

func end_of_hit():
	$AttackDetector.monitoring = false

func _on_AttackDetector_body_entered(body):
	if body.get_name() == "Boss":
		body.damage(25)
	else:
		body.die()


func damage(dam: int) -> void:
	knockbackFunc()
	if inmortal == true:
		pass
	else:
		if hearts <= 1:
			hearts -= dam
			emit_signal("life_changed", hearts)
			die()
		else:
			flash_effect()
			inmortal = true
			hearts -= dam
			emit_signal("life_changed", hearts)



func flash_effect() -> void:
	$BlinkAnimationPlayer.play("start")
	$flashTimer.start()
	


func _on_Timer_timeout():
	$BlinkAnimationPlayer.play("stop")
	inmortal = false

func knockbackFunc():
	knockback = Vector2.LEFT * 1000

func play_walk_in_animation_in_Door():
	state = STOP
	$AnimationPlayer.play("Run")

extends KinematicBody2D
#const FIREBALL = preload("res://scenes/Fireball.tscn")
enum {MOVING, STOP}

signal life_changed(player_hearts)

# VARIABLES

var speed = Vector2(350, 575)

# NIVEL MAXIMO (lvl 3)
# var speed = Vector2(425, 625) 

var gravity = 1000
var velocity = Vector2()
var attack = false
var inmortal = false
var state = MOVING
var knockforce = 1000
var knockback = Vector2.ZERO
var mirando = true
var footsound = true

var max_hearts: int = 5
var hearts: float = max_hearts

onready var blinkAnimationPlayer = $BlinkAnimationPlayer

# Metodo _ready
# Cuando el nodo está "listo", es decir, cuando tanto el nodo como sus hijos han entrado en el árbol de la escena.
# Pone por defecto los siguientes valores

func _ready():
	$AnimationPlayer.play("Idle")
	$BlinkAnimationPlayer.play("stop")
	$Sprite.rotation_degrees = 0
	#$Sprite.position = Vector2(0,-8)
	connect("life_changed", get_parent().get_node("UI/Life"), "on_player_life_changed")
	emit_signal("life_changed", max_hearts)


# Metodo _physics_process
# Loop de fisicas del videojuego llamado durante el paso de procesamiento principal
func _physics_process(delta):
	
	# Cuando pulsamos la tecla "Esc" Escape nos dirigimos al Menu
	if Input.is_action_just_pressed("player_menu"):
		get_tree().change_scene("res://scenes/Menu.tscn")
		
	# Cuando dejamos de pulsar la tecla "W" o "Space" espacio deja de saltar	
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
	
	# Cuando pulsamos click "Izquierdo" golpeamos 
	if Input.is_action_just_pressed("player_atack"):
		if !attack:
			$swordSlice.play()
		attack = true
		yield(get_node("AnimationPlayer"), "animation_finished")
		attack = false

# Habilidad de disparar un proyectil
# DESACTIVADA (Desbloqueable al matar al boss)

#   Metodo proyectil(fireball)
#	if Input.is_action_just_pressed("test_key"):
#		var fireball = FIREBALL.instance()
#		get_parent().add_child(fireball)
#		fireball.position = $Position2D.global_position
	
# Metodo die
# Cuando llamen a este metodo se reseteara la partida
func die():
	state = STOP
	$AnimationPlayer.play("Die")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_tree().reload_current_scene()
	
# Metodo set_flip
# Voltea el personaje
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
	

# Metodo set_animation
# Inicia la animacion correspondiente
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

# Metodo calculate_move_velocity
# Calcula el incremento de la velocidad para que haga carrerilla
func calculate_move_velocity(direction, is_jump_interrupted):
	var new_velo = velocity
	new_velo.x = speed.x * direction.x
	new_velo.y += gravity * get_physics_process_delta_time()
	if direction.y == -1:
		new_velo.y = speed.y * direction.y
	if is_jump_interrupted:
		new_velo.y = 0.0
	
	velocity = new_velo

# Metodo get_direction
# Devuelve la dirección actual donde mira el personaje
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

# Metodo _on_AttackDetector_body_entered(body)
# Detecta si la espada golpea a un enemigo y le hace daño
func _on_AttackDetector_body_entered(body):
	if body.get_name() == "Boss":
		body.damage(3)
	elif body.get_name() == "Skeleton2" || body.get_name() == "Skeleton3" || body.get_name() == "Skeleton10":
		body.damage(1,mirando)
	elif body.get_name() == "Player":
		pass
	else:
		body.damage(1.5,mirando)



func damage(dam: float,watching: bool ) -> void:
	knockbackFunc(watching)
	
	if !inmortal:
		hearts -= dam
		emit_signal("life_changed", hearts)
		if hearts <= 0:
			die()
		else:
			flash_effect()
			inmortal = true
			
			
func damageWithoutKnock(dam: int) -> void:
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

func knockbackFunc(watching: bool):
	if watching:
		knockback = Vector2.RIGHT * 200
	else:
		knockback = Vector2.LEFT * 200

func play_walk_in_animation_in_Door():
	state = STOP
	$AnimationPlayer.play("Run")
	
func run_sound():
	#footRun1.play()
	if footsound:
		$footRun1.play()
		footsound = false
		#print("1")
	else:
		$footRun2.play()
		footsound = true
		#print("2")

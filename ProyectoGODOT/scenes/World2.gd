extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$UIboss/LifeBoss.visible = false # Replace with function body.
	$Wall.visible = false
	$Wall.collision_layer = false
	$Wall.collision_mask = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartBattle_body_entered(body):
	if body.get_name() == "Player":
		$UIboss/LifeBoss.visible = true
		$Wall.visible = true
		$Wall.collision_layer = true
		$Wall.collision_mask = true
		$Boss._right_Start()

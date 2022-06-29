extends Node2D

onready var plataform = $plataform
onready var tween = $Tween

export var speed = 3.0
export var horizontal = true
export var distance = 192

var follow = Vector2.ZERO

const WAIT_DURATION = 1.0

func _ready():
	start_tween()

func start_tween():
	var vecRigth = Vector2.RIGHT * distance
	var vecUp = Vector2.UP * distance
	var move_direction = vecRigth if horizontal else vecUp
	var duration = move_direction.length() / float(speed * 16)
	
	tween.interpolate_property(
		self, "follow", Vector2.ZERO, move_direction, duration, 
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, WAIT_DURATION
	)
	tween.interpolate_property(
		self, "follow", move_direction, Vector2.ZERO, duration, 
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, duration + WAIT_DURATION * 2
	)
	tween.start()
	
func _physics_process(_delta: float) -> void:
	plataform.position = plataform.position.linear_interpolate(follow, 0.5)
	

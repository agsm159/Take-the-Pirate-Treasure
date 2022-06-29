extends KinematicBody2D

var facing_left = true
var damaged = false
var health = 3

onready var bullet_instace = preload("res://Scenes/pearl.tscn")
onready var player = Global.get("player")

func _physics_process(_delta: float) -> void:
	_set_animation()
	
	if player:
		var distance = player.global_position.x - self.position.x
		facing_left = true if distance < 0 else false
	
	if facing_left:
		self.scale.x = 1
	else:
		self.scale.x = -1

func _set_animation():
	var anim = "idle"
	
	if $playerDetector.overlaps_body(player):
		anim = "attack"
	else:
		anim = "idle"
	
	if damaged == true:
		anim = "hit"

	if $anim.assigned_animation != anim:
		$anim.play(anim)

func shoot():
	var bullet = bullet_instace.instance()
	get_parent().add_child(bullet)
	bullet.global_position = $spawnShoot.global_position
	
	if facing_left:
		bullet.direction = 1
	else: 
		bullet.direction = -1

func _on_playerDetector_body_entered(_body):
	$anim.play("attack")

func _on_playerDetector_body_exited(_body):
	$anim.play("idle")

func _on_hitbox_body_entered(body):
	damaged = true
	health -= 1
	body.velocity.y = body.jump_force / 2
	$hitFx.play()
	
	yield(get_tree().create_timer(0.2), "timeout")
	damaged = false
	
	if health < 1:
		queue_free()
		get_node("hitbox/collision").set_deferred("disabled", true)

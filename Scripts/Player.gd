extends KinematicBody2D

var UP = Vector2.UP
var velocity = Vector2.ZERO
var move_speed = 480
var gravity = 1200
var jump_force = -720
var is_grounded

#var player_health = 3
var max_health = 5

var damaged = false

var knockback_dir = 1
var knockback_int = 1000

var is_pushing = false

onready var raycasts = $raycasts

signal change_life(player_health)

func _ready() -> void:
	Global.set("player", self)
	
	connect("change_life", get_parent().get_node("HUD/HBoxContainer/Houder"), "on_change_life")
	emit_signal("change_life", max_health)
	
	if Global.checkpoint_pos != null:
		self.global_position.x = Global.checkpoint_pos

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = 0
	
	if !damaged:
		_get_input()
	
	if $pushRight.is_colliding():
		var object = $pushRight.get_collider()
		object.move_and_slide(Vector2(30, 0) * move_speed * delta)
		is_pushing = true
	elif $pushLeft.is_colliding():
		var object = $pushLeft.get_collider()
		object.move_and_slide(Vector2(-30, 0) * move_speed * delta)
		is_pushing = true
	else:
		is_pushing = false
	
	
	velocity = move_and_slide(velocity, UP)
	
	is_grounded = _check_is_grounded()
	
	if is_grounded:
		$Shadow.visible = true
	else:
		$Shadow.visible = false
	
	_set_animation()
	
	for plataforms in  get_slide_count():
		var collision = get_slide_collision(plataforms)
		
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision, self)
		
func _get_input():
	velocity.x = 0
	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)

	if move_direction != 0:
		$texture.scale.x = move_direction
		$left.scale.x = move_direction
		$right.scale.y = move_direction
	
	if velocity.x > 1:
		$pushRight.set_enabled(true)
	else:
		$pushRight.set_enabled(false)
	
	if velocity.x < -1:
		$pushLeft.set_enabled(true)
	else:
		$pushLeft.set_enabled(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") && is_grounded:
		velocity.y = jump_force / 2
		$jumpFx.play()

func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true 
	
	return false

func _set_animation():
	var animation = "idle"
	
	if !is_grounded:
		animation = "jump"
	elif velocity.x != 0 or is_pushing:
		animation = "run"
	if velocity.y > 0 and !is_grounded:
		animation = "fall"
	if damaged:
		animation = "hit"
	
	if $animation.assigned_animation != animation:
		$animation.play(animation)

func knockback():
	if $right.is_colliding():
		velocity.x = -knockback_dir * knockback_int
	if $left.is_colliding():
		velocity.x = knockback_dir * knockback_int
	
	velocity = move_and_slide(velocity)

func _on_hurtbox_body_entered(_body):
	playerDamage()

func hit_checkpoint():
	Global.checkpoint_pos = position.x

func _on_headCollider_body_entered(body: Node) -> void:
	if body.has_method("destroy"):
		body.destroy()


func _on_hurtbox_area_entered(_area):
	playerDamage()

func gameOver() -> void:
	if Global.player_health < 1:
		queue_free()
		Global.is_dead = true
		if get_tree().change_scene("res://Prefabs/GameOver.tscn") != OK:
			print("Problems...")
		
func playerDamage():
	Global.player_health -= 1
	damaged = true
	emit_signal("change_life", Global.player_health)
	
	knockback()
	get_node("hurtbox/collision").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.6), "timeout")
	get_node("hurtbox/collision").set_deferred("disabled", false)
	
	damaged = false
	gameOver()


func _on_Trigger_PlayerEntered() -> void:
	$camera.current = false


func _on_Boss_BossDead() -> void:
	$camera.current = true


extends KinematicBody2D

class_name base_enemy

export var speed = 64
export var health = 1

var motion = Vector2.ZERO
var gravity = 1200
var move_direction = -1
var damaged = false

func _physics_process(_delta: float) -> void:
	motion.x = speed * move_direction
	
	if  move_direction == 1:
		$texture.flip_h = true
	else:
		$texture.flip_h = false
	
	_set_animation()
	
	motion = move_and_slide(motion)

func apply_gravity(delta):
	motion.y += gravity * delta

func _on_anim_animation_finished(anim_name: String) -> void:
	if anim_name == "idle":
		$ray_wall.scale.x *= -1
		move_direction *= -1
		$anim.play("run")

func _set_animation():
	var anim = "run"
	
	if $ray_wall.is_colliding():
		anim = "idle"
	elif motion.x != 0:
		anim = "run"
	
	if damaged == true:
		anim = "damage"

	if $anim.assigned_animation != anim:
		$anim.play(anim)
	
func _on_Hitbox_body_entered(body: Node) -> void:
	damaged = true
	health -= 1
	body.velocity.y = body.jump_force / 2
	$hitFx.play()
	
	yield(get_tree().create_timer(0.2), "timeout")
	damaged = false
	
	if health < 1:
		get_node("Hitbox/collision").set_deferred("disabled", true)
		set_physics_process(false)
		get_node("collision").set_deferred("disabled", true)
		yield(get_tree().create_timer(0.8), "timeout")
		queue_free()

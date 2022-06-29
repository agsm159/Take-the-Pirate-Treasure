extends base_enemy

signal BossDead

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	_set_animation()

func _set_animation():
	var anim = "run"
	
	if $ray_wall.is_colliding():
		anim = "idle"
	elif motion.x != 0 and health > 3:
		anim = "run"
	elif motion.x != 0 and health < 3:
		anim = "angryRun"
		speed = 70
	
	if damaged == true:
		anim = "damage"
	
	if health < 1:
		anim = "die"
		emit_signal("BossDead")
	
	if $anim.assigned_animation != anim:
		$anim.play(anim)

func _on_Trigger_PlayerEntered():
	set_physics_process(true)


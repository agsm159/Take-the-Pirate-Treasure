extends base_enemy

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	_set_animation()

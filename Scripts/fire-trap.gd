extends Area2D

func _ready():
	pass

func _on_fire_body_entered(body: Node) -> void:
	if body.has_method("playerDamage"):
		body.playerDamage()

func _on_start_timeout():
	$anim.play("on")
	$FireCol.set_deferred("disabled", false)

func _on_stop_timeout():
	$anim.play("off")
	$FireCol.set_deferred("disabled", true)
	

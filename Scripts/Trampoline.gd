extends Area2D


func _ready():
	pass


func _on_trampoline_body_entered(body: Node):
	body.velocity.y = body.jump_force / 1.5
	$anim.play("jump")

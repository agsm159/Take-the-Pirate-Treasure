extends Area2D

func _ready():
	pass


func _on_spike_body_entered(body: Node) -> void:
	if body.has_method("playerDamage"):
		body.playerDamage()

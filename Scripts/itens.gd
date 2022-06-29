extends Area2D

export var fruits = 1

func _on_itens_body_entered(_body: Node) -> void:
	$collected.play()
	$Anim.play("collected")
	Global.fruits += fruits


func _on_Anim_animation_finished(anim_name: String) -> void:
	if anim_name == "collected":
		queue_free()

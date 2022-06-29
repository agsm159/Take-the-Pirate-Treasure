extends Area2D

func _on_FallZone_body_entered(_body: Node):
	if get_tree().change_scene("res://Prefabs/GameOver.tscn") != OK:
		print("Problems...")

extends CanvasLayer

func _ready():
	pass

func _on_BtnRetry_pressed():
	if get_tree().change_scene("res://Scenes/startScreen.tscn") != OK:
		print("Problems...")
	if Global.is_dead:
		Global.player_health = 3
		

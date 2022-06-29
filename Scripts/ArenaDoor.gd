extends StaticBody2D

signal DoorClosed

func _ready():
	pass


func _on_Trigger_PlayerEntered() -> void:
	$anim.play("active")


func _on_Boss_BossDead():
	$anim.play("inactive")

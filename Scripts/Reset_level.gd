extends Node

var checkpoint_pos = 0

func _ready():
	Global.fruits = 0 

func _on_Trigger_PlayerEntered_Camera() -> void:
	$BossCamera.current = true


func _on_Boss_BossDead():
	$BossCamera.current = false


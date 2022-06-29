extends Area2D

onready var changer = get_parent().get_node("Trasition_in")
export var path: String

func _ready():
	pass

func _on_ending_body_entered(body: Node) -> void:
	if body.name == "Player":
		$confetti.emitting = true
		changer.change_scene(path)
		Global.checkpoint_pos = 0
		$endFx.play()

extends Label

func _process(_delta: float) -> void:
	text = "00" + String(Global.fruits)
	if Global.fruits >= 10:
		text = "0" + String(Global.fruits)
		if Global.fruits >= 100:
			text = String(Global.fruits)

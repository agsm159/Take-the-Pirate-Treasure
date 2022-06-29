extends CanvasLayer


func change_scene(path, _delay = 2.5):
	$trasition_fx.interpolate_property($overlay, "progress", 0.0, 1.0, 2.0, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$trasition_fx.start()
	yield($trasition_fx, "tween_completed")
	assert(get_tree().change_scene(path) == OK)

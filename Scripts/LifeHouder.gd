extends Control

var life_size = 16

func on_change_life(_player_health):
	$life.rect_size.x = Global.player_health * life_size

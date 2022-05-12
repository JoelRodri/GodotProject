extends Node

var heart_size = 13

func on_player_life_changed(player_hearts: int) -> void:
	$Hearts.rect_size.x = player_hearts * heart_size

extends Control

func on_boss_life_changed(boss_life:int) -> void:
	$HPbar.set_percent_value(boss_life)

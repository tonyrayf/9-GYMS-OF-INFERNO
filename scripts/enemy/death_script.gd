extends Node

func enter() -> void:
	var enemy = get_parent().get_parent()
	enemy.queue_free()
	
func exit() -> void:
	pass

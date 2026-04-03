extends Node

var enemy

func enter() -> void:
	set_physics_process(true)
	
func exit() -> void:
	set_physics_process(false)

func _ready() -> void:
	enemy = get_parent().get_parent()


func _process(delta: float) -> void:
	pass

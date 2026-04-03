extends Node

#states
#patrol attack death
var current_state
var enemy

func _ready() -> void:
	current_state = "patrol"
	enemy = get_parent()

func _process(delta: float) -> void:
	if (enemy.health<=0):
		get_node("death_node").enter()
	else:
		get_node(current_state+"_node").enter()

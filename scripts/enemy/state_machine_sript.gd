extends Node

#states
#patrol
var current_state

func _ready() -> void:
	current_state = "patrol"
	

func _process(delta: float) -> void:
	if(true):
		get_node(current_state+"_node").enter()

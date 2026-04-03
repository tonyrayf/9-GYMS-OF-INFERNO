extends Node

var states = {0:"PatrolNode"}
var current_state


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node(states[current_state]).enter()

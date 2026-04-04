extends Node

#states
#patrol attack death
var current_state = "placeholder"
var enemy
var vision_zone

func _ready() -> void:
	change_state("patrol",false)
	enemy = get_parent()
	vision_zone = get_node("../Vision")

func _process(delta: float) -> void:
	if (enemy.health<=0):
		change_state("death")
		return
		
	if (current_state=="patrol"):
		if (vision_zone.current_body_name=="Player"):
			change_state("attack")
			
func change_state(to_state: String,do_exit: bool = true) -> void:
	if not (current_state==to_state):
		if do_exit:
			get_node(current_state+"_node").exit()
		current_state = to_state
		get_node(to_state+"_node").enter()

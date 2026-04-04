extends "res://scripts/enemy/state_machine_script.gd"

#states
#patrol runner_attack death
#can't lose target

var constant_target

func _ready() -> void:
	vision_zone = get_node("../Vision")
	
	for child in get_children():
		if "enemy" in child:
			child.enemy = enemy
	await get_tree().process_frame
	change_state("patrol",false)

func _physics_process(delta: float) -> void:
	if (enemy.health<=0):
		change_state("death")
		return
		
	if (current_state=="patrol"):
		if (vision_zone.current_body_name=="Player"):
			constant_target = vision_zone.current_body
			change_state("runner_attack")
	elif (current_state=="runner_attack"):
		pass

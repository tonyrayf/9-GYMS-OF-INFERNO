extends "res://scripts/enemy/state_machine_script.gd"

#states
#patrol ranged_attack death

func _physics_process(delta: float) -> void:
	if (enemy.health<=0):
		change_state("death")
		return
	
	if (current_state=="patrol"):
		if (vision_zone.current_body_name=="Player"):
			change_state("ranged_attack")
	elif (current_state=="rangedf_attack"):
		if (vision_zone.current_body_name=="Player"):
			lose_target_timer.stop() 
		else:
			if not enemy.moving: 
				if lose_target_timer.is_stopped():
					lose_target_timer.start()

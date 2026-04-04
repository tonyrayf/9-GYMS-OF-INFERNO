extends Node

#states
#patrol attack death
var current_state = "placeholder"
@onready var enemy = get_parent()
var vision_zone
var lose_target_timer

func _ready() -> void:
	vision_zone = get_node("../Vision")
	lose_target_timer = get_node("../LoseTargetTimer")
	lose_target_timer.timeout.connect(_on_target_lost)
	
	for child in get_children():
		if "enemy" in child:
			child.enemy = enemy
	
	await get_tree().process_frame
	
	change_state("patrol",false)

func _process(delta: float) -> void:
	if (enemy.health<=0):
		change_state("death")
		return
		
	if (current_state=="patrol"):
		if (vision_zone.current_body_name=="Player"):
			if(Global.active_now_enemies<Global.active_max_enemies):
				change_state("attack")
			else:
				change_state("waiting")	
	elif (current_state=="attack"):
		if (vision_zone.current_body_name=="Player"):
			lose_target_timer.stop() 
		else:
			if not enemy.moving: 
				if lose_target_timer.is_stopped():
					lose_target_timer.start()
	elif (current_state=="waiting"):
		if (vision_zone.current_body_name=="Player"):
			lose_target_timer.stop() 
			if(Global.active_now_enemies<Global.active_max_enemies):
				change_state("attack")
		else:
			if not enemy.moving: 
				if lose_target_timer.is_stopped():
					lose_target_timer.start()
	
	
func _on_target_lost() -> void:
	change_state("patrol")
			
func change_state(to_state: String,do_exit: bool = true) -> void:
	if not (current_state==to_state):
		if do_exit:
			get_node(current_state+"_node").exit()
		current_state = to_state
		get_node(to_state+"_node").enter()
		print(enemy.name+" went to "+current_state)

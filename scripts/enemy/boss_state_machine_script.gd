extends "res://scripts/enemy/state_machine_script.gd"

var attack_sprites_list = []
var constant_target
var bullethell
var initial_pos

func _ready() -> void:
	for child in get_children():
		if "enemy" in child:
			child.enemy = enemy
	await get_tree().process_frame
	
	var template = enemy.get_node("RangedAttackSprite")
	initial_pos = enemy.global_position
	bullethell = get_node("bullethell_node")
	template.hide()
	for i in range(50):
		var new_sprite = template.duplicate()
		add_child(new_sprite)
		attack_sprites_list.append(new_sprite)
	
	change_state("bullethell",false)
	
func _physics_process(delta: float) -> void:
	#var health_percent_to_change_state = 0.75
	#var health_init
	if (enemy.health<=0):
		change_state("death")
		return
		
	if(current_state=="bullethell"):
		if bullethell.attack_end_flag:
			change_state("boss_attack")
	elif(current_state=="boss_attack"):
		pass

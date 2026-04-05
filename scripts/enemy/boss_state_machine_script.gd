extends "res://scripts/enemy/state_machine_script.gd"

var attack_sprites_list = []
var bullethell

func _ready() -> void:
	for child in get_children():
		if "enemy" in child:
			child.enemy = enemy
	await get_tree().process_frame
	
	var template = enemy.get_node("RangedAttackSprite")
	bullethell = get_node("bullethell_node")
	template.hide()
	for i in range(500):
		var new_sprite = template.duplicate()
		add_child(new_sprite)
		attack_sprites_list.append(new_sprite)
	
	change_state("bullethell",false)
	
func _physics_process(delta: float) -> void:
	if (enemy.health<=0):
		change_state("death")
		return
		
	if(not Global.player):
		change_state("death")
	elif(current_state=="bullethell"):
		if bullethell.attack_end_flag:
			change_state("boss_attack")
	elif(current_state=="boss_attack"):
		#print(enemy.max_health)
		#if(enemy.health<=enemy.max_health*0.75):
		#	change_state("bullethell")
		pass

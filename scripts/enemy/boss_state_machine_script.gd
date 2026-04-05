extends "res://scripts/enemy/state_machine_script.gd"

var attack_sprites_list = []
var bullethell
var stage = 1

func _ready() -> void:
	for child in get_children():
		if "enemy" in child:
			child.enemy = enemy
	#await get_tree().process_frame
	
	var template = enemy.get_node("RangedAttackSprite")
	bullethell = get_node("bullethell_node")
	template.hide()
	for i in range(500):
		var new_sprite = template.duplicate()
		add_child(new_sprite)
		attack_sprites_list.append(new_sprite)
	
	
func _physics_process(delta: float) -> void:
	if (enemy.health<=0):
		change_state("death")
		return
	if(not Global.player):
		change_state("death")
	if (current_state=="placeholder"):
		change_state("bullethell",false)
		
	print(enemy.health,"  ",enemy.max_health,"  ",stage," ",current_state)
		
	if bullethell and (not bullethell.attack_end_flag):
		pass
	elif stage==1:
		if(current_state!="boss_attack"):
			#сюда спавнить
			change_state("boss_attack")
		else:
			if(enemy.health<=enemy.max_health*0.75):
				stage+=1
				bullethell.repeat_times = 2
				change_state("bullethell")
	elif stage==2:
		if(current_state!="boss_attack"):
			#сюда спавнить
			change_state("boss_attack")
		else:
			if(enemy.health<=enemy.max_health*0.50):
				stage+=1
				bullethell.repeat_times = 3
				change_state("bullethell")
	elif stage==3:
		if(current_state!="boss_attack"):
			#сюда спавнить
			change_state("boss_attack")
		else:
			if(enemy.health<=enemy.max_health*0.25):
				stage+=1
				bullethell.repeat_times = 4
				change_state("bullethell")
	elif stage==4:
		if(current_state!="boss_attack"):
			#сюда спавнить
			change_state("boss_attack")
		else:
			pass

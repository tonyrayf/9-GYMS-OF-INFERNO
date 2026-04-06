extends "res://scripts/enemy/state_machine_script.gd"

var attack_sprites_list1 = []
var attack_sprites_list2 = []
var bullethell
var stage = 1

func _ready() -> void:
	#for child in get_children():
	#		child.enemy = enemy
	enemy=get_parent()
	
	
	var template1 = enemy.get_node("RangedAttackSprite1")
	var template2 = enemy.get_node("RangedAttackSprite2")
	bullethell = get_node("bullethell_node")
	template1.hide()
	template2.hide()
	for i in range(500):
		var new_sprite = template1.duplicate()
		add_child(new_sprite)
		attack_sprites_list1.append(new_sprite)
	for i in range(500):
		var new_sprite = template2.duplicate()
		add_child(new_sprite)
		attack_sprites_list2.append(new_sprite)
	
var spawned_enemy1
var spawned_enemy2
var spawned_enemy3
var spawned_enemy4
	
func _physics_process(delta: float) -> void:
	#if (enemy.health<=0):
	#	change_state("death")
	#	return
	if(not Global.player):
		change_state("death")
	if (current_state=="placeholder"):
		change_state("bullethell",false)
		
	print(enemy.health,"  ",enemy.max_health,"  ",stage," ",current_state, " ", enemy.max_health*0.75<enemy.health)
		
	if bullethell and (not bullethell.attack_end_flag):
		pass
	elif stage==1:
		if(current_state!="boss_attack"):
			spawned_enemy1 = Global.spawn_enemy(Global.Enemies.ENEMY,enemy.global_position+Vector2(0,400))
			spawned_enemy1.get_node("Vision").detection_radius = 1000.0 
			spawned_enemy1.get_node("Vision").get_node("CollisionShape2D").shape.radius = 1000.0
			spawned_enemy2 = Global.spawn_enemy(Global.Enemies.ENEMY,enemy.global_position+Vector2(0,-400))
			spawned_enemy2.get_node("Vision").detection_radius = 1000.0 
			spawned_enemy2.get_node("Vision").get_node("CollisionShape2D").shape.radius = 1000.0
			change_state("boss_attack")
		else:
			if(not is_instance_valid(spawned_enemy1)) and (not is_instance_valid(spawned_enemy2)) \
			and (not is_instance_valid(spawned_enemy3)) and (enemy.max_health*0.75>enemy.health):
				stage+=1
				bullethell.repeat_times = 2
				change_state("bullethell")
	elif stage==2:
		if(current_state!="boss_attack"):
			spawned_enemy1 = Global.spawn_enemy(Global.Enemies.TANK_ENEMY,enemy.global_position+Vector2(-200,0))
			spawned_enemy1.get_node("Vision").detection_radius = 1000.0 
			spawned_enemy1.get_node("Vision").get_node("CollisionShape2D").shape.radius = 1000.0
			spawned_enemy2 = Global.spawn_enemy(Global.Enemies.RANGED_ENEMY,enemy.global_position+Vector2(300,300))
			spawned_enemy2.get_node("Vision").detection_radius = 1500.0 
			spawned_enemy2.get_node("Vision").get_node("CollisionShape2D").shape.radius = 1500.0
			spawned_enemy3 = Global.spawn_enemy(Global.Enemies.RANGED_ENEMY,enemy.global_position+Vector2(300,-300))
			spawned_enemy3.get_node("Vision").detection_radius = 1500.0 
			spawned_enemy3.get_node("Vision").get_node("CollisionShape2D").shape.radius = 1500.0
			change_state("boss_attack")
		else:
			if(not is_instance_valid(spawned_enemy1) and not is_instance_valid(spawned_enemy2) \
			and not is_instance_valid(spawned_enemy3)) and (enemy.max_health*0.5>enemy.health):
				stage+=1
				bullethell.repeat_times = 3
				change_state("bullethell")
	elif stage==3:
		if(current_state!="boss_attack"):
			spawned_enemy1 = Global.spawn_enemy(Global.Enemies.RUNNER_ENEMY,enemy.global_position+Vector2(0-200,400))
			spawned_enemy1.get_node("Vision").detection_radius = 2000.0 
			spawned_enemy1.get_node("Vision").get_node("CollisionShape2D").shape.radius = 2000.0
			spawned_enemy2 = Global.spawn_enemy(Global.Enemies.RUNNER_ENEMY,enemy.global_position+Vector2(-200,-400))
			spawned_enemy2.get_node("Vision").detection_radius = 2000.0 
			spawned_enemy2.get_node("Vision").get_node("CollisionShape2D").shape.radius = 2000.0
			spawned_enemy3 = Global.spawn_enemy(Global.Enemies.TANK_ENEMY,enemy.global_position+Vector2(-200,0))
			spawned_enemy3.get_node("Vision").detection_radius = 2000.0 
			spawned_enemy3.get_node("Vision").get_node("CollisionShape2D").shape.radius = 2000.0
			change_state("boss_attack")
		else:
			if(not is_instance_valid(spawned_enemy1) and not is_instance_valid(spawned_enemy2) \
			and not is_instance_valid(spawned_enemy3)) and (enemy.max_health*0.75>enemy.health):
				stage+=1
				bullethell.repeat_times = 4
				change_state("bullethell")
	elif stage==4:
		if(current_state!="boss_attack"):
			spawned_enemy1 = Global.spawn_enemy(Global.Enemies.RUNNER_ENEMY,enemy.global_position+Vector2(0-200,400))
			spawned_enemy1.get_node("Vision").detection_radius = 2000.0 
			spawned_enemy1.get_node("Vision").get_node("CollisionShape2D").shape.radius = 2000.0
			spawned_enemy2 = Global.spawn_enemy(Global.Enemies.RUNNER_ENEMY,enemy.global_position+Vector2(-200,-400))
			spawned_enemy2.get_node("Vision").detection_radius = 2000.0 
			spawned_enemy2.get_node("Vision").get_node("CollisionShape2D").shape.radius = 2000.0
			spawned_enemy3 = Global.spawn_enemy(Global.Enemies.RANGED_ENEMY,enemy.global_position+Vector2(300,300))
			spawned_enemy3.get_node("Vision").detection_radius = 1500.0 
			spawned_enemy3.get_node("Vision").get_node("CollisionShape2D").shape.radius = 1500.0
			spawned_enemy4 = Global.spawn_enemy(Global.Enemies.RANGED_ENEMY,enemy.global_position+Vector2(300,-300))
			spawned_enemy4.get_node("Vision").detection_radius = 1500.0 
			spawned_enemy4.get_node("Vision").get_node("CollisionShape2D").shape.radius = 1500.0
			change_state("boss_attack")
		#else:
			#if enemy.health<0:
				#change_state("death")
				#spawned_enemy1.change_state("death")
				#spawned_enemy2.change_state("death")
				#spawned_enemy3.change_state("death")
				#spawned_enemy4.change_state("death")

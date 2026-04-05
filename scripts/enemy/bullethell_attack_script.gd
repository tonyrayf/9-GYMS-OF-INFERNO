extends Node

var enemy
var attack_sprites_list
var attack_end_flag: bool = false
var repeat_times = 1

func _ready() -> void:
	enemy = get_parent().get_parent()
	attack_sprites_list = get_parent().attack_sprites_list
	set_physics_process(false) 

	
func enter() -> void:
	enemy.set_physics_process(false)
	set_physics_process(false) 
	attack_end_flag = false
	enemy.velocity = Vector2.ZERO 
	enemy.global_position = enemy.initial_position
	for i in (repeat_times):
		var random_value = randi_range(1, 3)
		if random_value==1:
			await mass_circle_attack()
		if random_value==2:
			await mass_line_attack_horizontal()
		if random_value==3:
			await mass_line_attack_vertical()
		
	attack_end_flag = true
	
func exit() -> void:
	enemy.set_physics_process(true)

func test_mass_attack(a,time,damage) -> void:
	var pos = enemy.global_position
	enemy.spawn_ranged_attack(attack_sprites_list[0],damage,pos+Vector2(a,a),time,spawn_damage.bind(damage,pos+Vector2(a,a)))
	enemy.spawn_ranged_attack(attack_sprites_list[1],damage,pos+Vector2(a,-a),time,spawn_damage.bind(damage,pos+Vector2(a,-a)))
	enemy.spawn_ranged_attack(attack_sprites_list[2],damage,pos+Vector2(-a,a),time,spawn_damage.bind(damage,pos+Vector2(-a,a)))
	await enemy.spawn_ranged_attack(attack_sprites_list[3],damage,pos+Vector2(-a,-a),time,spawn_damage.bind(damage,pos+Vector2(-a,-a)))
	
func circle_attack(radius,amount,time,damage,sprite_index=0) -> void:
	var pos = enemy.global_position
	var rotAngle = 2*PI/amount
	var angle = 0
	for i in range(amount-1):
		var x = pos.x + radius * cos(angle)
		var y = pos.y + radius * sin(angle)
		enemy.spawn_ranged_attack(attack_sprites_list[sprite_index+i],damage,Vector2(x,y),time,spawn_damage.bind(damage,Vector2(x,y)))
		angle+=rotAngle
	var x = pos.x + radius * cos(angle)
	var y = pos.y + radius * sin(angle)
	await enemy.spawn_ranged_attack(attack_sprites_list[sprite_index+amount-1],damage,Vector2(x,y),time,spawn_damage.bind(damage,Vector2(x,y)))
		
func mass_circle_attack():
	var damage = 20
	circle_attack(100,10,0.9,damage)
	circle_attack(300,25,1,damage,10)
	await circle_attack(600,50,1.2,damage,35)

func line_attack(line_pos,line_dir,amount,time,damage,distance,sprite_index=0):
	enemy.spawn_ranged_attack(attack_sprites_list[sprite_index],damage,line_pos,time,spawn_damage.bind(damage,line_pos))
	var d = distance
	var x1
	var x2
	var y1
	var y2
	var a = (amount-1)/2-1
	for i in range(a):
		if(line_dir==0):
			x1 = line_pos.x+i*d
			x2 = line_pos.x-i*d
			y1 = line_pos.y
			y2 = line_pos.y
		elif(line_dir==1):
			x1 = line_pos.x
			x2 = line_pos.x
			y1 = line_pos.y+i*d
			y2 = line_pos.y-i*d
		enemy.spawn_ranged_attack(attack_sprites_list[sprite_index+i*2],damage,Vector2(x1,y1),time+0.05*i,spawn_damage.bind(damage,Vector2(x1,y1)))
		enemy.spawn_ranged_attack(attack_sprites_list[sprite_index+i*2+1],damage,Vector2(x2,y2),time+0.05*i,spawn_damage.bind(damage,Vector2(x2,y2)))
	if(line_dir==0):
		x1 = line_pos.x+a*d
		x2 = line_pos.x-a*d
		y1 = line_pos.y
		y2 = line_pos.y
	elif(line_dir==1):
		x1 = line_pos.x
		x2 = line_pos.x
		y1 = line_pos.y+a*d
		y2 = line_pos.y-a*d
	enemy.spawn_ranged_attack(attack_sprites_list[sprite_index+a*2],damage,Vector2(x1,y1),time+0.05*a,spawn_damage.bind(damage,Vector2(x1,y1)))
	await enemy.spawn_ranged_attack(attack_sprites_list[sprite_index+a*2+1],damage,Vector2(x2,y2),time+0.05*a,spawn_damage.bind(damage,Vector2(x2,y2)))
	
func mass_line_attack_horizontal():
	var pos = enemy.global_position
	var d = 300#distance between lines
	var d2 = 80#inline distance
	var damage = 20
	circle_attack(100,10,0.9,damage)
	line_attack(pos+Vector2(0,0.5*d),0,17,1,damage,d2,11)
	line_attack(pos+Vector2(0,1.5*d),0,17,1,damage,d2,29)
	line_attack(pos+Vector2(0,-0.5*d),0,17,1,damage,d2,47)
	await line_attack(pos+Vector2(0,-1.5*d),0,17,1,damage,d2,65)
	
func mass_line_attack_vertical():
	var pos = enemy.global_position
	var d = 300#distance between lines
	var d2 = 80#inline distance
	var damage = 20
	circle_attack(100,10,0.9,damage)
	line_attack(pos+Vector2(0.5*d,0),1,17,1,damage,d2,11)
	line_attack(pos+Vector2(1.5*d,0),1,17,1,damage,d2,29)
	line_attack(pos+Vector2(-0.5*d,0),1,17,1,damage,d2,47)
	await line_attack(pos+Vector2(-1.5*d,0),1,17,1,damage,d2,65)
	

func spawn_damage(damage,whereTo) -> void:
	Global.spawn_damage_hitbox(damage,whereTo,Global.Attacker.ENEMY,50)

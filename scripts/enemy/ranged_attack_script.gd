extends "res://scripts/enemy/attack_script.gd"

var motion_stop_timer
var attack_land_timer
var saved_pos: Vector2

func enter() -> void:
	enemy.current_speed = enemy.attack_speed
	set_physics_process(true)
	
func exit() -> void:
	set_physics_process(false)

func _ready() -> void:
	enemy = get_parent().get_parent()
	vision_area = enemy.get_node("Vision")
	attack_cooldown_timer = enemy.get_node("AttackCooldownTimer")
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown)
	attack_cooldown_timer.wait_time = enemy.attack_cooldown
	motion_stop_timer = enemy.get_node("MotionStopTimer")
	motion_stop_timer.timeout.connect(_resume_motion)
	attack_land_timer = enemy.get_node("AttackLandTimer")
	attack_land_timer.timeout.connect(_attack_land)
	set_physics_process(false) 

func _physics_process(_delta: float) -> void:
	
	if(vision_area.current_body_location!=Vector2.INF):
		last_player_pos = vision_area.current_body_location
	else:
		enemy.move_to(last_player_pos)
		return
		
	var a = enemy.global_position
	var b = vision_area.current_body.global_position
	var dir_to_go = b.direction_to(a)
	var range_to_go = a.distance_to(b)
		
	if vision_area.current_body_name=="Player" and \
		enemy.global_position.distance_to(last_player_pos) <= enemy.attack_range and\
		enemy.global_position.distance_to(last_player_pos) > enemy.attack_range/2:
			if not attack_cooldown_flag:
				saved_pos = b
				print("ДАЛЬНЯЯ АТАКА")
				enemy.set_physics_process(false)
				motion_stop_timer.start()
				attack_cooldown_flag = true
				attack_cooldown_timer.start()
	
	#Global.spawn_damage_hitbox(enemy.damage,enemy.global_position,Global.Attacker.ENEMY,enemy.attack_range)
	
	if(range_to_go>=enemy.attack_range):
		enemy.move_to(b,enemy.attack_range)	
	elif(range_to_go<enemy.attack_range):	
		enemy.move_to(b+dir_to_go*(enemy.attack_range-range_to_go),5)

func _resume_motion() -> void:
	enemy.set_physics_process(true)
	
func _attack_land() -> void:
	Global.spawn_damage_hitbox(enemy.damage,saved_pos,Global.Attacker.ENEMY,enemy.attack_range)
	
func _on_attack_cooldown() -> void:
	attack_cooldown_flag = false

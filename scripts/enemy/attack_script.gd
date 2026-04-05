extends Node

var enemy
var vision_area
var last_player_pos
var attack_cooldown_timer
var attack_cooldown_flag: bool = false

func enter() -> void:
	Global.active_now_enemies += 1
	#print("active now: "+str(Global.active_now_enemies))
	enemy.current_speed = enemy.attack_speed
	set_physics_process(true)
	
func exit() -> void:
	Global.active_now_enemies -= 1
	#print("active now: "+str(Global.active_now_enemies))
	set_physics_process(false)

func _ready() -> void:
	enemy = get_parent().get_parent()
	vision_area = enemy.get_node("Vision")
	attack_cooldown_timer = enemy.get_node("AttackCooldownTimer")
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown)
	attack_cooldown_timer.wait_time = enemy.attack_cooldown
	set_physics_process(false) 


func _physics_process(_delta: float) -> void:
	if(vision_area.current_body_location!=Vector2.INF):
		last_player_pos = vision_area.current_body_location
	
	if vision_area.current_body_name=="Player" and \
		enemy.global_position.distance_to(last_player_pos) <= enemy.attack_range:
			if not attack_cooldown_flag:	
				Global.spawn_damage_hitbox(enemy.damage,enemy.global_position,Global.Attacker.ENEMY,enemy.attack_range)
				attack_cooldown_flag = true
				attack_cooldown_timer.start()
	
	enemy.move_to(last_player_pos)
		
func _on_attack_cooldown() -> void:
	attack_cooldown_flag = false

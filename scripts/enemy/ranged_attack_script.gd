extends "res://scripts/enemy/attack_script.gd"

var attack_land_timer
var saved_pos: Vector2
var buf_player_pos
var attack_sprite
@export var attack_fly_duration: float = 0.8

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
	attack_sprite = enemy.get_node("AttackSprite")
	set_physics_process(false) 

func _physics_process(_delta: float) -> void:
	
	if(vision_area.current_body_location!=Vector2.INF):
		last_player_pos = vision_area.current_body_location
	else:
		enemy.move_to(last_player_pos,10)
		return
		
	var a = enemy.global_position
	var b = vision_area.current_body.global_position
	var dir_to_go = b.direction_to(a)
	var range_to_go = a.distance_to(b)
		
	if vision_area.current_body_name=="Player" and \
	a.distance_to(last_player_pos) <= enemy.attack_range*0.6 and\
	a.distance_to(last_player_pos) > enemy.attack_range*0.4:
		if not attack_cooldown_flag:	
			attack_cooldown_flag = true
			attack_cooldown_timer.start()

			enemy.spawn_ranged_attack(attack_sprite,enemy.damage,b,attack_fly_duration,2,spawn_damage.bind(b))
	
	if(range_to_go>=enemy.attack_range):
		enemy.move_to(b,enemy.attack_range)	
	elif(range_to_go<enemy.attack_range):	
		enemy.move_to(b+dir_to_go*(enemy.attack_range-range_to_go)*0.8,10)

func spawn_damage(whereTo) -> void:
	Global.spawn_damage_hitbox(enemy.damage,whereTo,Global.Attacker.ENEMY,100)

func _resume_motion() -> void:
	enemy.set_physics_process(true)
	
func _on_attack_cooldown() -> void:
	attack_cooldown_flag = false

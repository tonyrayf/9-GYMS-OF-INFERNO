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
			
			attack_sprite.position = Vector2.ZERO
			var tween = create_tween().bind_node(attack_sprite)
			
			tween.tween_callback(attack_sprite.show)
			tween.tween_property(attack_sprite, "global_position", b,attack_fly_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.parallel().tween_property(attack_sprite, "rotation_degrees", 360.0, attack_fly_duration).as_relative()
			tween.parallel().tween_property(attack_sprite, "scale", Vector2(2.0, 2.0), attack_fly_duration/2).set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(attack_sprite, "scale", Vector2(1.0, 1.0), attack_fly_duration/2).set_trans(Tween.TRANS_LINEAR)
			tween.tween_callback(attack_sprite.hide)
			tween.tween_property(attack_sprite, "position", Vector2.ZERO, 0.0)
			
			tween.finished.connect(_on_done.bind(b))
	
	if(range_to_go>=enemy.attack_range):
		enemy.move_to(b,enemy.attack_range)	
	elif(range_to_go<enemy.attack_range):	
		enemy.move_to(b+dir_to_go*(enemy.attack_range-range_to_go)*0.8,10)

func _on_done(whereTo) -> void:
	Global.spawn_damage_hitbox(enemy.damage,whereTo,Global.Attacker.ENEMY,100)

func _resume_motion() -> void:
	enemy.set_physics_process(true)
	
func _on_attack_cooldown() -> void:
	attack_cooldown_flag = false

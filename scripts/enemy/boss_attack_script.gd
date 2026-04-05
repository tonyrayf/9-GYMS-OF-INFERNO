extends "res://scripts/enemy/attack_script.gd"

func enter() -> void:
	enemy.current_speed = enemy.attack_speed
	set_physics_process(true)

func _ready() -> void:
	enemy = get_parent().get_parent()
	attack_cooldown_timer = enemy.get_node("AttackCooldownTimer")
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown)
	attack_cooldown_timer.wait_time = enemy.attack_cooldown
	set_physics_process(false) 
	
func _physics_process(_delta: float) -> void:
	if enemy.global_position.distance_to(Global.player.global_position) <= enemy.attack_range:
		if not attack_cooldown_flag:	
			Global.spawn_damage_hitbox(enemy.damage,enemy.global_position,Global.Attacker.ENEMY,enemy.attack_range)
			attack_cooldown_flag = true
			attack_cooldown_timer.start()
	
	enemy.move_to(Global.player.global_position,200)

extends Node


var player : CharacterBody2D
var main_camera : Camera2D

enum Attacker { PLAYER, ENEMY, ENV }
var active_max_enemies: int = 1
var active_now_enemies: int = 0
var wait_range: float = 750.0

func spawn_damage_hitbox(damage: float, position: Vector2, attacker: int, radius: float = 50.0, time_to_live: float = 0.08) -> bool:
	var damage_hitbox_scene := load("res://scenes/damage_hitbox.tscn")
	var damage_hitbox = damage_hitbox_scene.instantiate()
	get_tree().current_scene.add_child(damage_hitbox)
	
	damage_hitbox.damage = damage
	damage_hitbox.global_position = position
	damage_hitbox.attacker = attacker
	damage_hitbox.sphere_collision.radius = radius
	damage_hitbox.time_to_live = time_to_live
	
	# дальше душная проверка на столкновение, чтобы вернуть bool ударил или нет
	var space_state = damage_hitbox.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	
	query.shape = shape
	query.transform = Transform2D(0, position)
	
	var results = space_state.intersect_shape(query)
	var punched = false
	
	for result in results:
		var body = result.collider
		if (not body.is_in_group("player") and attacker == Global.Attacker.PLAYER) \
		or (not body.is_in_group("enemy") and attacker == Global.Attacker.ENEMY):
			punched = true
	
	return punched
	
var enemy_preload = preload("res://scenes/enemy/enemy.tscn")
var tank_enemy_preload = preload("res://scenes/enemy/tank_enemy.tscn")
var ranged_enemy_preload = preload("res://scenes/enemy/ranged_enemy.tscn")
var runner_enemy_preload = preload("res://scenes/enemy/runner_enemy.tscn")
var boss_enemy_preload = preload("res://scenes/enemy/boss_enemy.tscn")

enum Enemies { ENEMY, TANK_ENEMY, RANGED_ENEMY,RUNNER_ENEMY, BOSS_ENEMY}
var enemies_list = [enemy_preload,tank_enemy_preload,ranged_enemy_preload,runner_enemy_preload]
	
func spawn_enemy(type: int,position: Vector2) -> Node2D:
	var enemy_instance = enemies_list[type].instantiate()
	enemy_instance.position = position
	add_child(enemy_instance)
	return enemy_instance

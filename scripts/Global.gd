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

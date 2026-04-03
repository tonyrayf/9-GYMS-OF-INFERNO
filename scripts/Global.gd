extends Node


enum Attacker { PLAYER, ENEMY, ENV }

func spawn_damage_hitbox(damage: float, position: Vector2, attacker: int, time_to_live: float = 0.08, radius: float = 50.0) -> void:
	var damage_hitbox_scene := load("res://scenes/damage_hitbox.tscn")
	var damage_hitbox = damage_hitbox_scene.instantiate()
	get_tree().current_scene.add_child(damage_hitbox)
	
	damage_hitbox.damage = damage
	damage_hitbox.global_position = position
	damage_hitbox.attacker = attacker
	damage_hitbox.sphere_collision.radius = radius
	damage_hitbox.time_to_live = time_to_live

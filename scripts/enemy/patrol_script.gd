extends Node

@export var path_to_follow: Path2D
var enemy
var curve: Curve2D
var progress = 0.0

func enter() -> void:
	set_physics_process(true)
	if curve and enemy:
		var local_pos = path_to_follow.to_local(enemy.global_position)
		progress = curve.get_closest_offset(local_pos)
		var target_pos = path_to_follow.to_global(curve.sample_baked(progress))
		enemy.move_to(target_pos)
	
func exit() -> void:
	set_physics_process(false)
	if is_instance_valid(enemy):
		enemy.moving = false
		enemy.velocity = Vector2.ZERO

func _ready() -> void:
	set_physics_process(false)
	if not path_to_follow:
		printerr("Не назначен путь")
		return
	enemy = get_parent().get_parent()
	curve = path_to_follow.curve
	
func _physics_process(delta: float) -> void:
	if not curve or not enemy:
		return
	progress += 1.1 * enemy.speed * delta
		
	if progress > curve.get_baked_length():
		progress = 0.0
		
	var target_pos = path_to_follow.to_global(curve.sample_baked(progress))
	enemy.move_to(target_pos)

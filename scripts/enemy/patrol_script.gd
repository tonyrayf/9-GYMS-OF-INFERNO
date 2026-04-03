extends Node

@export var path_to_follow: Path2D
var enemy
var curve
var target_pos

var progress = 0.0
var speed = 0
var direction


func enter() -> void:
	set_physics_process(true)
	
func exit() -> void:
	set_physics_process(false)

func _ready() -> void:
	if not path_to_follow:
		printerr("Не назначен путь")
		return
	enemy = get_parent().get_parent()
	speed = enemy.speed
	curve = path_to_follow.curve
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	if speed and progress:
		progress += speed * delta
		
	if curve and progress and progress > curve.get_baked_length():
		progress = 0.0
		
<<<<<<< HEAD
	if curve:
		target_pos = path_to_follow.to_global(curve.sample_baked(progress))
	#enemy.global_position = target_pos
	if enemy:
		direction = (target_pos - enemy.global_position).normalized()
		enemy.apply_central_force(direction * speed)
=======
	target_pos = path_to_follow.to_global(curve.sample_baked(progress))
	enemy.move_to(target_pos)
>>>>>>> a4ff613 (some architecture improvments for enemy_regular)

extends RigidBody2D


@export_group("Movement")
@export var speed : float = 360

@export_group("Stats")
@export var health: float = 100.0

var look_vector
var move_direction


func get_damage(damage: float) -> void:
	health -= damage


func _process(delta: float) -> void:
	look_vector = linear_velocity.normalized()
	z_index = global_position.y


var target_pos
var moving

func move_to(target: Vector2) -> void:
	target_pos = target
	moving = true

func _physics_process(_delta: float) -> void:
	if moving:
		move_direction = (target_pos - global_position).normalized()
		apply_central_force(move_direction * speed)
		'''if global_position.distance_to(target_pos) < 10.0:
			moving = false
			# Опционально: обнуляем скорость для резкой остановки
			linear_velocity = Vector2.ZERO '''

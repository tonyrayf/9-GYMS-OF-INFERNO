extends RigidBody2D


@export_group("Movement")
@export var speed : float = 360

@export_group("Stats")
@export var health: float = 100.0

var look_vector


func deal_damage(damage: float) -> void:
	health -= damage


func _process(delta: float) -> void:
	look_vector = linear_velocity.normalized()
	z_index = global_position.y
	
	if health <= 0:
		queue_free()

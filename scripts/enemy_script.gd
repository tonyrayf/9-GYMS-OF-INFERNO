extends RigidBody2D


@export_group("Movement")
@export var speed : float = 360

@export_group("Stats")
@export var health: float = 100.0


func _process(delta: float) -> void:
	z_index = global_position.y

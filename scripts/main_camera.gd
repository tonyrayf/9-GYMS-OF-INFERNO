extends Camera2D


@export var player : Node2D


func _process(delta: float) -> void:
	if player:
		global_position = player.global_position

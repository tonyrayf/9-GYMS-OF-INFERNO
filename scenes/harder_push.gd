extends Area2D


@export var time_to_live : float = 0.07
@onready var timer : float = time_to_live


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var direction = (body.global_position - Global.player.global_position).normalized()
		
		body.push_to(direction, 1600)


func _process(delta: float) -> void:
	timer -= delta
	
	if timer <= 0:
		queue_free()

extends Area2D


@export var anim_player : Node


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if anim_player:
			anim_player.play("arena_start")
		
		queue_free()

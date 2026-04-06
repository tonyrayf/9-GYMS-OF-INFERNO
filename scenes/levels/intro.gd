extends Node2D


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/levels/Level1.tscn"))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack_punch") or Input.is_action_just_pressed("attack_kick"):
		get_tree().change_scene_to_packed(load("res://scenes/levels/Level1.tscn"))

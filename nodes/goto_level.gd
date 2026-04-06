extends Area2D


@export var next_level : PackedScene 
@export var anim_player : Node
@export var anim_end : bool = false
@export var active : bool = false


func _on_body_entered(body: Node2D) -> void:
	if active and body.is_in_group("player"):
		if next_level:
			anim_player.play("level_end")
		else:
			print("Ошибка: Следующая сцена не назначена!")


func _process(delta: float) -> void:
	if anim_end:
		get_tree().change_scene_to_packed(next_level)

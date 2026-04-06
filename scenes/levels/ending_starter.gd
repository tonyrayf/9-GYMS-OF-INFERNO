extends Node


@onready var boss = $"../Wave1/BossEnemy"
@onready var anim_player = $"../AnimationPlayer"
@export var start_ending = false


func _process(delta: float) -> void:
	if start_ending:
		get_tree().change_scene_to_packed(load("res://scenes/levels/Outro.tscn"))
		return
	
	if boss and boss.health <= 1:
		anim_player.play("end")

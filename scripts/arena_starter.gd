extends Area2D


@export var anim_player : Node
@export var audio_music : Node

@onready var battle_music = preload("res://assets/music/бой1.mp3")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if anim_player:
			anim_player.play("arena_start")
		
		audio_music.stream = battle_music
		audio_music.play()
		
		queue_free()

extends Node


@export var anim_player : Node

@export var waves : Array[Node]
var current_wave : int = 0
@onready var wave_number : int = len(waves)

@export var arena_active : bool = false
@export var audio_music : Node

@onready var no_battle_music = preload("res://assets/music/титрыхз.mp3")


func _ready() -> void:
	for wave in waves:
		Global.set_node_active_recursive(wave, false)


func _process(delta: float) -> void:
	if arena_active:
		# Начало волны
		if not waves[current_wave].visible:
			Global.set_node_active_recursive(waves[current_wave], true)
		
		if len(waves[current_wave].get_children()) == 0:
			# Волна окончена
			if current_wave < wave_number - 1:
				current_wave += 1
			# Арена - ВСЁ
			else:
				anim_player.play("arena_end")
				audio_music.stream = no_battle_music
				audio_music.play()
				queue_free()

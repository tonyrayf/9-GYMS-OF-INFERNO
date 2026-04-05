extends Node


@export var anim_player : Node

@export var waves : Array[Node]
var current_wave : int = 0
@onready var wave_number : int = len(waves)

@export var arena_active : bool = false


func _ready() -> void:
	for wave in waves:
		Global.set_node_active_recursive(wave, false)


func _process(delta: float) -> void:
	if arena_active:
		# Начало волны
		if not waves[current_wave].visible:
			Global.set_node_active_recursive(waves[current_wave], true)
		
		# Волна окончена
		if current_wave < wave_number - 1 and len(waves[current_wave].get_children()) == 0:
			current_wave += 1

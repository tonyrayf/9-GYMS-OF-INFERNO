extends Camera2D


@export var follow_player : bool = false

var shake_time : float = 0 # длительность шейка
var shake_timer : float = 0
var shake_amplitude : float = 0
var shake_magnitude : float = 0 # количество циклов


func shake(amplitude: float, duration: float, magnitude: float = 1) -> void:
	shake_time = duration
	shake_timer = duration
	rotation_degrees = -shake_amplitude
	shake_amplitude = amplitude
	shake_magnitude = magnitude


func _ready() -> void:
	Global.main_camera = self


func _process(delta: float) -> void:
	if Global.player and follow_player:
		global_position = Global.player.global_position
	
	# Shake
	if shake_timer > 0:
		shake_timer = max(shake_timer - delta, 0)
		rotation_degrees = shake_amplitude * sin((1 - shake_timer / shake_time) * 2*PI * shake_magnitude)
		
		if shake_timer <= 0:
			rotation_degrees = 0

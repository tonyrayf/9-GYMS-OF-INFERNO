extends Node

var enemy

func enter() -> void:
	enemy.current_speed = 0
	set_physics_process(true)
	
func exit() -> void:
	set_physics_process(false)
	
func _ready() -> void:
	enemy = get_parent().get_parent()
	set_physics_process(false) 
	
func _physics_process(_delta: float) -> void:
	enemy.move_to(enemy.global_position,10)

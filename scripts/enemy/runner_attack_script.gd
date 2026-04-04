extends "res://scripts/enemy/attack_script.gd"

var state_machine

func enter() -> void:
	enemy.current_speed = enemy.attack_speed
	set_physics_process(true)
	
func exit() -> void:
	set_physics_process(false)

func _ready() -> void:
	state_machine = get_parent()
	enemy = get_parent().get_parent()
	vision_area = enemy.get_node("Vision")
	set_physics_process(false) 

func _physics_process(_delta: float) -> void:
	if enemy.current_speed < enemy.max_speed:
		enemy.current_speed+=enemy.acceleration
	enemy.move_to(state_machine.constant_target.global_position,5)

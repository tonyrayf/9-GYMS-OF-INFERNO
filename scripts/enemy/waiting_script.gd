extends Node

var enemy
var vision_area
var last_player_pos
var attack_cooldown_timer
var attack_cooldown_flag: bool = false

func enter() -> void:
	enemy.current_speed = enemy.waiting_speed
	set_physics_process(true)
	
func exit() -> void:
	set_physics_process(false)
	
func _ready() -> void:
	enemy = get_parent().get_parent()
	vision_area = enemy.get_node("Vision")
	set_physics_process(false) 
	
func _physics_process(_delta: float) -> void:
	
	if(vision_area.current_body_location!=Vector2.INF):
		last_player_pos = vision_area.current_body_location
	
	enemy.move_to(last_player_pos,Global.wait_range-400)

extends Node

var enemy

func enter() -> void:
	set_physics_process(true)
	
func exit() -> void:
	set_physics_process(false)
	enemy.state_node.on_exit()

func _ready() -> void:
	enemy = get_parent().get_parent()
	set_physics_process(false) 


func _physics_process(_delta: float) -> void:
	print(enemy.name+" ENTERED ATTACKING STATE!")

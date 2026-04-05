extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.spawn_enemy(Global.Enemies.TANK_ENEMY,Vector2(1000,1600))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Area2D


@export var anim_player : Node
@export var enemies : Array[Node]


func _ready() -> void:
	return
	if enemies:
		for enemy in enemies:
			enemy.set_process(false)
			enemy.set_physics_process(false)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if anim_player:
			anim_player.play("arena_start")
		
		queue_free()

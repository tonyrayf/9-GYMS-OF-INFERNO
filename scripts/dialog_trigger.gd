extends Area2D


@export var dialog_node : Node
var dialog : bool = false

var dialog_end_func: Callable = func(): pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		dialog = true
		
		body.set_physics_process(false)
		body.set_process(false)
		
		dialog_node.set_process(true)
		
		get_tree().current_scene.add_child(dialog_node)
		
		Global.player.get_node("CanvasLayer").visible = false


func _process(delta: float) -> void:
	if dialog and not dialog_node:
		dialog_end_func.call()
		Global.player.get_node("CanvasLayer").visible = true
		queue_free()

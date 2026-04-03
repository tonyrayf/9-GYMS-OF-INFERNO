extends Area2D

var current_body_name

func _on_body_entered(body: Node2D) -> void:
	current_body_name = body.name
	print("вошёл "+current_body_name)

func _on_body_exited(body: Node2D) -> void:
	if body.name == current_body_name:
		print("вышел "+current_body_name)
		current_body_name = ""

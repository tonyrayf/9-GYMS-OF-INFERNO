extends "res://scripts/dialog_trigger.gd"


func _ready() -> void:
	dialog_end_func = func():
		get_parent().get_node("AnimationPlayer").play("janitor_away")

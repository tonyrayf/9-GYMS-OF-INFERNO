extends Node2D


@export var dialog : Node

var brat : bool = false
var ending : bool = false

func _process(delta: float) -> void:
	if not brat and dialog.text_arr[1] == "да":
		$AnimationPlayer.play("brat")
		brat = true
	
	if not ending and not dialog:
		$AnimationPlayer.play("ending")
		ending = true
	

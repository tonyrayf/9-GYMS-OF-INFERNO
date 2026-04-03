extends Sprite2D

var itself

func _ready() -> void:
	itself = get_parent()

func _process(delta: float) -> void:
	if itself.look_vector[0]<0:
		scale.x = -abs(scale.x)
	else:
		scale.x = abs(scale.x)

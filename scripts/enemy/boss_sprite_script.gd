extends Sprite2D

var itself
var original_scale_x : float 

func _ready() -> void:
	itself = get_parent()
	original_scale_x = abs(scale.x)

func _process(delta: float) -> void:
	var target_dir = sign(Global.player.global_position.x-itself.global_position.x)
	if target_dir != 0:
		scale.x = lerp(scale.x, original_scale_x * target_dir, 0.2)
	

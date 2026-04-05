extends TextureProgressBar


func _process(delta: float) -> void:
	if get_parent().is_in_group("enemy"):
		value = get_parent().health / get_parent().max_health 

extends Sprite2D

var itself
var original_scale_x : float 

func _ready() -> void:
	itself = get_parent()
	original_scale_x = abs(scale.x)

func _process(delta: float) -> void:
	if itself.look_vector:
		var target_dir = sign(itself.look_vector.x)
		if target_dir != 0:
			scale.x = lerp(scale.x, original_scale_x * target_dir, 0.2)

func simple_flash():
	# Обращаемся напрямую к свойству modulate текущего узла
	modulate = Color.RED
	
	# Ждем 0.5 секунды
	await get_tree().create_timer(0.5).timeout
	
	# Возвращаем исходный цвет (белый в Godot означает "без фильтра")
	modulate = Color.WHITE

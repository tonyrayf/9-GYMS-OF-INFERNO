extends Node

@export var path_to_follow: Path2D # Выбираем путь прямо в редакторе
var enemy
var curve
var target_pos

var progress = 0.0
var speed = 100.0

# Called when the node enters the scene tree for the first time.

func enter() -> void:
	set_physics_process(true)
	
func exit() -> void:
	set_physics_process(false)

func _ready() -> void:
	if not path_to_follow:
		printerr("Не назначен путь")
		return
	enemy = get_parent().get_parent()
	curve = path_to_follow.curve
	set_physics_process(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	progress += speed * delta
		
	if progress > curve.get_baked_length():
		progress = 0.0
		
	#target_pos = path_to_follow.global_position + curve.sample_baked(progress)
	target_pos = path_to_follow.to_global(curve.sample_baked(progress))
	enemy.global_position = target_pos

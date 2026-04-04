extends Area2D

var detectid_entity_name = "Player"

var current_body: Node2D
var current_body_name: String
var current_body_location: Vector2

func _ready() -> void:
	set_physics_process(false)

func _on_body_entered(body: Node2D) -> void:
	if body==get_parent():
		return
	if detectid_entity_name!=body.name:
		return
	current_body = body
	current_body_name = body.name
	#print("вошёл "+current_body_name)
	set_physics_process(true)

func _on_body_exited(body: Node2D) -> void:
	if body == current_body:
		#print("вышел "+current_body_name)
		current_body = null
		current_body_name = ""
		set_physics_process(false)
		current_body_location = Vector2.INF
	
func _physics_process(delta: float) -> void:
	if is_instance_valid(current_body):
		current_body_location = current_body.global_position

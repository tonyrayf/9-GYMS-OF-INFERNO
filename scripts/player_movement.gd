extends CharacterBody2D


var speed : float = 480
var last_direction : Vector2 = Vector2(1, 1)
var direction := last_direction
var acceleration : float
var deceleration : float
const SQRT_2 : float = sqrt(2)

func _ready() -> void:
	acceleration = speed / 0.2 # in seconds
	deceleration = speed / 0.1 # in seconds


func _physics_process(delta: float) -> void:
	# == Movement X ==
	direction.x = Input.get_axis("move_left", "move_right")
	
	velocity.x = speed * direction.x
	
	# == Movement Y ==
	direction.y = Input.get_axis("move_up", "move_down")
	
	velocity.y = speed * direction.y
	
	if velocity.length() > speed:
		velocity = velocity.limit_length(speed)
	
	move_and_slide()

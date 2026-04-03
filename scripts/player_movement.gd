extends CharacterBody2D


var speed : float = 480
var last_direction_x : int = 1
var direction_x : int = last_direction_x
var last_direction_y : int = 1
var direction_y : int = last_direction_y
var acceleration : float
var deceleration : float
const SQRT_2 : float = sqrt(2)

func _ready() -> void:
	acceleration = speed / 0.2 # in seconds
	deceleration = speed / 0.1 # in seconds


func _physics_process(delta: float) -> void:
	# == Movement X ==
	direction_x = Input.get_axis("move_left", "move_right")
	
	if direction_x:
		last_direction_x = direction_x
		
		velocity.x += direction_x * acceleration * delta
	elif sign(velocity.x) == last_direction_x:
		velocity.x -= last_direction_x * deceleration * delta
	else:
		velocity.x = 0
	
	velocity.x = clamp(velocity.x, -speed, speed)
	
	# == Movement Y ==
	direction_y = Input.get_axis("move_up", "move_down")
	
	if direction_y:
		last_direction_y = direction_y
		
		velocity.y += direction_y * acceleration * delta
	elif sign(velocity.y) == last_direction_y:
		velocity.y -= last_direction_y * deceleration * delta
	else:
		velocity.y = 0
	
	velocity.y = clamp(velocity.y, -speed, speed)
	
	if velocity.length() > speed:
		velocity = velocity.limit_length(speed)
	
	move_and_slide()

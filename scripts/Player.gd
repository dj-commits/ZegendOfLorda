extends Node2D


@export var move_speed: float;


func _ready():
	pass
	
func _process(delta):
	position += getMovement() * move_speed * delta;


func getMovement() -> Vector2:
	var movement: Vector2;
	movement = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	if(movement.length() > 0):
		movement = movement.normalized();
	return movement;

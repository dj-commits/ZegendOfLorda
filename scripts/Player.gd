extends Node2D


@export var move_speed: float;

signal damaged;

func _ready():
	pass
	
func _process(delta):
	position += get_movement() * move_speed * delta;


func get_movement() -> Vector2:
	var movement: Vector2;
	movement = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	if(movement.length() > 0):
		movement = movement.normalized();
	$AnimationPlayer/AnimationTree["parameters/blend_position"] = movement;
	return movement;

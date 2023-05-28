extends Node2D


@export var move_speed: float;

var player_in_view: bool;
var player: Node2D;
signal player_seen;

func _ready():
	pass

func _process(delta):
	position += getMovement() * move_speed * delta;


func getMovement() -> Vector2:
	var movement: Vector2;
	if(player_in_view):
		movement = global_position.direction_to(player.global_position);
		$AnimationPlayer/AnimationTree["parameters/blend_position"] = movement;
		#print_debug(movement);
	return movement;


func _on_area_2d_area_entered(area: Area2D):
	player = area;
	print_debug(area.position.dot(position));
	if(area.position.dot(position) >= 0):
		player_seen.emit();
		player_in_view = true;
	else:
		print("Not looking at player"); # Replace with function body.


func _on_area_2d_area_exited(area):
	if(player != null):
		player == null;
	player_in_view = false;
	#print_debug("player out of area"); # Replace with function body.

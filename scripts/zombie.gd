extends Node2D


@export var move_speed: float;
@export var attackRange: float;
@export var state: ZombieState;

enum ZombieState { Idle, Walking, Possessed, Chasing, Attacking, Dying }


var health: int;
var atkDamage: int;
var player_in_view: bool;
var player: Node2D;
var walk_destination: Vector2;
var screen_size;

@onready var walk_timer: Timer = $WalkTimer;

signal player_seen;
signal walk_dest_reached;




func _ready():
	screen_size = get_viewport_rect().size;

func _process(delta):
	var movement: Vector2;
	match state:
		ZombieState.Idle:
			print_debug("Zombie Idle");
			if(walk_timer.is_stopped()):
				set_state(ZombieState.Walking);
				walk_destination = Vector2(randf_range((screen_size.x-global_position.x), screen_size.x), randf_range((screen_size.y-global_position.y), screen_size.y));
			else:
				print_debug(walk_timer.time_left);
		ZombieState.Walking:
			print_debug("Zombie Walking");
			movement = (walk_destination - global_position).normalized();
			check_distance_to_walk_destination();
		ZombieState.Possessed:
			print_debug("Zombie Possessed");
		ZombieState.Chasing:
			movement = global_position.direction_to(player.global_position);
			print_debug("Zombie Chasing");
		ZombieState.Attacking:
			print_debug("Zombie Attacking");
		ZombieState.Dying:
			print_debug("Zombie Dying");
		
	
	position += movement * move_speed * delta;
	$AnimationPlayer/AnimationTree["parameters/blend_position"] = movement;
		


func check_distance_to_walk_destination():
	# Checks if the zombie needs to continue walking and signals when reaching destination
	if(ZombieState.Walking):
		if(walk_destination != null):
			var distance: float;
			distance = global_position.distance_to(walk_destination);
			if(distance <= 50 ):
				walk_dest_reached.emit();
			else:
				print_debug("Distance: {distance}".format({"distance" : distance}) );
				


func get_state() -> ZombieState:
	return state;


func set_state(next_state: ZombieState):
	state = next_state;
	
func _on_detection_zone__area_exited(area):
	if(player != null):
		player == null;
	player_in_view = false;
	set_state(ZombieState.Idle);


func _on_detection_zone_area_entered(area):
	player = area;
	print_debug(area.position.dot(position));
	if(area.position.dot(position) >= 0):
		player_seen.emit();
		player_in_view = true;
		set_state(ZombieState.Chasing);
	else:
		print("Not looking at player");


func _on_walk_dest_reached():
	print_debug("Walk Destination Reached");
	walk_destination == null;
	set_state(ZombieState.Idle);
	walk_timer.start();

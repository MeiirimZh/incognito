extends CharacterBody3D
class_name Player


# Nodes
@onready var cam: Camera3D = $Camera3D

# Constants
const SPEED: float = 5.5
const GRAVITY: float = 9.8
const JUMP_FORCE: float = 6.0

# Variables
var sensitivity: float = 0.5
var speed: float = 500.0

# Variables - Tilt
var target_tilt = 0.0
var tilt_str = 3.0
var tilt_speed = 8.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * sensitivity
		cam.rotation_degrees.x -= event.relative.y * sensitivity
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -80.0, 80.0)

func _physics_process(delta: float) -> void:
	var input_direction_2d = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	)
	var input_direction_3d = Vector3(
		input_direction_2d.x, 0.0, input_direction_2d.y
	)
	var direction = transform.basis * input_direction_3d
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	velocity.y -= GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
	
	handle_cam_tilt(delta)
	
	move_and_slide()

func handle_cam_tilt(delta):
	# Cam tilt
	var left_strength = Input.get_action_strength("move_left")
	var right_strength = Input.get_action_strength("move_right")
	target_tilt = (left_strength - right_strength) * tilt_str
	cam.rotation_degrees.z = lerp(cam.rotation_degrees.z, target_tilt, tilt_speed * delta)

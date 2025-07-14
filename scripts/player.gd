extends CharacterBody3D
class_name Player


# Nodes
@onready var cam: Camera3D = $Camera3D

# Variables
var sensitivity: float = 0.5
var speed: float = 500.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * sensitivity
		cam.rotation_degrees.x -= event.relative.y * sensitivity
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -80.0, 80.0)

class_name CameraComponent

extends Node

@export var _Components : Components

@export var MouseSens : float = 0.1
@export var CameraNode : Node3D
@export var Camera : Camera3D
@export var Player : CharacterBody3D



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if !is_multiplayer_authority(): return
	Camera.current = is_multiplayer_authority()

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return
	Camera.current = is_multiplayer_authority()
	if event is InputEventMouseMotion:
		if _Components._MoveMent.HaveGravity:
			Player.rotate_y(deg_to_rad(-event.relative.x * MouseSens))
			CameraNode.rotate_x(deg_to_rad(-event.relative.y * MouseSens))
			CameraNode.rotation.x = clamp(CameraNode.rotation.x, deg_to_rad(-70), deg_to_rad(90))
		else:
			Player.rotate_y(deg_to_rad(-event.relative.x * MouseSens))
			CameraNode.rotate_x(deg_to_rad(-event.relative.y * MouseSens))
			CameraNode.rotation.x = clamp(CameraNode.rotation.x, deg_to_rad(-90), deg_to_rad(90))

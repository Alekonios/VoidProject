class_name CharMoveMent

extends CharacterBody3D

@export var _Components : Components

@export var TargetPosition : Vector3
@export var TargetRotation : Vector3

@export var IK : SkeletonIK3D

@export var RunSpeed : float = 4
@export var StartSpeed : float = 2.5
@export var StartGravity : float = 4.5
@export var HaveGravity : bool = false
var GravityObject

var Speed = 2.5
var GravityCount = 4.5

var running = false

# Параметры камеры
@export var mouseSpeed = 0.05
var lookAngles = Vector2.ZERO

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	Speed = StartSpeed
	GravityCount = StartGravity

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		TargetPosition = global_position
		TargetRotation = global_rotation
	else:
		global_position = global_position.lerp(TargetPosition, delta * 12)
		global_rotation.y = lerp_angle(global_rotation.y, TargetRotation.y, delta * 12)
		global_rotation.x = lerp_angle(global_rotation.x, TargetRotation.x, delta * 12)
		global_rotation.z = lerp_angle(global_rotation.z, TargetRotation.z, delta * 12)
	if !is_multiplayer_authority(): return

	handle_movement(delta)

	

func handle_movement(delta: float) -> void:
	if Input.is_action_pressed("Run") and !Input.is_action_pressed("MoveDown"):
		running = true
		Speed = RunSpeed
	elif !Input.is_action_pressed("Run"):
		running = false
		Speed = StartSpeed

	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveDown")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if HaveGravity:
		if direction:
			velocity.x = lerp(velocity.x, direction.x * Speed * 1.2, 20 * delta)
			velocity.z = lerp(velocity.z, direction.z * Speed * 1.2, 20 * delta)
			GravityCount = lerp(GravityCount, StartGravity, 0.01)
			if running:
				_Components._StateMachine.CurrentState = _Components._StateMachine.Run
			elif !running:
				_Components._StateMachine.CurrentState = _Components._StateMachine.Walk
		else:
			velocity.x = move_toward(velocity.x, 0, Speed)
			velocity.z = move_toward(velocity.z, 0, Speed)
			_Components._StateMachine.CurrentState = _Components._StateMachine.Idle
			GravityCount = lerp(GravityCount, StartGravity, 0.01)
	else:
		if direction:
			var QuatDirection = Vector3.FORWARD
			QuatDirection *= $Camera_Node.quaternion.inverse()
			velocity.z = lerp(velocity.z, QuatDirection.z * Speed * -direction.z * 1.2, 20 * delta)
			velocity.y = lerp(velocity.y, QuatDirection.y * Speed * 1.2, 20 * delta)
			velocity.x = lerp(velocity.x, direction.x * Speed * 1.2, 20 * delta)
			_Components._StateMachine.CurrentState = _Components._StateMachine.Swiming
			GravityCount = lerp(GravityCount, 0.0, 0.01)
		else:
			velocity.x = move_toward(velocity.x, 0, 0.06)
			velocity.z = move_toward(velocity.z, 0, 0.06)
			velocity.y = move_toward(velocity.y, 0, 0.06)
			_Components._StateMachine.CurrentState = _Components._StateMachine.Swim
			GravityCount = lerp(GravityCount, 0.0, 0.01)

	if not is_on_floor():
		if HaveGravity:
			velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = GravityCount

	move_and_slide()

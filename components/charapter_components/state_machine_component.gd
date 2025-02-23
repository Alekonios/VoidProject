class_name StateMachine

extends Node


@export var CurrentAnimation : String

@onready var Animator = %AnimationTree
@onready var SyncAnimator = %AnimationTree

enum {Idle, Walk, Run, Swiming, Swim}

var CurrentState = Idle

func _process(delta: float) -> void:
	if Animator.animation_player_changed:
		update_states()

func update_states():
	if !is_multiplayer_authority(): return
	match CurrentState:
		Idle:
			UpdateAnim.rpc("Idle_")
		Walk:
			UpdateAnim.rpc("Walk_")
		Run:
			UpdateAnim.rpc("Run_")
		Swiming:
			UpdateAnim.rpc("NoGravityFly_")
		Swim:
			UpdateAnim.rpc("NoGravity_")

@rpc("any_peer", "call_local")
func UpdateAnim(Name_):
	CurrentAnimation = Name_
	Animator.set("parameters/Movement/transition_request", Name_)


@rpc("any_peer", "call_local")
func JumpAnim():
	Animator.set("parameters/JumpAnim/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	

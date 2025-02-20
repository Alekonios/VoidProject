class_name VisualComponent


extends Node

@export var IKHead : SkeletonIK3D



func _ready() -> void:
	#IK_head.start()
	hide_ob()

func _process(delta: float) -> void:
	%FPS_bar.text = str(Engine.get_frames_per_second())

func hide_ob():
	if is_multiplayer_authority():
		pass
		#$"../../T-BOTv3/Armature_029/Skeleton3D/Alpha_Joints".transparency = 1
		#$"../../T-BOTv3/Armature_029/Skeleton3D/Alpha_Surface".transparency = 1

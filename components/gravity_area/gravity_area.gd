class_name GravityArea

extends Area3D


func _on_area_entered(area: Area3D) -> void:
	if area.get_parent() == CharacterBody2D or RigidBody3D:
		if area is Hitbox and area.get_parent() is CharMoveMent:
			var P = area.get_parent()
			P.HaveGravity = true
			P.GravityObject = self
		
			


func _on_area_exited(area: Area3D) -> void:
	if area.get_parent() == CharacterBody2D or RigidBody3D:
		if area is Hitbox and area.get_parent() is CharMoveMent:
			var P = area.get_parent()
			P.HaveGravity = false
			P.GravityObject = null

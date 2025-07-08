extends Node3D

@export var rotation_speed := 5.0
var target_to_look_at: Node3D

func _process(delta):
	if target_to_look_at:
		var to = target_to_look_at.global_transform.origin
		to.y += 1.5  # Look at chest/head height
		var direction = (to - global_transform.origin).normalized()
		var target_basis = Basis.looking_at(direction, Vector3.UP)
		global_transform.basis = global_transform.basis.slerp(target_basis, delta * rotation_speed)

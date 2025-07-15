extends State


@export var idle_state: State
@export var attack_state: State


func process_input(_event: InputEvent) -> State:
	if Input.is_action_pressed("lclick"):
		return attack_state
	return null


func process_physics(_delta: float) -> State:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	
	if input_dir == Vector2.ZERO:
		return idle_state
	
	var direction := (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		parent.velocity.x = direction.x * parent.SPEED
		parent.velocity.z = direction.z * parent.SPEED
		
		if direction.length() > 0.1:
			var look_target = parent.global_transform.origin + direction
			look_target.y = parent.global_transform.origin.y + 1
			parent.visuals.look_at(look_target, Vector3.UP)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.SPEED)
		parent.velocity.z = move_toward(parent.velocity.z, 0, parent.SPEED)

	parent.move_and_slide()
	return null

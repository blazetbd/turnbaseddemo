extends State


@export var walk_state: State
@export var attack_state: State


func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO


func process_input(_event: InputEvent) -> State:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	if input_dir != Vector2.ZERO:
		return walk_state
		
	if Input.is_action_pressed("lclick"):
		return attack_state
	
	return null


func process_physics(_delta: float) -> State:
	parent.move_and_slide()
	return null

extends State


@export var walk_state: State
@export var idle_state: State


func enter() -> void:
	is_animation_finished = false
	parent.velocity = Vector3.ZERO
	super()
	if not parent.animation_player.is_connected("animation_finished", _on_animation_finished):
		parent.animation_player.connect("animation_finished", _on_animation_finished)
	

func exit() -> void:
	if parent.animation_player.is_connected("animation_finished", _on_animation_finished):
		parent.animation_player.disconnect("animation_finished", _on_animation_finished)


func process_physics(_delta: float) -> State:
	if is_animation_finished:
		return idle_state
	parent.move_and_slide()
	return null

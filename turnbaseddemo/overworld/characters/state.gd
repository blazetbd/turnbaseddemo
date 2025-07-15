class_name State
extends Node


@export var animation_name: String
@export var move_speed: float = 400

var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")
var parent: Player
var is_animation_finished = false


func enter() -> void:
	parent.animation_player.play(animation_name)


func exit() -> void:
	pass


func process_input(_event: InputEvent) -> State:
	return null


func process_frame(_delta: float) -> State:
	return null


func process_physics(_delta: float) -> State:
	return null


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == animation_name:
		is_animation_finished = true

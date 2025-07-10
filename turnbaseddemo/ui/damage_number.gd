extends Control

@onready var label = $Label
@export var speed = 50.0
@export var duration = 1.0

var direction: Vector2 = Vector2.ZERO
var is_done := false

func _ready() -> void:
	randomize()
	direction = Vector2(randf_range(-0.3, 0.3), -1.0).normalized()

func start(damage_value: int, dmg_position: Vector2):
	label.text = str(damage_value*-1)
	global_position = dmg_position
	$AnimationPlayer.play("show_damage")

func _process(delta: float) -> void:
	if is_done:
		return

	global_position += direction * speed * delta
	speed = lerp(speed, 0.0, delta * 2)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show_damage":
		is_done = true
		queue_free()

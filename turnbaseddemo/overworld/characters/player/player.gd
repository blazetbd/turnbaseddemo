class_name Player
extends CharacterBody3D


@onready var camera_mount: Node3D = $camera_mount
@onready var visuals: Node3D = $Visuals
@onready var animation_player: AnimationPlayer = $Visuals/allinone/AnimationPlayer
@onready var state_machine: Node = $StateMachine

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var attacking := false

@export var sens_horizontal = .2
@export var sens_vertical = .2


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	state_machine.init(self)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x*sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))
	
	#if Input.is_action_just_pressed("lclick"):
	#	print("yea")
	#	animation_player.play("attack")
	#	attacking = true
	#	await animation_player.animation_finished
	#	attacking = false
	#	animation_player.play("RESET")
		
	if Input.is_action_pressed("exit"):
		get_tree().quit()


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("overworld_enemies"):
		for i in body.enemies:
			if i.health != null and i.attack != null and i.speed != null:
				Global.enemy_array.append(i)
		body.call_deferred("queue_free")
		call_deferred("_change_to_battle_scene")


func _change_to_battle_scene() -> void:
	get_tree().change_scene_to_file("res://battle_envs/world.tscn")

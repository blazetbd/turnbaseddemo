extends CharacterBody3D


class_name Character


@onready var model = $CollisionShape3D/MeshInstance3D
var team: String
@export var health: int = 100
@export var attack: int = 10
@export var speed: int = 10
var is_turn: bool = false


func take_turn():
	is_turn = true


func end_turn():
	is_turn = false

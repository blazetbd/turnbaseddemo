extends StaticBody3D


@export var health: int
@export var atk: int
@export var def: int
@export var agi: int


@onready var cam: Camera3D = $Camera3D

var curr_target: int


func _ready() -> void:
	curr_target = 3

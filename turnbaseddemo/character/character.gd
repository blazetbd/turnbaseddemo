extends CharacterBody3D


class_name Character


var team: String
var health: int = 100
@export var speed: int = 10
var is_turn: bool = false


func take_turn():
	is_turn = true


func end_turn():
	is_turn = false

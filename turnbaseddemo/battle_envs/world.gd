extends Node3D

func _ready() -> void:
	var scene = load("res://battle_template/battle_template.tscn")
	var battle = scene.instantiate()
	add_child(battle)
	battle.global_position = $Marker3D.global_position
	#print("yeah")

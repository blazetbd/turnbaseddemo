extends Node3D


func _ready() -> void:
	load_enemies()
	load_party()


func load_enemies():
	var scene = load("res://enemy/enemy.tscn")
	var enemy = scene.instantiate()
	add_child(enemy)
	enemy.global_position = $Enemies/Slot3.global_position
	#print("spawned")


func load_party():
	var scene = load("res://party/party_member.tscn")
	var party_member = scene.instantiate()
	add_child(party_member)
	party_member.global_position = $Party/Slot2.global_position

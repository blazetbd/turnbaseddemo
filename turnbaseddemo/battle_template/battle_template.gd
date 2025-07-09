extends Node3D


var turn_queue: Array = []
var current_unit: Character

var enemies: Array[Node3D] = []
var party: Array[Node3D] = []
var current_target_index: int = 0
var current_target: Node3D = null
var previous_target: Node3D = null

var attacking: bool = false


func _ready() -> void:
	load_enemies()
	load_party()
	turn_queue = get_unit_order()
	for character in turn_queue:
		if character.team == "enemy":
			enemies.append(character)
		elif character.team == "party":
			party.append(character)
	if enemies.size() > 0:
		current_target_index = 0
		current_target = enemies[0]
	next_turn()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("right"):
		cycle_target(1)
	elif event.is_action_pressed("left"):
		cycle_target(-1)
	elif event.is_action_pressed("confirm") and attacking == false:
		await attack(current_target)
		end_current_turn()


func load_enemies() -> void:
	var scene = load("res://character/character.tscn")
	var enemy = scene.instantiate()
	add_child(enemy)
	enemy.team = "enemy"
	enemy.global_position = $Enemies/Slot2.global_position
	
	var enemy2 = scene.instantiate()
	add_child(enemy2)
	enemy2.team = "enemy"
	enemy2.global_position = $Enemies/Slot4.global_position
	
	var enemy3 = scene.instantiate()
	add_child(enemy3)
	enemy3.team = "enemy"
	enemy3.global_position = $Enemies/Slot1.global_position
	#print("spawned")


func load_party() -> void:
	var scene = load("res://character/character.tscn")
	var party_member = scene.instantiate()
	add_child(party_member)
	party_member.speed = 20
	party_member.team = "party"
	party_member.global_position = $Party/Slot2.global_position


func next_turn():
	print("Next turn")
	if turn_queue.is_empty():
		turn_queue = get_unit_order()
		
	var camera_rig = $CameraRig
	print("Queue: " + str(turn_queue))
	current_unit = turn_queue.pop_front()
	current_unit.take_turn()
	
	if current_unit.team == "enemy":
		toggle_color(previous_target, Color.WHITE)
		camera_rig.target_to_look_at = current_unit
		await attack(party[0])
		end_current_turn()
	else:
		print("Player turn!")
		camera_rig.global_position = current_unit.global_position
		camera_rig.global_position.y += 2
		camera_rig.global_position.x += 2
		camera_rig.target_to_look_at = current_target
		toggle_color(current_target, Color.RED)
		previous_target = current_target

func end_current_turn():
	print("End turn")
	current_unit.end_turn()
	next_turn()


func get_unit_order():
	var all_units = get_tree().get_nodes_in_group("characters")
	all_units.sort_custom(func(a,b): return a.speed > b.speed)
	print(all_units)
	return all_units


func cycle_target(direction: int):
	if enemies.size() == 0:
		return
	
	if previous_target:
		toggle_color(previous_target, Color.WHITE)
		
	current_target_index = (current_target_index + direction) % enemies.size()
	current_target = enemies[current_target_index]
	toggle_color(current_target, Color.RED)
	print(current_target)
	
	var camera_rig = $CameraRig
	camera_rig.target_to_look_at = current_target
	
	previous_target = current_target


func toggle_color(target, color) -> void:
	var mesh = target.model
	var material = mesh.get_active_material(0)
	
	material.albedo_color = color


func attack(target) -> void:
	attacking = true
	target.health -= current_unit.attack
	print(target.team + ": " + str(target.health))
	await get_tree().create_timer(3).timeout
	attacking = false

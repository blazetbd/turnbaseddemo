extends Node3D

@onready var slot_1: Marker3D = $Enemies/Slot1
@onready var slot_2: Marker3D = $Enemies/Slot2
@onready var slot_3: Marker3D = $Enemies/Slot3
@onready var slot_4: Marker3D = $Enemies/Slot4
@onready var slot_5: Marker3D = $Enemies/Slot5

var turn_queue: Array = []
var current_unit: Character

var enemies: Array[Node3D] = []
var party: Array[Node3D] = []
var enemy_slots := []
var current_target_index: int = 0
var current_target: Node3D = null
var previous_target: Node3D = null
var previous_unit: Node3D = null

var attacking: bool = false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
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
	set_camera()
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
	enemy_slots.append(slot_1)
	enemy_slots.append(slot_2)
	enemy_slots.append(slot_3)
	enemy_slots.append(slot_4)
	enemy_slots.append(slot_5)
	
	var scene = load("res://character/character.tscn")
	var enemy_array = Global.enemy_array
	var j = 0
	
	for i in enemy_array:
		var enemy = scene.instantiate()
		add_child(enemy)
		enemy.global_position = enemy_slots[j].global_position
		enemy.team = i.team
		enemy.health = i.health
		enemy.attack = i.attack
		enemy.speed = i.speed
		j += 1
	
	print("[DEBUG] Enemies loaded!")



func load_party() -> void:
	var scene = load("res://character/character.tscn")
	var party_member = scene.instantiate()
	add_child(party_member)
	party_member.speed = 20
	party_member.team = "party"
	party_member.global_position = $Party/Slot2.global_position
	
	print("[DEBUG] Party loaded!")


func next_turn():
	print("[DEBUG] Next turn")
	if turn_queue.is_empty():
		turn_queue = get_unit_order()
	
	reset_all_unit_colors()
	
	var camera_rig = $CameraRig
	print("[DEBUG] Queue: " + str(turn_queue))
	current_unit = turn_queue.pop_front()
	current_unit.take_turn()
	
	if current_unit.team == "enemy":
		toggle_color(previous_target, Color.WHITE)
		toggle_color(current_unit, Color.GREEN)
	
		camera_rig.target_to_look_at = current_unit
		await attack(party[0])
		end_current_turn()
	else:
		print("[DEBUG] Player turn!")
		camera_rig.global_position = current_unit.global_position
		camera_rig.global_position.y += 2
		camera_rig.global_position.x += 2
		camera_rig.target_to_look_at = current_target
		toggle_color(current_target, Color.RED)
		toggle_color(current_unit, Color.GREEN)
		previous_target = current_target
		previous_unit = current_unit

func end_current_turn():
	print("[DEBUG] End turn")
	current_unit.end_turn()
	next_turn()


func get_unit_order():
	var all_units = get_tree().get_nodes_in_group("characters")
	all_units.sort_custom(func(a,b): return a.speed > b.speed)
	print("[DEBUG] " +  str(all_units))
	return all_units


func cycle_target(direction: int):
	if enemies.size() == 0:
		return
	
	if previous_target:
		toggle_color(previous_target, Color.WHITE)
		
	current_target_index = (current_target_index + direction) % enemies.size()
	current_target = enemies[current_target_index]
	toggle_color(current_target, Color.RED)
	print("[DEBUG] " + str(current_target))
	
	var camera_rig = $CameraRig
	camera_rig.target_to_look_at = current_target
	
	previous_target = current_target


func toggle_color(target, color) -> void:
	if target != null:
		var mesh = target.model
		var material = mesh.get_active_material(0)
		
		material.albedo_color = color


func attack(target) -> void:
	attacking = true
	await get_tree().create_timer(1.5).timeout
	show_damage_number(current_unit.attack, target.global_position + Vector3.UP * 2)
	target.health -= current_unit.attack
	print(target.team + ": " + str(target.health))
	await get_tree().create_timer(1.5).timeout
	attacking = false


func show_damage_number(damage: int, world_position: Vector3):
	var scene = load("res://ui/damage_number.tscn")
	var num = scene.instantiate()

	var camera := get_viewport().get_camera_3d()
	var screen_pos = camera.unproject_position(world_position)

	var ui := $Ui/DamageLayer 
	ui.add_child(num)
	num.start(damage, screen_pos)


func reset_all_unit_colors():
	var all_units = get_tree().get_nodes_in_group("characters")
	for unit in all_units:
		toggle_color(unit, Color.WHITE)


func set_camera():
	var camera_rig = $CameraRig
	camera_rig.global_position = party[0].global_position
	camera_rig.global_position.y += 2
	camera_rig.global_position.x += 2

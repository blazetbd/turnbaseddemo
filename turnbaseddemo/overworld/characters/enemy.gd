extends CharacterBody3D


@export var enemies = []
@export var enemy1 = {"team": "enemy", "health": null, "attack": null, "speed": null}
@export var enemy2 = {"team": "enemy", "health": null, "attack": null, "speed": null}
@export var enemy3 = {"team": "enemy", "health": null, "attack": null, "speed": null}
@export var enemy4 = {"team": "enemy", "health": null, "attack": null, "speed": null}
@export var enemy5 = {"team": "enemy", "health": null, "attack": null, "speed": null}


func _ready() -> void:
	enemies.append(enemy1)
	enemies.append(enemy2)
	enemies.append(enemy3)
	enemies.append(enemy4)
	enemies.append(enemy5)
	print(enemies)

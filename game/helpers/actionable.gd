extends Area2D


const Balloon = preload("res://game/dialogue/balloon.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
var system_name: String = "[Actionable]"

func action() -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	if dialogue_resource==null:
		print(system_name,"Dialogue resource is null, cannot start dialogue.")
		return
	balloon.start(dialogue_resource, dialogue_start)

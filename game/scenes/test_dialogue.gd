extends Node2D

@export var test_dialogue:DialogueResource 

func _ready():
	var dialogue_line = await DialogueManager.get_next_dialogue_line(test_dialogue, "start")
	DialogueManager.show_dialogue_balloon(test_dialogue)

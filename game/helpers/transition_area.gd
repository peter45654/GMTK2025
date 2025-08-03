class_name TransitionArea
extends Area2D

const ROOM_NAME: Array[String] = [
	"LivingRoom",
	"BoyRoom",
	"WorkShop",
]
@export var transition_postion_node: Node2D
@export var object_container_node: Node2D
@export var room_visable: Array[bool] = [false, false, false]
@export var ori_room_visable: Array[bool] = [false, false, false]
@export var origin_position_node: Node2D
@export var origin_object_container_node: Node2D
var is_transitioning: bool = false
var system_name: String = "[TransitionArea]"


func _ready() -> void:
	if transition_postion_node == null:
		print("[TransitionArea] Transition position node is not set.")
		return

	body_entered.connect(_on_body_entered)


func _on_area_entered(area: Area2D) -> void:
	print(system_name, "Area entered:", area.name)


func _on_body_entered(body: Node2D) -> void:
	if is_transitioning:
		print(system_name, "Already transitioning, ignoring body:", body.name)
		return
	var player = get_tree().get_nodes_in_group("Player")[0]
	if player:
		print(system_name, "Body entered:", body.name)
		if body == player:
			print(system_name, "Player entered transition area.")
			is_transitioning = true
			transition_to_next_room(body)


func transition_to_next_room(body: Node2D) -> void:
	if transition_postion_node == null or object_container_node == null:
		print(system_name, "Transition position or object container node is not set.")
		return

	var next_position: Vector2 = transition_postion_node.position
	body.position = next_position

	var body_parent = body.get_parent()
	body_parent.remove_child(body)
	object_container_node.call_deferred("add_child", body)

	for i in range(room_visable.size()):
		print(system_name, "Setting room visibility for:", ROOM_NAME[i])
		var transition_area = get_tree().get_nodes_in_group(ROOM_NAME[i])[0]
		if transition_area:
			transition_area.visible = room_visable[i]
			print(system_name, "Room visibility set for:", ROOM_NAME[i], "to:", room_visable[i])
		else:
			print(system_name, "Transition area not found for room:", ROOM_NAME[i])

	is_transitioning = false
	# Simulate a transition delay
	print(system_name, "Transitioning to next room at position:", next_position)

func transition_to_origin_room(body: Node2D) -> void:
	if origin_position_node == null or origin_object_container_node == null:
		print(system_name, "Origin position or object container node is not set.")
		return
	is_transitioning = true
	var origin_position: Vector2 = origin_position_node.position
	body.position = origin_position

	var body_parent = body.get_parent()
	body_parent.remove_child(body)
	origin_object_container_node.call_deferred("add_child", body)

	for i in range(ori_room_visable.size()):
		print(system_name, "Setting room visibility for:", ROOM_NAME[i])
		var transition_area = get_tree().get_nodes_in_group(ROOM_NAME[i])[0]
		if transition_area:
			transition_area.visible = ori_room_visable[i]
			print(system_name, "Room visibility set for:", ROOM_NAME[i], "to:", ori_room_visable[i])
		else:
			print(system_name, "Transition area not found for room:", ROOM_NAME[i])

	is_transitioning = false
	print(system_name, "Transitioned back to origin room at position:", origin_position)

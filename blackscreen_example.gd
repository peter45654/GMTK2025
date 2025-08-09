# 使用範例 - 如何在其他場景中使用黑色轉場畫面

extends Node

# 預載黑色畫面場景
const BlackScreen = preload("res://blackscreen.tscn")
var blackscreen_instance

func _ready():
	# 創建黑色畫面實例並添加到場景樹
	blackscreen_instance = BlackScreen.instantiate()
	get_tree().current_scene.add_child(blackscreen_instance)
	
	# 連接信號
	blackscreen_instance.fade_in_completed.connect(_on_fade_in_completed)
	blackscreen_instance.fade_out_completed.connect(_on_fade_out_completed)

# 使用範例
func example_scene_transition():
	# 開始淡入黑色畫面
	blackscreen_instance.show_blackscreen()

func _on_fade_in_completed():
	print("淡入完成，可以在此進行場景切換或其他操作")
	# 例如：切換場景
	# get_tree().change_scene_to_file("res://next_scene.tscn")
	
	# 然後淡出黑色畫面
	blackscreen_instance.hide_blackscreen()

func _on_fade_out_completed():
	print("淡出完成，轉場結束")

# 在編輯器中可以調整轉場時間
# blackscreen_instance.transition_duration = 2.0
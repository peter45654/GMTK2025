@tool
extends EditorScript

const SCAN_FOLDER = "res://game/item"
const RESOURCE_CLASSES_AND_PROPERTIES = {
	"BaseItem": ["name", "description"],
}

@export var property_name: String = "dialogue_text"



# 這是一個示範方法，你可以在 Godot 編輯器中手動呼叫它
# 或是將它綁定到一個按鈕上
func _run():
	print("--- I18nTool 啟動 ---")

	if not DirAccess.dir_exists_absolute(SCAN_FOLDER):
		printerr("錯誤：指定的資料夾不存在！")
		return

	var files_to_process = get_files_to_process()

	if files_to_process.is_empty():
		print("沒有找到需要處理的檔案。")
		return

	for file_path in files_to_process:
		# print("將處理檔案：", file_path)
		process_file_for_translation_extraction(file_path)

	print("--- I18nTool 執行完畢 ---")

# 尋找所有符合條件的 .tres 檔案
func get_files_to_process():
	var files: Array[String] = []
	var dir = DirAccess.open(SCAN_FOLDER)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		# 只處理以 .tres 結尾的檔案
		if file_name.ends_with(".tres"):
			var file_path = SCAN_FOLDER.path_join(file_name)

			# 檢查檔案的類別是否符合
			var resource_class = get_resource_class(file_path)
			if resource_class in RESOURCE_CLASSES_AND_PROPERTIES:
				files.append(file_path)

		file_name = dir.get_next()
	dir.list_dir_end()
	return files

# 從 .tres 檔案內容中，透過正則表達式提取類別名稱
func get_resource_class(file_path: String) -> String:
	var file_content = FileAccess.get_file_as_string(file_path)
	# 尋找 [gd_resource type="..."] 或 [script_class="..."] 模式
	var pattern = RegEx.new()
	pattern.compile("script_class=\"([^\"]+)\"")

	var result = pattern.search(file_content)
	if result:
		return result.get_string(1) # 索引 1 匹配到類別名稱
	return ""



# 修改單一檔案的內容
func process_file_for_translation_extraction(file_path: String):
	var file_content = FileAccess.get_file_as_string(file_path)
	var script_class = get_resource_class(file_path)

	if not RESOURCE_CLASSES_AND_PROPERTIES.has(script_class):
		return

	var properties_to_scan = RESOURCE_CLASSES_AND_PROPERTIES[script_class]

	for property_name in properties_to_scan:
		var pattern = RegEx.new()
		pattern.compile(property_name + "\\s*=\\s*\"([^\"]*)\"")

		var result = pattern.search(file_content)
		if result:
			var extracted_string = result.get_string(1)
			# 在這裡呼叫 tr() 函式
			# 這是整個解決方案的關鍵，它讓 Godot 能夠自動追蹤這個字串
			tr(extracted_string)
			print("已標記字串供翻譯：", extracted_string)
		else:
			print("警告：在 ", file_path, " 中未找到屬性：", property_name)

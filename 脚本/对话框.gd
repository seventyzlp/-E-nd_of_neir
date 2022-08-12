extends CanvasLayer

var can_text = false
onready var panel = $PanelContainer # 检测输入
onready var speak_label:Label = $"VBoxContainer/content" # 预加载 # 这个是剧情对话
onready var choice_button:VBoxContainer = $"VBoxContainer/buttons" # 这个是按钮上的字
onready var tween = $Tween


enum{
	ID, # 使用ID表示下一句内容
	METHOD # 结束文本
}
const speek_speed = 5 # 文本输出速度
var contents = [] # 文本字典
var currentid


func _on_PanelContainer_visibility_changed():
	get_tree().paused = panel.visible # 暂停游戏
	set_process_input(panel.visible)
func _input(event): # 点击输入事件
	if can_text and event.is_action_pressed("mouse_left") and !tween.is_active(): #判断是不是可以讲下一句话
		speak()
func add_choice(text): # 创建选项对话框, 关联点击事件
	var choice = ToolButton.new()
	choice.text = text
	choice.align = Button.ALIGN_LEFT
	choice.add_child(choice)
	choice.connect("pressed", self, "pressed_choice", [choice.get_index()])
func speak():
	clear_choice() # 保证开始说话的时候是空白的
	if currentid == -1: # 结束对话
		contents = {}
		panel.hide()
	else:
		var content = contents[currentid]
		speak_label.text = content.speaker # 设置对话内容
		tween.interpolate_property(speak_label, "percent_visible", 0, 1, content.text.length() / speek_speed)
		tween.start() # 动态显示对话内容
		yield(tween, "tween_completed") # 等待到tween动画执行完毕
		if content.has("choices"): # 判断当前对话内容有没有选项
			for choice in content.choice:
				add_choice(choice.text) # 添加选项
		else:
			next_handle(content) # 进行下一步处理
func next_handle(_content):
	match _content.type: # 根据数据内容进行处理 
		ID:
			currentid = _content.next
		METHOD: # 如果是方法，就调用函数
			currentid = -1
			_content.next[0].call_different(_content.next[1]) # 0调用脚本，1 对应脚本的方法
	can_text = true
func clear_choice(): # 清除选项对话框
	for child in choice_button.get_children():
		choice_button.remove_child(child)
		child.queue_free()
func pressed_choice(index): # 点击事件
	var choice = contents[currentid].choice[index] # 执行下一个点击
	next_handle(choice)
	speak()
func start_dialoge(_contents = {}, _current_id = -1): # 设置对话内容，并且生成对话框
	contents = _contents
	currentid = _current_id
	panel.show()
	speak() # 开始进行对话
	

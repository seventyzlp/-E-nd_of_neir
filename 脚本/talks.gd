extends Label

var texts = ["要在这里放弃吗？", "你承认自己已经战败吗？", "这一切都是白费力气吗？"]

func set_dialogs():
	set_text(texts[randi() % texts.size()]) # 他妈的，在里面才可以修改内容是吧，草！


func _on_2_again_set_dialoge(): # 接受信号，进行内容的设置
	set_dialogs()
	$"../button_pressed".stop()

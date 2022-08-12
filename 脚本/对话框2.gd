extends CanvasLayer
signal again

func _on_Button_yes_pressed():
	$button_pressed.play()
	get_tree().quit() # 直接退出游戏了
	
func _on_Button_no_pressed():
	$button_pressed.play()
	$button_pressed/Timer.start()
	$".".visible = false 
	get_tree().paused = false
	emit_signal("again") # 再战，恢复血量，重置位置
func _on_Timer_timeout(): # 在播放完之后停止播放
	$button_pressed.stop()
	

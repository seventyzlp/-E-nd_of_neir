extends Node2D

func _on__Player_die():
	get_tree().paused = true # 暂停游戏内容
	$"../对话框2".visible = true # 提前创建好窗体，在角色死掉后显示


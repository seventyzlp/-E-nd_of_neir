extends Node2D

func _ready(): # 设置全局变量地图为自己
	Global.world = self
	$music.play()
func _exit_tree():
	Global.world = null










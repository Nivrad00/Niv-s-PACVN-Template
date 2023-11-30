extends Button

var opened = false

func _on_Button_toggled(open):
	if open:
		$AnimationPlayer.play("Open")
		text = ">"
	else:
		$AnimationPlayer.play("Close")
		text = "<"
	opened = open

func flash():
	$AnimationPlayer.play("Flash")
	

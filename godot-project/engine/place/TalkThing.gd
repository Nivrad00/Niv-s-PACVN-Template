extends Thing

export var thing_name = ""

func _on_TalkThing_clicked():
	Game.talk_about(thing_name)
	

extends Thing

class_name TakeThing

export var thing_name = ""
# this TakeThing should exist in every Place where it's possible to put it,
# not just the place where you first encounter it
export var starts_here = true

func _ready():
	if not starts_here:
		doesnt_exist()

func _on_TakeThing_clicked():
	Game.stuff.take(thing_name)
	Game.talk_about(thing_name)

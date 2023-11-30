extends Button
# only type of Thing that doesn't actually inherit from Thing
# due to it beign part of the UI

var thing_name = ""

func _on_InvThing_pressed():
	Game.talk_about(thing_name, "stuff")

func set_icon(path):
	$TextureRect.texture = load(path)

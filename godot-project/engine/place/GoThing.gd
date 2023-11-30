extends Thing

export var place_name = ""

func _on_GoThing_clicked():
	Game.location.go_to(place_name)

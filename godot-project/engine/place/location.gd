extends Control

# this can either be a Place node or just a string (in the case that the place is just an image)
var current_place = null
export var place_path = "rooms"

var place_name = "" setget , get_place_name
func get_place_name():
	if current_place is Place:
		return current_place.place_name
	elif current_place is String:
		return current_place
	
func update_place_state():
	if current_place is Place:
		current_place.update_state()
	
func go_to(where):
	for child in get_children():
		child.queue_free()
	
	# APlace node
	if ResourceLoader.exists("res://" + place_path + "/" + where + ".tscn"):
		current_place = load("res://" + place_path + "/" + where + ".tscn").instance()
		add_child(current_place)
		current_place.place_name = where
		yield(get_tree(), "idle_frame")
		current_place.update_state()
	
	# just an image
	elif ResourceLoader.exists("res://" + place_path + "/" + where + ".png"):
		var new_place = TextureRect.new()
		new_place.texture = load("res://" + place_path + "/" + where + ".png")
		add_child(new_place)
		current_place = where
		
	else:
		print(where + " location not found")
		current_place = null

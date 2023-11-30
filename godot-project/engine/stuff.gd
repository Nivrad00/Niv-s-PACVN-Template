extends Node

export var icon_path = "inventory"
var stuff_i_took = []
onready var inv_container = $Control/Panel/MarginContainer/VBoxContainer
onready var animation = $ButtonLayer/Button

func _ready():
	var dir = Directory.new()
	if dir.open("res://" + icon_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.split(".")[-1] == "png": 
				var new_thing = load("res://engine/InvThing.tscn").instance()
				new_thing.set_icon("res://" + icon_path + "/" + file_name)
				new_thing.thing_name = file_name.split(".")[0] # don't use file names with periods in them!
				inv_container.add_child(new_thing)
			file_name = dir.get_next()
	else:
		print("no folder found at inventory icon path") 
	look()
	
func take(thing_name):
	# once a thing is added to the inventory, the info always stays there, for state tracking
	# a location of "stuff" means it's in the inventory
	# a location of null means it's gone forever
	stuff_i_took.append({
		"name": thing_name,
		"location": "stuff"
	})
	Game.location.update_place_state()
	
	# put the new thing at the bottom
	for thing in inv_container.get_children():
		if thing.thing_name == thing_name:
			inv_container.remove_child(thing)
			inv_container.add_child(thing)
			
	# update the visuals
	look()
	
	# flash the bar out, if appropriate
	if not animation.opened:
		animation.flash()
	
	# do a warning if there's no inventory icon for it 
	for thing in inv_container.get_children():
		if thing.thing_name == thing_name:
			return
	print("missing inventory icon for " + thing_name)
	
func look():
	for thing in inv_container.get_children():
		if have(thing.thing_name):
			thing.show()
		else:
			thing.hide()

func drop(thing):
	for stuff in stuff_i_took:
		if stuff["name"] == thing:
			if stuff["location"] == "stuff":
				stuff["location"] = Game.location.place_name
			else:
				print("i don't have " + thing + " anymore so i can't drop it")
		else:
			print("i never took " + thing + " so i can't drop it")
	look()
	
func have(thing):
	for stuff in stuff_i_took:
		if stuff["name"] == thing and stuff["location"] == "stuff":
			return true
	return false

func is_in(thing, place):
	for stuff in stuff_i_took:
		if stuff["name"] == thing:
			if stuff["location"] == place:
				return true # we've taken the thing before, and it's in the place
			else:
				return false # we've taken the thing before, and it's not in the place
	return null # we've never taken the thing, so we don't know whether it's in the place or not

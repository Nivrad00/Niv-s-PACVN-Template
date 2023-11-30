extends Node

class_name Place

# no need to set this manually; it'll automatically get set to the name of the .tscn file
var place_name = ""
var takers = []

func _ready():
	find_takers()
	
func update_state():
	# check to see if the TakeThings should be here or not
	for thing in takers:
		var is_here = Game.stuff.is_in(thing.thing_name, place_name)
		if is_here:
			thing.exists()
		elif is_here == false:
			thing.doesnt_exist()
		# if it's null, let the TakeThing do its default behavior
	
	# to do: implement state changes for other types of things

func find_takers(node=self):
	for child in node.get_children():
		if child is TakeThing:
			takers.append(child)
		else:
			find_takers(child)

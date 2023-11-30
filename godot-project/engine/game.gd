extends Control

onready var ink = $InkPlayer
onready var words = $Words
onready var location = $Location
onready var stuff = $Stuff
onready var state = $State

func _ready():
	location.go_to("tweeter")
	ink.BindExternalFunction("have", stuff, "have", true)
	ink.ChoosePathString("start")
	more_words_pls()

func talk_about(thing_name, place=null):
	if not place:
		place = location.place_name
	if not words.talking:
		ink.ChoosePathString(place + "." + thing_name)
		more_words_pls()
	
func chose(n):
	var next = ink.ChooseChoiceIndex(n)
	more_words_pls()
	
func more_words_pls():
	if ink.HasChoices:
		words.decide(ink.CurrentChoices)
	elif ink.CanContinue:
		var next = ink.Continue()
		if next == null:
			return
		match(next.substr(0,1)):
			"@":
				location.go_to(next.substr(1).strip_edges())
				more_words_pls()
			"&":
				stuff.take(next.substr(1).strip_edges())
				more_words_pls()
			"%":
				var state_stuff = next.substr(1).strip_edges().split(" / ")
				if state_stuff.size() == 1:
					state.set(state_stuff[0], true)
				elif state_stuff.size() == 2:
					state.set(state_stuff[0], state_stuff[1])
			_:
				words.say(next)
				location.update_place_state()
	else:
		words.shut_up()

extends Node

var t = 0
var typing = false # text scrolling across screen
var talking = false # text visible on screen

func _ready():
	shut_up()

func shut_up():
	for child in $VBox.get_children():
		child.text = ""
		child.hide()
	for child in $HiddenVBox.get_children():
		child.text = ""
	for child in $VBox2.get_children():
		child.text = ""
		child.hide()
	talking = false
	for child in get_children():
		child.hide()

func decide(choices):
	$VBox2.show()
	
	for child in $VBox2.get_children():
		child.hide()
		
	var n = 0
	for choice in choices:
		$VBox2.get_child(n).text = choice.strip_edges()
		$VBox2.get_child(n).show()
		n += 1
		
	$Button.hide()
		
func say(words):
	shut_up()
		
	words = words.strip_edges().split(" ")
	var n = 0
	
	for word in words:
		if $HiddenVBox.get_child(n) == null:
			return
		if $HiddenVBox.get_child(n).text.length() + word.length() > 33:
			n += 1
		$HiddenVBox.get_child(n).text += word + " "
	
	for child in $HiddenVBox.get_children():
		child.text = child.text.strip_edges()
		
	t = 0
	typing = true
	talking = true
	
	for child in get_children():
		child.show()
	
func _process(delta):
	if typing:
		t += delta
		while t > 0.008:
			t -= 0.008
			
			var n = 0
			while $VBox.get_child(n).text.length() >= $HiddenVBox.get_child(n).text.length():
				n += 1
				if $HiddenVBox.get_child(n).text == "":
					typing = false
					return
				
			$VBox.get_child(n).show()
			$VBox.get_child(n).text += $HiddenVBox.get_child(n).text.substr($VBox.get_child(n).text.length(), 1)

extends Area2D

class_name Thing

signal clicked()

var hitboxes = []
var existing = true

# workaround to prevent multiple area2ds from receiving the input at once
# https://godotengine.org/qa/113635/how-to-check-if-a-point-is-in-a-polygon2d

func _ready():
	for child in get_children():
		if child is CollisionPolygon2D:
			hitboxes.append(child)

func _unhandled_input(event):
	if existing and event is InputEventMouseButton and event.pressed and event.button_index == 1:
		for hitbox in hitboxes:
			if Geometry.is_point_in_polygon(event.position, transform.xform(hitbox.transform.xform(hitbox.polygon))):
				emit_signal("clicked")
				get_tree().set_input_as_handled()
				return
	
func exists():
	show()
	existing = true
		
func doesnt_exist():
	hide()
	existing = false

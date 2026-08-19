class_name Note extends HBoxContainer

var box : ColorRect
var lengthRect : TextureRect

var mouse : bool = false
var mouseHeld : bool = false
var lengthMouseHeld : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	box = $Box
	lengthRect = $Length


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		


func _on_box_mouse_entered() -> void:
	mouse = true


func _on_box_mouse_exited() -> void:
	mouse = false


func _on_box_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed(): mouseHeld = true
			elif event.is_released(): mouseHeld = false
	if mouseHeld && event is InputEventMouseMotion:
		position.x += event.relative.x
	#if event.double_click == true:
	#	pass #alter hz logic


func _on_length_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && lengthMouseHeld:
		box.custom_minimum_size.x += event.relative.x
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed(): lengthMouseHeld = true
			elif event.is_released(): lengthMouseHeld = false
			

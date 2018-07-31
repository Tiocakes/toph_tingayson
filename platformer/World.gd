extends Node

onready var DialogBox = preload("res://Dialogue.tscn")
var s
var wr

func _ready():
	$Music.play()
	s = DialogBox.instance()
	wr = weakref(s);
	add_child(s)
	
func _process(delta):
	if wr.get_ref():
		if s.is_in_group("FINISHED") && Input.is_action_pressed("ui_select"):
			s.queue_free()
extends RichTextLabel

var dialog = ["Hello Player! How are you doing today?", "Good, I thought you were doing pretty well"]
var page = 0
signal finished

func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)
	set_process_input(true)

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)

func _input(event):
	if event.is_action_pressed("ui_select"):
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size() - 1:
				page += 1
				set_bbcode(dialog[page])
				set_visible_characters(0)
			else:
				emit_signal("finished")
		else:
			set_visible_characters(get_total_character_count())
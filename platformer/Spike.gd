extends Area2D

var CanHurt = true

func _ready():
	pass
	
func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	if not overlapping_bodies:
		return
	for body in overlapping_bodies:
		if body.is_in_group("Character") && CanHurt == true:
			body.take_damage(20)
			CanHurt = false
			
		

func _on_Timer_timeout():
	CanHurt = true
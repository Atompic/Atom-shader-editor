extends LineEdit

const TIMER_LIMIT = 1.0
var timer = 0.0
var fps   = 60

func _process(delta):
	timer += delta
	if timer > TIMER_LIMIT: # Prints every 2 seconds
		timer = 0.0
		fps = int(Engine.get_frames_per_second())
		self.placeholder_text = ("fps: " + str(fps) + " / " + str(Engine.max_fps))
	
func _on_text_submitted(new_text: String) -> void:
	Engine.max_fps = clamp(int(new_text),10,9999)
	if(new_text == "0"):
		Engine.max_fps = 0
	self.text = ""


func _on_focus_entered() -> void:
	self.text = ""

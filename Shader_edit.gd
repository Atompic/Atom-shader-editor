extends CodeEdit

@onready var color_rect: ColorRect = $"../ColorRect"
@onready var code_edit: CodeEdit = $"."
@onready var button_2: Button = $"../HBoxContainer/Button2"



var minimize: bool = false
var pos = Vector2(6.0,37.0)


func _ready() -> void:
	code_edit.text = (color_rect.material.shader.code) 
	code_completion_enabled = true
	
	var key_words = {
	"UV": Color(0.90, 0.60, 0.60),
	"COLOR": Color(0.90, 0.60, 0.60),
	"NORMAL": Color(0.90, 0.60, 0.60),
	
	"float": Color.ORANGE,
	"int": Color.ORANGE,
	"bool": Color.ORANGE,
	
	"vec2": Color.CORAL,
	"vec3": Color.CORAL,
	"vec4": Color.CORAL,
	
	"void": Color.RED,
	}
	syntax_highlighter.add_color_region("//", "" , Color.WEB_GRAY , true)
	syntax_highlighter.add_color_region("/*", "*/" , Color.WEB_GRAY )
	syntax_highlighter.add_color_region("[","]",Color.BLUE)
	syntax_highlighter.set_function_color(Color.DARK_BLUE)
	syntax_highlighter.set_keyword_colors(key_words)


func _on_text_changed() -> void:
	var shader =  color_rect.material.shader
	shader.code = code_edit.text
	print(shader)
	
	


func _on_button_2_pressed() -> void:
	minimize = !minimize
	self.editable = !minimize
	if(minimize):pos = button_2.position*0.2+Vector2(15.0,1.0)
	else : pos = Vector2(6.0,37.0)

func _process(delta: float) -> void:
	
	


	scale = scale.lerp(Vector2(float(!minimize),float(!minimize)),(delta+0.0085) * 2.0)
	position = position.lerp(pos,(delta+0.01) * 2.02)
	

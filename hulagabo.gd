extends StaticBody2D

var talk_count = 0

@onready var cloud = $DialogueCloud
@onready var label = $DialogueCloud/Label

func _ready() -> void:
	cloud.visible = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and talk_count == 0:
		talk_count += 1
		label.text = "I like someone else \njust go(forward)!"
		cloud.visible = true
		await get_tree().create_timer(3.0).timeout
		cloud.visible = false
		

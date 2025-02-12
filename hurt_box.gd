extends Area2D
class_name HurtBox

signal damage(amount: int)
# add more signals instead of expanding the above if needed
	

func _on_area_entered(area: Area2D) -> void:
	if area is DamageBox:
		damage.emit(area.damage)

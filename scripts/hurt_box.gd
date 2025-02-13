extends Area2D
class_name HurtBox

signal damage(amount: int)
# add more signals instead of expanding the above if needed
	

func _on_area_entered(area: Area2D) -> void:
	if area is DamageBox:
		deal_damage(area.damage_amount)

# Should be called by other objects that aren't DamageBoxes (like Raycasts)
func deal_damage(amount: int):
	damage.emit(amount)

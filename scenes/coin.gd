extends Area2D

signal coin_entered(area: Area2D);
signal coin_exited(area: Area2D);

var in_coin = false;
func _on_area_entered(area):
	in_coin = true;
	coin_entered.emit(area);

func _on_area_exited(area):
	in_coin = false;
	coin_exited.emit(area);

extends Area2D

class_name Coin;

signal coin_missed;

func collect_coin():
	self.disconnect("area_exited", _on_area_exited)
	queue_free();

var in_coin = false;
func _on_area_entered(_area):
	in_coin = true;

func _on_area_exited(_area):
	in_coin = false;
	coin_missed.emit();

extends Node

func is_mobile() -> bool:
	var operating_system = OS.get_name();
	return operating_system == "Android" or operating_system == "iOS";

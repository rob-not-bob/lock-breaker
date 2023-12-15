extends Node

var current_theme_index: int = 0;

func get_random_theme() -> Dictionary:
	var themes := [default, yellow, red, blue];
	var index := current_theme_index;
	while index == current_theme_index:
		index = randi_range(0, len(themes) - 1);

	current_theme_index = index;

	return themes[current_theme_index];

var default = {
	"bg": Color.html("#197278"),
	"shackle": Color.html("#0E2A2B"),
	"indicator": Color.html("#FFFFFF"),
	"countdown": Color.html("#FFFFFF"),
	"donut": {
		"bg": Color.html("#0A1719"),
		"arcs": [
			Color.html("#EE9B00"),
			Color.html("#CA6702"),
			Color.html("#AE2012"),
		]
	}
};

var yellow = {
	"bg": Color.html("#C17E00"),
	"shackle": Color.html("#000000B3"),
	"indicator": Color.html("#FFFFFF"),
	"countdown": Color.html("#000000B3"),
	"donut": {
		"bg": Color.html("#0A1719"),
		"arcs": [
			Color.html("#EE9B00"),
			Color.html("#CA6702"),
			Color.html("#AE2012"),
		]
	}
};

var red = {
	"bg": Color.html("#772E25"),
	"shackle": Color.html("#000000B3"),
	"indicator": Color.html("#FFFFFF"),
	"countdown": Color.html("#FFFFFFEE"),
	"donut": {
		"bg": Color.html("#0A1719"),
		"arcs": [
			Color.html("#EE9B00"),
			Color.html("#CA6702"),
			Color.html("#AE2012"),
		]
	}
};

var blue = {
	"bg": Color.html("#16566F"),
	"shackle": Color.html("#000000B3"),
	"indicator": Color.html("#FFFFFF"),
	"countdown": Color.html("#FFFFFFEE"),
	"donut": {
		"bg": Color.html("#0A1719"),
		"arcs": [
			Color.html("#124559"),
			Color.html("#598392"),
			Color.html("#AEC3B0"),
		]
	}
};

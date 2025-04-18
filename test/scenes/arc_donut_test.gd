# GdUnit generated TestSuite
class_name ArcDonutTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/arc_donut.gd'

func init_donut():
	var donut = load(__source).new();
	donut.start_angle = 0;
	donut.coyote_angle_size = 0;

	donut.arc_names.clear();
	donut.arc_names.append_array(["yellow", "orange", "red"]);

	donut.angle_sizes.clear();
	donut.angle_sizes.append_array([21.6, 10.8, 5.4]);
	donut._ready();

	donut.colors.clear();
	donut.colors.append_array([Color.html("#EE9B00"), Color.html("#CA6702"), Color.html("#AE2012")]);

	donut.reverse = false;

	return donut;

func test_get_arc_name_at_forward() -> void:
	var donut = init_donut();
	donut.reverse = false;
	donut.start_angle = 0;

	assert_str(donut.get_arc_name_at(0)).is_equal("yellow");
	assert_str(donut.get_arc_name_at(360)).is_equal("yellow");
	assert_str(donut.get_arc_name_at(10)).is_equal("yellow");
	assert_str(donut.get_arc_name_at(30)).is_equal("orange");
	assert_str(donut.get_arc_name_at(32.4)).is_equal("orange");
	assert_str(donut.get_arc_name_at(32.5)).is_equal("red");
	assert_str(donut.get_arc_name_at(37.8)).is_equal("red");
	assert_that(donut.get_arc_name_at(37.9)).is_equal(null);
	assert_str(donut.get_arc_name_at(394.8)).is_equal("red");

	donut.free();

func test_get_arc_name_at_reverse() -> void:
	var donut = init_donut();
	donut.reverse = true;
	donut.start_angle = 0;

	assert_that(donut.get_arc_name_at(0)).is_equal(null);
	assert_that(donut.get_arc_name_at(360)).is_equal(null);
	assert_str(donut.get_arc_name_at(350)).is_equal("yellow");
	assert_str(donut.get_arc_name_at(330)).is_equal("orange");
	assert_str(donut.get_arc_name_at(327.6)).is_equal("orange");
	assert_str(donut.get_arc_name_at(327.5)).is_equal("red");
	assert_str(donut.get_arc_name_at(322.2)).is_equal("red");
	assert_that(donut.get_arc_name_at(322.1)).is_equal(null);

	donut.free();

func test_get_arc_name_at_across_boundary() -> void:
	var donut = init_donut();
	donut.reverse = false;
	donut.start_angle = 350;

	assert_that(donut.get_arc_name_at(281)).is_equal(null);
	assert_str(donut.get_arc_name_at(0)).is_equal("yellow");
	assert_str(donut.get_arc_name_at(351)).is_equal("yellow");
	assert_str(donut.get_arc_name_at(5)).is_equal("yellow");

	# Edge cases found while running game
	donut.reverse = true;
	donut.start_angle = 344.560966445396;
	assert_str(donut.get_arc_name_at(-43.2126873679162)).is_equal("orange");

	donut.reverse = true;
	donut.start_angle = 272.628439891698;
	assert_str(donut.get_arc_name_at(-97.6436779053442)).is_equal("yellow");

	donut.free();

func test_get_arc_name_at_coyote_angle() -> void:
	var donut = init_donut();
	donut.reverse = false;
	donut.start_angle = 0;
	donut.coyote_angle_size = 2.5;
	donut._ready();

	assert_str(donut.get_arc_name_at(37.9)).is_equal("red");
	assert_str(donut.get_arc_name_at(40.3)).is_equal("red");
	assert_that(donut.get_arc_name_at(40.4)).is_equal(null);

	donut.reverse = true;
	donut._ready();

	assert_str(donut.get_arc_name_at(322.2)).is_equal("red");
	assert_str(donut.get_arc_name_at(322.1)).is_equal("red");
	assert_str(donut.get_arc_name_at(319.7)).is_equal("red");
	assert_that(donut.get_arc_name_at(319.6)).is_equal(null);

	donut.free();

/// @description Select Previous
// You can write your code in this editor

if (!(instructions || credits)) {
	if (selected == 0) {
		selected = numOfOptions - 1;
	} else {
		selected = selected - 1;
	}
}
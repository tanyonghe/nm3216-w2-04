/// @description 
draw_set_halign(fa_center);
draw_set_valign(fa_center);


draw_sprite(spr_gameover_screenshot, 0, midx, 360);
draw_sprite(spr_game_over, 0, midx, midy - 50);

if (canAdvance) {
	
	draw_rectangle_colour(left-5, top-5, right+5, bottom+5, c_white, c_white, c_white, c_white, false);
	draw_rectangle_colour(left, top, right, bottom, c_black, c_black, c_black, c_black, false);


	draw_set_halign(fa_center);
	draw_set_font(fnt_lives);
	draw_set_colour(c_white);

	draw_text(midx, top + 20, "CONTINUE?");
	draw_text(midx, top + 50, "Y/N");
	draw_text(midx, top + 80, "Continues used: " + string(global.continues));
	draw_set_font(-1);
}
PROGRAM exhello;
(*
  ______   ___    ___
 /\  _  \ /\_ \  /\_ \
 \ \ \L\ \\//\ \ \//\ \      __     __   _ __   ___        __    ___      ____
  \ \  __ \ \ \ \  \ \ \   /'__`\ /'_ `\/\`'__\/ __`\    /'__`\ /\__`\  /'___/
   \ \ \/\ \ \_\ \_ \_\ \_/\  __//\ \L\ \ \ \//\ \L\ \__/\ \L\ \\/ __ \/\____`\ 
    \ \_\ \_\/\____\/\____\ \____\ \____ \ \_\\ \____/\_\ \  __//\____/\/\____/
     \/_/\/_/\/____/\/____/\/____/\/___L\ \/_/ \/___/\/_/\ \ \/ \/___/  \/___/
                                    /\____/               \ \_\
                                    \_/__/                 \/_/
 *
 *	Example that displays the text "Hello, world!" in the screen.
 *
 *	by �u�o Mart�nez <>
 *	from an example of Allegro Game Library by Shawn Hargreaves.
 *
 *	See readme.txt for license and copyright information.
 *)

{$H+}

USES
{ It needs some Allegro.pas units. }
  alcolor,  { Color manipulation. }
  aldraw,   { Drawing primitives. }
  algraph,  { Graphic mode configuration. }
  alkeybrd, { Keyboard input. }
  alpalete, { Color palette manipulation. }
  alsystem, { System initialization. }
  altext;   { Text drawing. }



BEGIN { The program starts here. }

{ You should always do this at the start of Allegro programs. }
  IF al_init <> 0 THEN
    EXIT;

{ Set up the keyboard handler. }
  al_install_keyboard;

{ Set a graphics mode sized 320x200. }
  IF (al_set_gfx_mode (AL_GFX_AUTODETECT, 320, 200, 0, 0) <> 0) THEN
    IF (al_set_gfx_mode (AL_GFX_SAFE, 320, 200, 0, 0) <> 0) THEN
    BEGIN
      al_set_gfx_mode (AL_GFX_TEXT, 0, 0, 0, 0);
    { Show an error message. }
      al_message (al_error);
    { Shutdown Allegro.  You should do it because it isn't automatic. }
      al_exit;
      EXIT;
    END;

{ Set the color palette. }
  al_set_palette (al_desktop_palette^);

{ Clear the screen to white. }
  al_clear_to_color (al_screen, al_makecol (255, 255, 255));

{ You don't need to do this, but on some platforms (eg. Windows) things will be
  drawn more quickly if you always acquire the screen before trying to draw
  onto it. }
  al_acquire_screen;

{ Write some text to the screen with black letters and transparent background. }
  al_textout_centre_ex (al_screen, al_font^, 'Hello, world!',
			al_SCREEN_W DIV 2, al_SCREEN_H DIV 2,
			al_makecol (0, 0, 0), -1);

{ You must always release bitmaps before calling any input functions. }
  al_release_screen;

{ Wait until a key is pressed. }
  al_readkey;

{ Shutdown Allegro.  You should do it because it isn't automatic. }
  al_exit;

{ End of the program. }
END.


UNIT config;
(* Program: Demo game for the Allegro.pas library.
 * Description: Manages the game configuration.
 *		It's a good idea to keep all the configuration values at the
 *		same place.
 * Author: �u�o Mart�nez <niunio@users.sourceforge.net>
 *)

{$H+}

INTERFACE



VAR
(* Variables containing the configuration. *)
  DoIntro: BOOLEAN; { Shows the intro animation? }
  ScaleSc: DOUBLE; { Scale factor of the game screen. }
  Cheat: BOOLEAN = FALSE;  { If true, the game is too much easy. }
  FullScreen: BOOLEAN; { If false, windowed. }



(* GetConfiguration:
 *   Gets the configuration values and puts them in its variables. *)
PROCEDURE GetConfiguration;



IMPLEMENTATION

USES
  alconfig, { Use of configuration files (INI style). }
  alfile;  { File manipulation. }



(* GetConfiguration:
 *   Gets the configuration values and puts them in its variables. *)
PROCEDURE GetConfiguration;
VAR
  Path: STRING;
  Cnt: INTEGER;
BEGIN
{ Set an additional config data file which is in the current directory.  So,
  get the executable path (returned by PARAMSTR (0)) and replace the filename
  with the configuration's one. }
  al_replace_filename (Path, PARAMSTR (0), 'demo.cfg', 256);
{ Now we can override the file. }
  al_override_config_file (Path);
{ Load the configuration values.  Note: Allegro gets some values from the
  configuration file for internal purposes.  Read the documentation. }
  DoIntro := (al_get_config_int ('', 'jumpstart', 0) = 0);
  FullScreen := (al_get_config_int ('graphics', 'fullscreen', 1) <> 0);
{ Check the command line parameters. }
  FOR Cnt := 1 TO PARAMCOUNT DO
  BEGIN
    IF PARAMSTR (Cnt) = '-jumpstart' THEN
      DoIntro := FALSE
    ELSE IF PARAMSTR (Cnt) = '-cheat' THEN
      Cheat := TRUE
    ELSE IF PARAMSTR (Cnt) = '-windowed' THEN
      FullScreen := FALSE
    ELSE IF PARAMSTR (Cnt) = '-fullscreen' THEN
      FullScreen := TRUE;
  END;
END;



END.

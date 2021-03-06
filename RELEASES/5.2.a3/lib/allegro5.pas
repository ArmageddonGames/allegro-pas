UNIT Allegro5;
(*<Wrapper of the Allegro 5 core library.

  This unit defines core functions, procedures and data types, that aren't in
  add-ons. *)
(* Copyright (c) 2012-2017 Guillermo Martínez J. <niunio@users.sourceforge.net>

  This software is provided 'as-is', without any express or implied
  warranty. In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
 *)

{ There are a lot of unfinished stuff.  Some times I've wrote that "I'll do"
   something.  In most cases "I" means "me or somebody else".  Since this is
   free open source you (or anybody) can add or improve this unit in any way.
   If you do it, please let me know and I would add it to the next release! }

{$include allegro5.cfg}

INTERFACE

  USES
    al5base;

  CONST
  (* @exclude Builds library name. *)
    ALLEGRO_LIB_NAME = _A5_LIB_PREFIX_+'allegro'+_DBG_+_A5_LIB_EXT_;

{ The code is distributed in sections, each one wraps a header file.

  Order of sections is the same as C loads them by including the "allegro.h"
  header file.

  Most documentation is at file srcdoc/allegro5.pds.  Eventually all
  documentation will be moved to that file. }

(*
 * base.h
 *      Defines basic stuff needed by pretty much everything else.
 *
 *      By Shawn Hargreaves.
 *****************************************************************************)

  CONST
  (* Allegro.pas version string. *)
    ALLEGRO_PAS_VERSION_STR = 'Allegro.pas 5.2.a3';

  (* Major version of Allegro. *)
    ALLEGRO_VERSION      =   5;
  (* Minor version of Allegro. *)
    ALLEGRO_SUB_VERSION  =   2;
  (* Revision number of Allegro. *)
    ALLEGRO_WIP_VERSION  =   0;
  (* Not sure we need it, but ALLEGRO_VERSION_STR contains it:
     0 = SVN
     1 = first release
     2... = hotfixes?

     Note x.y.z (= x.y.z.0) has release number 1, and x.y.z.1 has release
     number 2, just to confuse you. *)
    ALLEGRO_RELEASE_NUMBER = 1;
  (* Packs version number in a simple AL_INT number. *)
    ALLEGRO_VERSION_INT  = (
	   (ALLEGRO_VERSION SHL 24)
	OR (ALLEGRO_SUB_VERSION SHL 16)
	OR (ALLEGRO_WIP_VERSION SHL  8)
	OR  ALLEGRO_RELEASE_NUMBER
    );
  (* Just to be sure that PI number is available. *)
    ALLEGRO_PI = 3.14159265358979323846;

  TYPE
  (* Description of user main function for @link(al_run_main). *)
    ALLEGRO_USER_MAIN = FUNCTION (argc: AL_INT; argv: AL_POINTER): AL_INT; CDECL;

  FUNCTION al_get_allegro_version: AL_UINT32;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_run_main (argc: AL_INT; argv: AL_POINTER; user_main: ALLEGRO_USER_MAIN): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  FUNCTION AL_ID (CONST str: SHORTSTRING): AL_INT;



(*
 * altime.h
 *****************************************************************************)

  TYPE
  (* Represents a timeout value.

     The size of the structure is known so it can be statically allocated.  The
     contents are private. @seealso(al_init_timeout) *)
    ALLEGRO_TIMEOUT = RECORD
      __pad1__, __pad2__: AL_UINT64;
    END;


  (* Returns the number of seconds since the Allegro library was initialised.
     The return value is undefined if Allegro is uninitialised. The resolution
     depends on the used driver, but typically can be in the order of
     microseconds. *)
    FUNCTION al_get_time: AL_DOUBLE;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  (* Waits for the specified number of seconds. *)
    PROCEDURE al_rest (seconds: AL_DOUBLE);
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  (* Set timeout value of some number of seconds after the function call.

     For compatibility with all platforms, seconds must be 2,147,483.647
     seconds or less.
     @seealso(ALLEGRO_TIMEOUT) @seealso(al_wait_for_event_until) *)
    PROCEDURE al_init_timeout (OUT timeout: ALLEGRO_TIMEOUT; seconds: AL_DOUBLE);
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * color.h
 *****************************************************************************)

  TYPE
  (* An @code(ALLEGRO_COLOR) structure describes a color in a device independant
     way.  Use @link(al_map_rgb) et al. and @link(al_unmap_rgb) et al. to
     translate from and to various color representations. *)
    ALLEGRO_COLOR = RECORD
    (* Color component. *)
      r, g, b, a: AL_FLOAT;
    END;
  (* Pixel formats. *)
    ALLEGRO_PIXEL_FORMAT = (
    (* Let the driver choose a format. This is the default format at program
       start. *)
      ALLEGRO_PIXEL_FORMAT_ANY = 0,
    (* Let the driver choose a format without alpha. *)
      ALLEGRO_PIXEL_FORMAT_ANY_NO_ALPHA = 1,
    (* Let the driver choose a format with alpha. *)
      ALLEGRO_PIXEL_FORMAT_ANY_WITH_ALPHA = 2,
    (* Let the driver choose a 15 bit format without alpha. *)
      ALLEGRO_PIXEL_FORMAT_ANY_15_NO_ALPHA = 3,
    (* Let the driver choose a 16 bit format without alpha. *)
      ALLEGRO_PIXEL_FORMAT_ANY_16_NO_ALPHA = 4,
    (* Let the driver choose a 16 bit format with alpha. *)
      ALLEGRO_PIXEL_FORMAT_ANY_16_WITH_ALPHA = 5,
    (* Let the driver choose a 24 bit format without alpha. *)
      ALLEGRO_PIXEL_FORMAT_ANY_24_NO_ALPHA = 6,
    (* Let the driver choose a 32 bit format without alpha. *)
      ALLEGRO_PIXEL_FORMAT_ANY_32_NO_ALPHA = 7,
    (* Let the driver choose a 32 bit format with alpha. *)
      ALLEGRO_PIXEL_FORMAT_ANY_32_WITH_ALPHA = 8,
    (* 32 bit *)
      ALLEGRO_PIXEL_FORMAT_ARGB_8888 = 9,
    (* 32 bit *)
      ALLEGRO_PIXEL_FORMAT_RGBA_8888 = 10,
    (* 24 bit *)
      ALLEGRO_PIXEL_FORMAT_ARGB_4444 = 11,
    (* 24 bit *)
      ALLEGRO_PIXEL_FORMAT_RGB_888 = 12,
    (* 16 bit *)
      ALLEGRO_PIXEL_FORMAT_RGB_565 = 13,
    (* 15 bit *)
      ALLEGRO_PIXEL_FORMAT_RGB_555 = 14,
    (* 16 bit *)
      ALLEGRO_PIXEL_FORMAT_RGBA_5551 = 15,
    (* 16 bit *)
      ALLEGRO_PIXEL_FORMAT_ARGB_1555 = 16,
    (* 32 bit *)
      ALLEGRO_PIXEL_FORMAT_ABGR_8888 = 17,
    (* 32 bit *)
      ALLEGRO_PIXEL_FORMAT_XBGR_8888 = 18,
    (* 24 bit *)
      ALLEGRO_PIXEL_FORMAT_BGR_888 = 19,
    (* 16 bit *)
      ALLEGRO_PIXEL_FORMAT_BGR_565 = 20,
    (* 15 bit *)
      ALLEGRO_PIXEL_FORMAT_BGR_555 = 21,
    (* 32 bit *)
      ALLEGRO_PIXEL_FORMAT_RGBX_8888 = 22,
    (* 32 bit *)
      ALLEGRO_PIXEL_FORMAT_XRGB_8888 = 23,
    (* 128 bit *)
      ALLEGRO_PIXEL_FORMAT_ABGR_F32 = 24,
    (* Like the version without _LE, but the component order is guaranteed to
       be red, green, blue, alpha. This only makes a difference on big endian
       systems, on little endian it is just an alias. *)
      ALLEGRO_PIXEL_FORMAT_ABGR_8888_LE = 25,
    (* 16bit *)
      ALLEGRO_PIXEL_FORMAT_RGBA_4444  = 26,
      ALLEGRO_PIXEL_FORMAT_SINGLE_CHANNEL_8 = 27,
      ALLEGRO_PIXEL_FORMAT_COMPRESSED_RGBA_DXT1 = 28,
      ALLEGRO_PIXEL_FORMAT_COMPRESSED_RGBA_DXT3 = 29,
      ALLEGRO_PIXEL_FORMAT_COMPRESSED_RGBA_DXT5 = 30,
      ALLEGRO_NUM_PIXEL_FORMATS
    );

(* Convert r, g, b (ranging from 0-255) into an @link(ALLEGRO_COLOR), using 255
   for alpha.
   @seealso(al_map_rgba) @seealso(al_map_rgba_f) @seealso(al_map_rgb_f) *)
  FUNCTION al_map_rgb (r, g, b: AL_UCHAR): ALLEGRO_COLOR;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Convert r, g, b, a (ranging from 0-255) into an @link(ALLEGRO_COLOR).
   @seealso(al_map_rgb) @seealso(al_map_rgba_f) @seealso(al_map_rgb_f) *)
  FUNCTION al_map_rgba (r, g, b, a: AL_UCHAR): ALLEGRO_COLOR;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Convert r, g, b (ranging from 0.0f-1.0f) into an @link(ALLEGRO_COLOR), using
   1.0f for alpha.
   @seealso(al_map_rgba) @seealso(al_map_rgba_f) @seealso(al_map_rgb) *)
  FUNCTION al_map_rgb_f (r, g, b: AL_FLOAT): ALLEGRO_COLOR;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Convert r, g, b, a (ranging from 0.0f-1.0f) into an @link(ALLEGRO_COLOR).
   @seealso(al_map_rgba) @seealso(al_map_rgba_f) @seealso(al_map_rgb) *)
  FUNCTION al_map_rgba_f (r, g, b, a: AL_FLOAT): ALLEGRO_COLOR;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_premul_rgba (r, g, b: AL_UCHAR): ALLEGRO_COLOR;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_premul_rgba_f (r, g, b: AL_FLOAT): ALLEGRO_COLOR;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Retrieves components of an @link(ALLEGRO_COLOR), ignoring alpha.  Components
   will range from 0-255.
   @seealso(al_unmap_rgba) @seealso(al_unmap_rgba_f) @seealso(al_unmap_rgb_f) *)
  PROCEDURE al_unmap_rgb (color: ALLEGRO_COLOR; OUT r, g, b: AL_UCHAR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Retrieves components of an @link(ALLEGRO_COLOR).  Components will range from
   0-255.
   @seealso(al_unmap_rgba) @seealso(al_unmap_rgba_f) @seealso(al_unmap_rgb_f) *)
  PROCEDURE al_unmap_rgba (color: ALLEGRO_COLOR; OUT r, g, b, a: AL_UCHAR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Retrieves components of an @link(ALLEGRO_COLOR), ignoring alpha.  Components
   will range from 0.0f-1.0f.
   @seealso(al_unmap_rgba) @seealso(al_unmap_rgba_f) @seealso(al_unmap_rgb_f) *)
  PROCEDURE al_unmap_rgb_f (color: ALLEGRO_COLOR; OUT r, g, b: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Retrieves components of an @link(ALLEGRO_COLOR).  Components will range from
   0.0f-1.0f.
   @seealso(al_unmap_rgba) @seealso(al_unmap_rgba_f) @seealso(al_unmap_rgb_f) *)
  PROCEDURE al_unmap_rgba_f (color: ALLEGRO_COLOR; OUT r, g, b, a: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

(* Return the number of bytes that a pixel of the given format occupies.  For
   blocked pixel formats (e.g. compressed formats), this returns 0.
   @seealso(ALLEGRO_PIXEL_FORMAT) @seealso(al_get_pixel_format_bits) *)
  FUNCTION al_get_pixel_size (format: ALLEGRO_PIXEL_FORMAT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Return the number of bits that a pixel of the given format occupies.  For
   blocked pixel formats (e.g. compressed formats), this returns 0.
   @seealso(ALLEGRO_PIXEL_FORMAT) @seealso(al_get_pixel_size) *)
  FUNCTION al_get_pixel_format_bits (format: ALLEGRO_PIXEL_FORMAT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Return the number of bytes that a block of pixels with this format occupies.
   @seealso(ALLEGRO_PIXEL_FORMAT)
   @seealso(al_get_pixel_block_width) @seealso(al_get_pixel_block_height) *)
  FUNCTION al_get_pixel_block_size (format: ALLEGRO_PIXEL_FORMAT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Return the width of the pixel block of this format.
   @seealso(ALLEGRO_PIXEL_FORMAT)
   @seealso(al_get_pixel_block_size) @seealso(al_get_pixel_block_height) *)
  FUNCTION al_get_pixel_block_width (format: ALLEGRO_PIXEL_FORMAT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Return the height of the pixel block of this format.
   @seealso(ALLEGRO_PIXEL_FORMAT)
   @seealso(al_get_pixel_block_width) @seealso(al_get_pixel_block_size) *)
  FUNCTION al_get_pixel_block_height (format: ALLEGRO_PIXEL_FORMAT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * bitmap.h
 *****************************************************************************)

  TYPE
  (* Abstract type representing a bitmap (2D image). *)
    ALLEGRO_BITMAPptr = AL_POINTER;

  CONST
  (* Bitmap flags.  Documented at al_set_new_bitmap_flags. *)
    ALLEGRO_MEMORY_BITMAP            = $0001; {<@exclude }
    _ALLEGRO_KEEP_BITMAP_FORMAT      = $0002; {<@exclude }
    ALLEGRO_FORCE_LOCKING            = $0004; {<@exclude }
    ALLEGRO_NO_PRESERVE_TEXTURE      = $0008; {<@exclude }
    _ALLEGRO_ALPHA_TEST              = $0010; {<@exclude }
    _ALLEGRO_INTERNAL_OPENGL         = $0020; {<@exclude }
    ALLEGRO_MIN_LINEAR               = $0040; {<@exclude }
    ALLEGRO_MAG_LINEAR               = $0080; {<@exclude }
    ALLEGRO_MIPMAP                   = $0100; {<@exclude }
    _ALLEGRO_NO_PREMULTIPLIED_ALPHA  = $0200; {<@exclude }
    ALLEGRO_VIDEO_BITMAP             = $0400; {<@exclude }

(* Sets the pixel format for newly created bitmaps.  The default format is
   @code(ALLEGRO_PIXEL_FORMAT_ANY) and means the display driver will choose the
   best format.
   @seealso(ALLEGRO_PIXEL_FORMAT) @seealso(al_get_new_bitmap_format)
   @seealso(al_get_bitmap_format) *)
  PROCEDURE al_set_new_bitmap_format (format: ALLEGRO_PIXEL_FORMAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_set_new_bitmap_flags (flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the format used for newly created bitmaps.
   @seealso(ALLEGRO_PIXEL_FORMAT) @seealso(al_set_new_bitmap_format) *)
  FUNCTION al_get_new_bitmap_format: ALLEGRO_PIXEL_FORMAT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the flags used for newly created bitmaps.
   @seealso(al_set_new_bitmap_flags) *)
  FUNCTION al_get_new_bitmap_flags: AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* A convenience function which does the same as @longcode(#
  al_set_new_bitmap_flags (al_get_new_bitmap_flags OR flag);
#)
   @seealso(al_set_new_bitmap_flags) @seealso(al_get_new_bitmap_flags)
   @seealso(al_get_bitmap_flags) *)
  PROCEDURE al_add_new_bitmap_flag (flag: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Returns the width of a bitmap in pixels. *)
  FUNCTION al_get_bitmap_width (bitmap: ALLEGRO_BITMAPptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the height of a bitmap in pixels. *)
  FUNCTION al_get_bitmap_height (bitmap: ALLEGRO_BITMAPptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the pixel format of a bitmap.
   @seealso(ALLEGRO_PIXEL_FORMAT) @seealso(al_set_new_bitmap_flags) *)
  FUNCTION al_get_bitmap_format (bitmap: ALLEGRO_BITMAPptr): ALLEGRO_PIXEL_FORMAT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the flags user to create the bitmap.
   @seealso(al_set_new_bitmap_flags) *)
  FUNCTION al_get_bitmap_flags (bitmap: ALLEGRO_BITMAPptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  FUNCTION al_create_bitmap (w, h: AL_INT): ALLEGRO_BITMAPptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Destroys the given bitmap, freeing all resources used by it. Does nothing if
   given the null pointer. *)
  PROCEDURE al_destroy_bitmap (Bitmap: ALLEGRO_BITMAPptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  PROCEDURE al_put_pixel (x, y: AL_INT; color: ALLEGRO_COLOR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Like @link(al_put_pixel), but the pixel color is blended using the current
   blenders before being drawn. *)
  PROCEDURE al_put_blended_pixel (x, y: AL_INT; color: ALLEGRO_COLOR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Get a pixel's color value from the specified bitmap.  This operation is slow
   on non-memory bitmaps.  Consider locking the bitmap if you are going to use
   this function multiple times on the same bitmap.
   @seealso(al_put_pixel) @seealso(al_lock_bitmap) *)
  FUNCTION al_get_pixel (bitmap: ALLEGRO_BITMAPptr; x, y: AL_INT): ALLEGRO_COLOR;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Converts the given mask color to an alpha channel in the bitmap.  Can be used
   to convert older 4.2-style bitmaps with magic pink to alpha-ready bitmaps. *)
  PROCEDURE al_convert_mask_to_alpha (bitmap: ALLEGRO_BITMAPptr; mask_color: ALLEGRO_COLOR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Sets the region of the target bitmap or display that pixels get clipped to.
   The default is to clip pixels to the entire bitmap.
  @seealso(al_get_clipping_rectangle) @seealso(al_reset_clipping_rectangle) *)
  PROCEDURE al_set_clipping_rectangle (x, y, width, height: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Equivalent to calling @code(al_set_clipping_rectangle @(0, 0, w, h@)) where
   w and h are the width and height of the target bitmap respectively.

   Does nothing if there is no target bitmap.
   @seealso(al_set_clipping_rectangle) *)
  PROCEDURE al_reset_clipping_rectangle;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Gets the clipping rectangle of the target bitmap.
  @seealso(al_set_clipping_rectangle) *)
  PROCEDURE al_get_clipping_rectangle (OUT x, y, w, h: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  FUNCTION al_create_sub_bitmap (parent: ALLEGRO_BITMAPptr; x, y, w, h: AL_INT): ALLEGRO_BITMAPptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns true if the specified bitmap is a sub-bitmap, false otherwise.
  @seealso(al_create_sub_bitmap) @seealso(al_get_parent_bitmap) *)
  FUNCTION al_is_sub_bitmap (bitmap: ALLEGRO_BITMAPptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_parent_bitmap (bitmap: ALLEGRO_BITMAPptr): ALLEGRO_BITMAPptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* For a sub-bitmap, return it's x position within the parent.
  @seealso(al_create_sub_bitmap) @seealso(al_get_parent_bitmap)
  @seealso(al_get_bitmap_y) *)
  FUNCTION al_get_bitmap_x (bitmap: ALLEGRO_BITMAPptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* For a sub-bitmap, return it's y position within the parent.
  @seealso(al_create_sub_bitmap) @seealso(al_get_parent_bitmap)
  @seealso(al_get_bitmap_x) *)
  FUNCTION al_get_bitmap_y (bitmap: ALLEGRO_BITMAPptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_reparent_bitmap (bitmap, parent: ALLEGRO_BITMAPptr; x, y, w, h: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



  FUNCTION al_clone_bitmap (bitmap: ALLEGRO_BITMAPptr): ALLEGRO_BITMAPptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_convert_bitmap (bitmap: ALLEGRO_BITMAPptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_convert_memory_bitmap;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * bitmap_draw.h
 *****************************************************************************)

  CONST
  (* Flags for the blitting functions.  Documented at al_draw_bitmap. *)
    ALLEGRO_FLIP_HORIZONTAL = $00001; {<@exclude }
    ALLEGRO_FLIP_VERTICAL   = $00002; {<@exclude }

  PROCEDURE al_draw_bitmap (bitmap: ALLEGRO_BITMAPptr; dx, dy: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_draw_bitmap_region (bitmap: ALLEGRO_BITMAPptr; sx, sy, sw, sh, dx, dy: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_draw_scaled_bitmap (bitmap: ALLEGRO_BITMAPptr; sx, sy, sw, sh, dx, dy, dw, dh: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_draw_rotated_bitmap (bitmap: ALLEGRO_BITMAPptr; cx, cy, dx, dy, angle: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_draw_scaled_rotated_bitmap (bitmap: ALLEGRO_BITMAPptr; cx, cy, dx, dy, xscale, yscale, angle: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  PROCEDURE al_draw_tinted_bitmap (bitmap: ALLEGRO_BITMAPptr; tint: ALLEGRO_COLOR; dx, dy: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Like @link(al_draw_bitmap_region) but multiplies all colors in the bitmap
   with the given color. @seealso(al_draw_tinted_bitmap) *)
  PROCEDURE al_draw_tinted_bitmap_region (bitmap: ALLEGRO_BITMAPptr; tint: ALLEGRO_COLOR; sx, sy, sw, sh, dx, dy: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Like @link(al_draw_scaled_bitmap) but multiplies all colors in the bitmap
   with the given color. @seealso(al_draw_tinted_bitmap) *)
  PROCEDURE al_draw_tinted_scaled_bitmap (bitmap: ALLEGRO_BITMAPptr; tint: ALLEGRO_COLOR; sx, sy, sw, sh, dx, dy, dw, dh: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Like @link(al_draw_rotated_bitmap) but multiplies all colors in the bitmap
   with the given color. @seealso(al_draw_tinted_bitmap) *)
  PROCEDURE al_draw_tinted_rotated_bitmap (bitmap: ALLEGRO_BITMAPptr; tint: ALLEGRO_COLOR; cx, cy, dx, dy, angle: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_draw_tinted_scaled_rotated_bitmap (bitmap: ALLEGRO_BITMAPptr; tint: ALLEGRO_COLOR; cx, cy, dx, dy, xscale, yscale, angle: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_draw_tinted_scaled_rotated_bitmap_region (bitmap: ALLEGRO_BITMAPptr; sx, sy, sw, sh: AL_FLOAT; tint: ALLEGRO_COLOR; cx, cy, dx, dy, xscale, yscale, angle: AL_FLOAT; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * path.h
 *****************************************************************************)

{ TODO:
  Actually, this header is needed by Allegro to build file paths,
  but at the moment I'll not add it. }



(*
 * utf8.h
 *****************************************************************************)

  {TODO: Documentation says it's not needed as it's used internally.
	Only basic functionality is implemented for convenience.

	Use of WIDESTRING and UTFSTRING is recommendable. }
  {TODO: There are a lot of stuff to add here. }

  TYPE
  (* @exclude *)
    _al_tagbstring = RECORD
      mlen, slen: AL_INT;
      data: AL_VOIDptr;
    END;
  (* Pointer to @link(ALLEGRO_USTR). *)
    ALLEGRO_USTRptr = ^ALLEGRO_USTR;
  (* An opaque type representing a string. @code(ALLEGRO_USTR)s normally
     contain UTF-8 encoded strings, but they may be used to hold any byte
     sequences, including @nil. *)
    ALLEGRO_USTR = _al_tagbstring;
  (* Pointer to @link(ALLEGRO_USTR_INFO). *)
    ALLEGRO_USTR_INFOptr = ^ALLEGRO_USTR_INFO;
  (* A type that holds additional information for an @link(ALLEGRO_USTR) that
     references an external memory buffer.
     @seealso(al_ref_cstr) @seealso(al_ref_buffer) @seealso(al_ref_ustr) *)
    ALLEGRO_USTR_INFO = _al_tagbstring;

(* Creates a new string containing a copy of the C-style string @code(s). The
   string must eventually be freed with @link(al_ustr_free).
   @seealso(al_ustr_new_from_buffer)
   @seealso(al_ustr_dup) @seealso(al_ustr_new_from_utf16) *)
  FUNCTION al_ustr_new (CONST s: AL_STR): ALLEGRO_USTRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Creates a new string containing a copy of the buffer pointed to by @code(s)
   of the given size in bytes. The string must eventually be freed with
   @link(al_ustr_free). @seealso(al_ustr_new) *)
  FUNCTION al_ustr_new_from_buffer (CONST s: AL_STRptr; size: AL_SIZE_T): ALLEGRO_USTRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Frees a previously allocated string. Does nothing if the argument is @nil.
   @seealso(al_ustr_new) @seealso(al_ustr_new_from_buffer) *)
  PROCEDURE al_ustr_free (us: ALLEGRO_USTRptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_cstr (CONST us: ALLEGRO_USTRptr): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Writes the contents of the string into a pre-allocated buffer of the given
   size in bytes. The result will always be @code(NUL) terminated, so a maximum
   of @code(size - 1) bytes will be copied.
   @seealso(al_cstr) @seealso(al_cstr_dup) *)
  PROCEDURE al_ustr_to_buffer (CONST us: ALLEGRO_USTRptr; buffer: AL_STRptr; size: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_cstr_dup (CONST us: ALLEGRO_USTRptr): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns a duplicate copy of a string. The new string will need to be freed
   with @code(al_ustr_free).
   @seealso(al_ustr_dup_substr) @seealso(al_ustr_free) *)
  FUNCTION al_ustr_dup (CONST us: ALLEGRO_USTRptr): ALLEGRO_USTRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_ustr_dup_substr (CONST us: ALLEGRO_USTRptr; start_pos, end_pos: AL_INT): ALLEGRO_USTRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Predefined string *)
  FUNCTION al_ustr_empty_string: ALLEGRO_USTRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



  FUNCTION al_ref_cstr (OUT info: ALLEGRO_USTR_INFO; CONST s: AL_STR): ALLEGRO_USTRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_ref_buffer (OUT info: ALLEGRO_USTR_INFO; CONST s: AL_STRptr;
      size: AL_SIZE_T): ALLEGRO_USTRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_ref_ustr (OUT info: ALLEGRO_USTR_INFO;
      CONST us: ALLEGRO_USTRptr; star_pos, end_pos: AL_INT): ALLEGRO_USTRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Sizes and offsets *)
  FUNCTION al_ustr_size (CONST us: ALLEGRO_USTRptr): AL_SIZE_T;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_ustr_length (CONST us: ALLEGRO_USTRptr): AL_SIZE_T;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_ustr_offset (CONST us: ALLEGRO_USTRptr;index: AL_INT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_ustr_next (CONST us: ALLEGRO_USTRptr; VAR aPos: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_ustr_prev (CONST us: ALLEGRO_USTRptr; VAR aPos: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;


(* Assign *)
  FUNCTION al_ustr_assign (us1: ALLEGRO_USTRptr; CONST us2: ALLEGRO_USTRptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_ustr_assign_cstr (us1: ALLEGRO_USTRptr; CONST s: AL_STR): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Compare *)
  FUNCTION al_ustr_equal (CONST us1, us2: ALLEGRO_USTRptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_ustr_compare (CONST u, v: ALLEGRO_USTRptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_ustr_ncompare (CONST u, v: ALLEGRO_USTRptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * file.h
 *****************************************************************************)

  TYPE
  (* An opaque object representing an open file. This could be a real file on
     disk or a virtual file. *)
    ALLEGRO_FILEptr = AL_POINTER;

  (* Pointer to @link(ALLEGRO_FILE_INTERFACE). *)
    ALLEGRO_FILE_INTERFACEptr = ^ALLEGRO_FILE_INTERFACE;
    ALLEGRO_FILE_INTERFACE = RECORD
      fi_open: FUNCTION (CONST path, mode: AL_STR): AL_POINTER; CDECL;
      fi_fclose: FUNCTION (handle: ALLEGRO_FILEptr): AL_BOOL; CDECL;
      fi_fread: FUNCTION (f: ALLEGRO_FILEptr; ptr: AL_POINTER; size: AL_SIZE_T): AL_SIZE_T; CDECL;
      fi_fwrite: FUNCTION (f: ALLEGRO_FILEptr; CONST ptr: AL_POINTER; size: AL_SIZE_T): AL_SIZE_T; CDECL;
      fi_fflush: FUNCTION (f: ALLEGRO_FILEptr): AL_BOOL; CDECL;
      fi_ftell: FUNCTION (f: ALLEGRO_FILEptr): AL_INT64; CDECL;
      fi_fseek: FUNCTION (f: ALLEGRO_FILEptr; offset: AL_INT64; whence: AL_INT): AL_BOOL; CDECL;
      fi_feof: FUNCTION (f: ALLEGRO_FILEptr): AL_BOOL; CDECL;
      fi_ferror: FUNCTION (f: ALLEGRO_FILEptr): AL_INT; CDECL;
      fi_ferrmsg: FUNCTION (f: ALLEGRO_FILEptr): AL_STRptr; CDECL;
      fi_fclearerr: PROCEDURE (f: ALLEGRO_FILEptr); CDECL;
      fi_fungetc: FUNCTION (f: ALLEGRO_FILEptr; c: AL_INT): AL_INT; CDECL;
      fi_fsize: FUNCTION (f: ALLEGRO_FILEptr): AL_OFF_T; CDECL;
    END;

  CONST
  { @exclude May be these should be an enum. }
    ALLEGRO_SEEK_SET = 0; (*<Seek relative to beginning of file. *)
    ALLEGRO_SEEK_CUR = 1; (*<Seek relative to current file position. *)
    ALLEGRO_SEEK_END = 2; (*<Seek relative to end of file. *)

    FUNCTION al_fopen (CONST path, mode: AL_STR): ALLEGRO_FILEptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Opens a file using the specified interface, instead of the interface set
     with @link(al_set_new_file_interface). @seealso(al_fopen) *)
    FUNCTION al_fopen_interface (
      CONST vt: ALLEGRO_FILE_INTERFACEptr; CONST path, mode: AL_STR
    ): ALLEGRO_FILEptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Creates an empty, opened file handle with some abstract user data. This
     allows custom interfaces to extend the @link(ALLEGRO_FILEptr) struct with
     their own data. You should close the handle with the standard
     @link(al_fclose) function when you are finished with it.
     @seealso(al_fopen) @seealso(al_fclose) @seealso(al_set_new_file_interface)
   *)
    FUNCTION al_create_file_handle (
      CONST vt: ALLEGRO_FILE_INTERFACEptr; userdata: AL_POINTER
    ): ALLEGRO_FILEptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Close the given file, writing any buffered output data (if any).
     @return(@true on success, @false on failure.) *)
    FUNCTION al_fclose (f: ALLEGRO_FILEptr): AL_BOOL;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Read @code(size) bytes into the buffer pointed to by @code(ptr), from the
     given file.
     @return(The number of bytes actually read. If an error occurs, or the
      end-of-file is reached, the return value is a short byte count @(or
      zero@).

      @code(al_fread) does not distinguish between EOF and other errors. Use
      @link(al_feof) and @link(al_ferror) to determine which occurred.)
     @seealso(al_fgetc) @seealso(al_fread16be) @seealso(al_fread16le)
     @seealso(al_fread32be) @seealso(al_fread32le) *)
    FUNCTION al_fread
      (f: ALLEGRO_FILEptr; ptr: AL_POINTER; size: AL_SIZE_T): AL_SIZE_T;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Write @code(size) bytes from the buffer pointed to by @code(ptr) into the
     given file.

     @return(The number of bytes actually written. If an error occurs,the
      return value is a short byte count @(or zero@).)
     @seealso(al_fputc) @seealso(al_fputs) @seealso(al_fwrite16be)
     @seealso(al_fwrite16le) @seealso(al_fwrite32be) @seealso(al_fwrite32le) *)
    FUNCTION al_fwrite
      (f: ALLEGRO_FILEptr; CONST ptr: AL_POINTER; size: AL_SIZE_T): AL_SIZE_T;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Flush any pending writes to the given file.
     @return(@true on success, @false otherwise.)
     @seealso(al_get_errno) *)
    FUNCTION al_fflush (f: ALLEGRO_FILEptr): AL_BOOL;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Returns the current position in the given file, or @code(-1) on error.

     On some platforms this function may not support large files.
     @seealso(al_fseek) @seealso(al_get_errno) *)
    FUNCTION al_ftell (f: ALLEGRO_FILEptr): AL_INT64;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
    FUNCTION al_fseek
      (f: ALLEGRO_FILEptr; offset: AL_INT64; whence: AL_INT): AL_BOOL;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Returns @true if the end-of-file indicator has been set on the file, i.e.
     we have attempted to read past the end of the file.

     This does not return @true if we simply are at the end of the file. The
     following code correctly reads two bytes, even when the file contains
     exactly two bytes:
@longcode(#
  b1 := al_fgetc (f);
  b2 := al_fgetc (f);
  IF al_feof (f) THEN
  // At least one byte was unsuccessfully read.
    ReportError ();
#)
     @seealso(al_ferror) @seealso(al_fclearerr) *)
    FUNCTION al_feof (f: ALLEGRO_FILEptr): AL_BOOL;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Returns non-zero if the error indicator is set on the given file, i.e.
     there was some sort of previous error. The error code may be system or
     file interface specific.
     @seealso(al_feof) @seealso(al_fclearerr) @seealso(al_ferrmsg) *)
    FUNCTION al_ferror (f: ALLEGRO_FILEptr): AL_INT;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Returns a message string with details about the last error that occurred
     on the given file handle. The returned string is empty if there was no
     error, or if the file interface does not provide more information.
     @seealso(al_fclearerr) @seealso(al_ferror) *)
    FUNCTION al_ferrmsg (f: ALLEGRO_FILEptr): AL_STRptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Clears the error indicator for the given file.

     The standard I/O backend also clears the end-of-file indicator, and other
     backends should try to do this. However, they may not if it would require
     too much effort (e.g. PhysicsFS backend), so your code should not rely on
      it if you need your code to be portable to other backends.
     @seealso(al_ferror) @seealso(al_feof) *)
    PROCEDURE al_fclearerr (f: ALLEGRO_FILEptr);
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
    FUNCTION al_fungetc (f: ALLEGRO_FILEptr; c: AL_INT): AL_INT;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Returns the size of the file, if it can be determined, or @code(-1)
     otherwise. *)
    FUNCTION al_fsize (f: ALLEGRO_FILEptr): AL_INT64;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  (* Reads and returns next byte in the given file. Returns a negative number
     on end of file or if an error occurred.
     @seealso(al_fungetc) *)
    FUNCTION al_fgetc (f: ALLEGRO_FILEptr): AL_INT;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Writes a single byte to the given file. The byte written is the value of
     @code(c) cast to an unsigned char.
     @param(c byte value to write.)
     @param(f file to write to.)
     @return(the written byte @(cast back to an @link(AL_INT)@) on success, or
       negative number on error.) *)
    FUNCTION al_fputc (f: ALLEGRO_FILEptr; c: AL_INT): AL_INT;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Reads a 16-bit word in little-endian format (LSB first).
     @return(On success, the 16-bit word. On failure, returns EOF @(-1@). Since
       -1 is also a valid return value, use @link(al_feof) to check if the end
       of the file was reached prematurely, or @link(al_ferror) to check if an
       error occurred.)
     @seealso(al_fread16be) *)
    FUNCTION al_fread16le (f: ALLEGRO_FILEptr): AL_INT16;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Reads a 16-bit word in big-endian format (MSB first).
     @return(On success, the 16-bit word. On failure, returns EOF @(-1@). Since
       -1 is also a valid return value, use @link(al_feof) to check if the end
       of the file was reached prematurely, or @link(al_ferror) to check if an
       error occurred.)
     @seealso(al_fread16le) *)
    FUNCTION al_fread16be (f: ALLEGRO_FILEptr): AL_INT16;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Writes a 16-bit word in little-endian format (LSB first).
     @return(The number of bytes written: 2 on success, less than 2 on an
       error.)
     @seealso(al_fwrite16be) *)
    FUNCTION al_fwrite16le (f: ALLEGRO_FILEptr; w: AL_INT16): AL_SIZE_T;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Writes a 16-bit word in big-endian format (MSB first).
     @return(The number of bytes written: 2 on success, less than 2 on an
       error.)
     @seealso(al_fwrite16le) *)
    FUNCTION al_fwrite16be (f: ALLEGRO_FILEptr; w: AL_INT16): AL_SIZE_T;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Reads a 32-bit word in little-endian format (LSB first).
     @return(On success, the 32-bit word. On failure, returns EOF @(-1@). Since
       -1 is also a valid return value, use @link(al_feof) to check if the end
       of the file was reached prematurely, or @link(al_ferror) to check if an
       error occurred.)
     @seealso(al_fread32be) *)
    FUNCTION al_fread32le (f: ALLEGRO_FILEptr): AL_INT32;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Reads a 32-bit word in big-endian format (MSB first).
     @return(On success, the 32-bit word. On failure, returns EOF @(-1@). Since
       -1 is also a valid return value, use @link(al_feof) to check if the end
       of the file was reached prematurely, or @link(al_ferror) to check if an
       error occurred.)
     @seealso(al_fread32le) *)
   FUNCTION al_fread32be (f: ALLEGRO_FILEptr): AL_INT32;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Writes a 32-bit word in little-endian format (LSB first).
     @return(The number of bytes written: 2 on success, less than 2 on an
       error.)
     @seealso(al_fwrite32be) *)
    FUNCTION al_fwrite32le (f: ALLEGRO_FILEptr; l: AL_INT32): AL_SIZE_T;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Writes a 32-bit word in big-endian format (MSB first).
     @return(The number of bytes written: 2 on success, less than 2 on an
       error.)
     @seealso(al_fwrite32le) *)
    FUNCTION al_fwrite32be (f: ALLEGRO_FILEptr; l: AL_INT32): AL_SIZE_T;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
    FUNCTION al_fgets
      (f: ALLEGRO_FILEptr; CONST p: AL_STRptr; max: AL_SIZE_T): AL_STRptr
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Read a string of bytes terminated with a newline or end-of-file. The line
     terminator(s), if any, are included in the returned string.

     See @link(al_fopen) about translations of end-of-line characters.
     @return(On success a pointer to a new @link(ALLEGRO_USTR) structure. This
      must be freed eventually with @link(al_ustr_free). Returns @nil if an
      error occurred or if the end of file was reached without reading any
      bytes.)
     @seealso(al_fgetc) @seealso(al_fgets) *)
    FUNCTION al_fget_ustr (f: ALLEGRO_FILEptr): ALLEGRO_USTRptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Writes a string to file. Apart from the return value, this is equivalent
     to @code(@link(al_fwrite) @(f, p, Length @(p@)@);)

     @bold(Note:) depending on the stream type and the mode passed to
     @link(al_fopen), newline characters in the string may or may not be
     automatically translated to native end-of-line sequences, e.g. @code(CR/LF)
     instead of @code(LF).
     @param(f File handle to write to.)
     @param(p String to write.)
     @returns(A non-negative integer on success, EOF (-1) on error.)
     @seealso(al_fwrite) *)
    FUNCTION al_fputs (f: ALLEGRO_FILEptr; CONST p: AL_STR): AL_INT;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;

{
/* Specific to stdio backend. */
AL_FUNC(ALLEGRO_FILE*, al_fopen_fd, (int fd, const char *mode));
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
    FUNCTION al_make_temp_file (CONST tmpl: AL_STR; OUT ret_path: ALLEGRO_PATHptr): ALLEGRO_FILEptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
}

    FUNCTION al_fopen_slice (
      fp: ALLEGRO_FILEptr; initial_size: AL_SIZE_T; CONST mode: AL_STR
    ): ALLEGRO_FILEptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  (* Return a pointer to the @link(ALLEGRO_FILE_INTERFACEptr) table in effect
     for the calling thread.
     @seealso(al_store_state) @seealso(al_restore_state) *)
    FUNCTION al_get_new_file_interface: ALLEGRO_FILE_INTERFACEptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Sets the @link(ALLEGRO_FILE_INTERFACEptr) table for the calling thread.
     This will change the handler for later calls to @link(al_fopen).
     @seealso(al_set_standard_file_interface) @seealso(al_store_state)
     @seealso(al_restore_state) *)
    PROCEDURE al_set_new_file_interface
      (CONST file_interface: ALLEGRO_FILE_INTERFACEptr);
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Sets the @link(ALLEGRO_FILE_INTERFACEptr) table to the default, for the
     calling thread. This will change the handler for later calls to
     @link(al_fopen).
     @seealso(al_set_new_file_interface) *)
    PROCEDURE al_set_standard_file_interface;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  (* Returns a pointer to the custom userdata that is attached to the file
     handle. This is intended to be used by functions that extend
     @link(ALLEGRO_FILE_INTERFACEptr). *)
    FUNCTION al_get_file_userdata (f: ALLEGRO_FILEptr): AL_POINTER;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * bitmap_io.h
 *****************************************************************************)

{ TODO: Several functions aren't added yet. }

{ Bitmap loader flag }
  CONST
  { @exclude }
    ALLEGRO_KEEP_BITMAP_FORMAT     = $0002;
  { @exclude }
    ALLEGRO_NO_PREMULTIPLIED_ALPHA = $0200;
  { @exclude }
    ALLEGRO_KEEP_INDEX             = $0800;


  TYPE
  (* Used by @link(al_register_bitmap_loader). *)
    ALLEGRO_IIO_LOADER_FUNCTION = FUNCTION (CONST filename: AL_STR; flags: AL_INT): ALLEGRO_BITMAPptr; CDECL;
  (* Used by @link(al_register_bitmap_loader_f). *)
    ALLEGRO_IIO_FS_LOADER_FUNCTION = FUNCTION (fp: ALLEGRO_FILEptr; flags: AL_INT): ALLEGRO_BITMAPptr; CDECL;
  (* Used by @link(al_register_bitmap_saver). *)
    ALLEGRO_IIO_SAVER_FUNCTION = FUNCTION (CONST filename: AL_STR; bitmap: ALLEGRO_BITMAPptr): AL_BOOL; CDECL;
  (* Used by @link(al_register_bitmap_saver_f). *)
    ALLEGRO_IIO_FS_SAVER_FUNCTION = FUNCTION (fp: ALLEGRO_FILEptr; bitmap: ALLEGRO_BITMAPptr): AL_BOOL; CDECL;
  (* Used by @link(al_register_bitmap_identifier). *)
    ALLEGRO_IIO_IDENTIFIER_FUNCTION = FUNCTION (fp: ALLEGRO_FILEptr): AL_BOOL; CDECL;

  FUNCTION al_register_bitmap_loader
    (CONST ext: AL_STR; loader: ALLEGRO_IIO_LOADER_FUNCTION): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_register_bitmap_saver
    (CONST ext: AL_STR; saver: ALLEGRO_IIO_SAVER_FUNCTION): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_register_bitmap_loader_f
    (CONST ext: AL_STR; fs_loader: ALLEGRO_IIO_FS_LOADER_FUNCTION): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_register_bitmap_saver_f
    (CONST ext: AL_STR; fs_saver: ALLEGRO_IIO_FS_SAVER_FUNCTION): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_register_bitmap_identifier
    (CONST ext: AL_STR; identifier: ALLEGRO_IIO_IDENTIFIER_FUNCTION): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
    
  FUNCTION al_load_bitmap (CONST filename: AL_STR): ALLEGRO_BITMAPptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_load_bitmap_flags (CONST filename: AL_STR; flags: AL_INT): ALLEGRO_BITMAPptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_load_bitmap_f
    (fp: ALLEGRO_FILEptr; CONST ident: AL_STRptr): ALLEGRO_BITMAPptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_load_bitmap_flags_f (
    fp: ALLEGRO_FILEptr; CONST ident: AL_STR; flags: AL_INT
  ): ALLEGRO_BITMAPptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_save_bitmap (CONST filename: AL_STR; bitmap: ALLEGRO_BITMAPptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_save_bitmap_f (
    fp: ALLEGRO_FILEptr; CONST ident: AL_STR; bitmap: ALLEGRO_BITMAPptr
  ): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_identify_bitmap_f (fp: ALLEGRO_FILEptr): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_identify_bitmap (CONST filename: AL_STR): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * bitmap_lock.h
 *****************************************************************************)

  CONST
  (* Locking flags. Documented at al_lock_bitmap. *)
  { @exclude }
    ALLEGRO_LOCK_READWRITE  = 0;
  { @exclude }
    ALLEGRO_LOCK_READONLY   = 1;
  { @exclude }
    ALLEGRO_LOCK_WRITEONLY  = 2;

  TYPE
  (* Pointer to @link(ALLEGRO_LOCKED_REGION). *)
    ALLEGRO_LOCKED_REGIONptr = ^ALLEGRO_LOCKED_REGION;
  (* Users who wish to manually edit or read from a bitmap are required to lock
     it first.  The @code(ALLEGRO_LOCKED_REGION) structure represents the
     locked region of the bitmap.  This call will work with any bitmap,
     including memory bitmaps.
     @seealso(al_lock_bitmap) @seealso(al_lock_bitmap_region)
     @seealso(al_unlock_bitmap) @seealso(ALLEGRO_PIXEL_FORMAT) *)
    ALLEGRO_LOCKED_REGION = RECORD
    (* Points to the leftmost pixel of the first row (row 0) of the locked
       region. *)
      data: AL_VOIDptr;
    (* Indicates the pixel format of the data. *)
      format,
    (* Gives the size in bytes of a single row (also known as the stride).  The
       pitch may be greater than @code(width * pixel_size) due to padding; this
       is not uncommon.  It is also not uncommon for the pitch to be negative
       (the bitmap may be upside down). *)
      pitch,
    (* Number of bytes used to represent a single pixel. *)
      pixel_size: AL_INT;
    END;



 (* Lock an entire bitmap for reading or writing. If the bitmap is a display
    bitmap it will be updated from system memory after the bitmap is unlocked
    (unless locked read only).

    On some platforms, Allegro automatically backs up the contents of video
    bitmaps because they may be occasionally lost (see discussion in
    @link(al_create_bitmap)'s documentation). If you're completely recreating
    the bitmap contents often (e.g. every frame) then you will get much better
    performance by creating the target bitmap with
    @code(ALLEGRO_NO_PRESERVE_TEXTURE) flag.

    @bold(Note:) While a bitmap is locked, you can not use any drawing
    operations on it (with the sole exception of @link(al_put_pixel) and
    @link(al_put_blended_pixel)).
    @returns(@nil if the bitmap cannot be locked, e.g. the bitmap was locked
    previously and not unlocked. This function also returns @nil if the format
    is a compressed format.)
    @param(flags @unorderedlist(
      @item(@code(ALLEGRO_LOCK_READONLY) The locked region will not be written
        to. This can be faster if the bitmap is a video texture, as it can be
        discarded after the lock instead of uploaded back to the card.)
      @item(@code(ALLEGRO_LOCK_WRITEONLY) The locked region will not be read
        from. This can be faster if the bitmap is a video texture, as no data
        need to be read from the video card. You are required to fill in all
        pixels before unlocking the bitmap again, so be careful when using this
        flag.)
      @item(@code(ALLEGRO_LOCK_READWRITE) The locked region can be written to
        and read from. Use this flag if a partial number of pixels need to be
        written to, even if reading is not needed.)
    ))
    @param(format Indicates the pixel format that the returned buffer will be
      in. To lock in the same format as the bitmap stores its data internally,
      call with @code(al_get_bitmap_format @(bitmap@)) as the format or use
      @code(ALLEGRO_PIXEL_FORMAT_ANY). Locking in the native format will
      usually be faster. If the bitmap format is compressed, using
      @code(ALLEGRO_PIXEL_FORMAT_ANY) will choose an implementation defined
      non-compressed format.)
    @seealso(ALLEGRO_LOCKED_REGION) @seealso(ALLEGRO_PIXEL_FORMAT)
    @seealso(al_unlock_bitmap) @seealso(al_lock_bitmap_region)
    @seealso(al_lock_bitmap_blocked) @seealso(al_lock_bitmap_region_blocked) *)
  FUNCTION al_lock_bitmap (bitmap: ALLEGRO_BITMAPptr; format: ALLEGRO_PIXEL_FORMAT; flags: AL_INT): ALLEGRO_LOCKED_REGIONptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Like @link(al_lock_bitmap), but only locks a specific area of the bitmap. If
   the bitmap is a video bitmap, only that area of the texture will be updated
   when it is unlocked. Locking only the region you indend to modify will be
   faster than locking the whole bitmap.

   @bold(Note:) Using the @code(ALLEGRO_LOCK_WRITEONLY) with a blocked pixel
   format (i.e. formats for which @link(al_get_pixel_block_width) or
   @link(al_get_pixel_block_height) do not return 1) requires you to have the
   region be aligned to the block width for optimal performance. If it is not,
   then the function will have to lock the region with the
   @code(ALLEGRO_LOCK_READWRITE) instead in order to pad this region with
   valid data.
   @seealso(ALLEGRO_LOCKED_REGION) @seealso(ALLEGRO_PIXEL_FORMAT)
   @seealso(al_unlock_bitmap) *)
  FUNCTION al_lock_bitmap_region (bitmap: ALLEGRO_BITMAPptr; x, y, width, height: AL_INT; format: ALLEGRO_PIXEL_FORMAT; flags: AL_INT): ALLEGRO_LOCKED_REGIONptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Like @link(al_lock_bitmap), but allows locking bitmaps with a blocked pixel
   format (i.e. a format for which @link(al_get_pixel_block_width) or
   @link(al_get_pixel_block_height) do not return 1) in that format. To that
   end, this function also does not allow format conversion. For bitmap formats
   with a block size of 1, this function is identical to calling
   @code(al_lock_bitmap @(bmp, al_get_bitmap_format @(bmp@), flags@)).

   @bold(Note:) Currently there are no drawing functions that work when the
   bitmap is locked with a compressed format. @link(al_get_pixel) will also not
   work.
   @seealso(al_lock_bitmap) @seealso(al_lock_bitmap_region_blocked) *)
  FUNCTION al_lock_bitmap_blocked (bitmap: ALLEGRO_BITMAPptr; flags: AL_INT): ALLEGRO_LOCKED_REGIONptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Like @link(al_lock_bitmap_blocked), but allows locking a sub-region, for
   performance. Unlike @link(al_lock_bitmap_region) the region specified in
   terms of blocks and not pixels.
   @seealso(al_lock_bitmap_region) @seealso(al_lock_bitmap_blocked) *)
  FUNCTION al_lock_bitmap_region_blocked (bitmap: ALLEGRO_BITMAPptr; x_block, y_block, width_block, height_block, flags: AL_INT): ALLEGRO_LOCKED_REGIONptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(*Unlock a previously locked bitmap or bitmap region. If the bitmap is a video
  bitmap, the texture will be updated to match the system memory copy (unless
  it was locked read only).
  @seealso(al_lock_bitmap) @seealso(al_lock_bitmap_region)
  @seealso(al_lock_bitmap_blocked) @seealso(al_lock_bitmap_region_blocked) *)
  PROCEDURE al_unlock_bitmap (bitmap: ALLEGRO_BITMAPptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns whether or not a bitmap is already locked.
   @seealso(al_lock_bitmap) @seealso(al_lock_bitmap_region)
   @seealso(al_unlock_bitmap) *)
  FUNCTION al_is_bitmap_locked (bitmap: ALLEGRO_BITMAPptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * blender.h
 *****************************************************************************)

  TYPE
  (* Blending modes. @seealso(al_set_blender) *)
    ALLEGRO_BLEND_MODE = (
      ALLEGRO_ZERO                = 0,
      ALLEGRO_ONE                 = 1,
      ALLEGRO_ALPHA               = 2,
      ALLEGRO_INVERSE_ALPHA       = 3,
      ALLEGRO_SRC_COLOR           = 4,
      ALLEGRO_DEST_COLOR          = 5,
      ALLEGRO_INVERSE_SRC_COLOR   = 6,
      ALLEGRO_INVERSE_DEST_COLOR  = 7,
      ALLEGRO_CONST_COLOR         = 8,
      ALLEGRO_INVERSE_CONST_COLOR = 9,
      ALLEGRO_NUM_BLEND_MODES
    );



  (* Blending modes. @seealso(al_set_blender) *)
    ALLEGRO_BLEND_OPERATIONS = (
      ALLEGRO_ADD                  = 0,
      ALLEGRO_SRC_MINUS_DEST       = 1,
      ALLEGRO_DEST_MINUS_SRC       = 2,
      ALLEGRO_NUM_BLEND_OPERATIONS
    );


(* Sets the function to use for blending for the current thread.

   Blending means, the source and destination colors are combined in drawing
   operations.

   Assume the source color (e.g. color of a rectangle to draw, or pixel of a
   bitmap to draw) is given as its red/green/blue/alpha components (if the
   bitmap has no alpha it always is assumed to be fully opaque, so 255 for
   8-bit or 1.0 for floating point): @italic(s = s.r, s.g, s.b, s.a). And this
   color is drawn to a destination, which already has a color:
   @italic(d = d.r, d.g, d.b, d.a).

   The conceptional formula used by Allegro to draw any pixel then depends on
   the op parameter:
   @unorderedlist(
   @item(@code(ALLEGRO_ADD)
@longcode(#
     r = d.r * df.r + s.r * sf.r
     g = d.g * df.g + s.g * sf.g
     b = d.b * df.b + s.b * sf.b
     a = d.a * df.a + s.a * sf.a
#))
    @item(@code(ALLEGRO_DEST_MINUS_SRC)
@longcode(#
     r = d.r * df.r - s.r * sf.r
     g = d.g * df.g - s.g * sf.g
     b = d.b * df.b - s.b * sf.b
     a = d.a * df.a - s.a * sf.a
#))
    @item(@code(ALLEGRO_SRC_MINUS_DEST)
@longcode(#
     r = s.r * sf.r - d.r * df.r
     g = s.g * sf.g - d.g * df.g
     b = s.b * sf.b - d.b * df.b
     a = s.a * sf.a - d.a * df.a
#))
    )
    Valid values for the factors @italic(sf) and @italic(df) passed to this
    function are as follows, where @italic(s) is the source color, @italic(d)
    the destination color and @italic(cc) the color set with
    @link(al_set_blend_color) (white by default)
    @unorderedlist(
    @item(@bold(ALLEGRO_ZERO) @code(f = 0, 0, 0, 0))
    @item(@bold(ALLEGRO_ONE) @code(f = 1, 1, 1, 1))
    @item(@bold(ALLEGRO_ALPHA) @code(f = s.a, s.a, s.a, s.a))
    @item(@bold(ALLEGRO_INVERSE_ALPHA) @code(f = 1 - s.a, 1 - s.a, 1 - s.a, 1 - s.a))
    @item(@bold(ALLEGRO_SRC_COLOR) @code(f = s.r, s.g, s.b, s.a))
    @item(@bold(ALLEGRO_DEST_COLOR) @code(f = d.r, d.g, d.b, d.a))
    @item(@bold(ALLEGRO_INVERSE_SRC_COLOR) @code(f = 1 - s.r, 1 - s.g, 1 - s.b, 1 - s.a))
    @item(@bold(ALLEGRO_INVERSE_DEST_COLOR) @code(f = 1 - d.r, 1 - d.g, 1 - d.b, 1 - d.a))
    @item(@bold(ALLEGRO_CONST_COLOR) @code(f = cc.r, cc.g, cc.b, cc.a))
    @item(@bold(ALLEGRO_INVERSE_CONST_COLOR) @code(f = 1 - cc.r, 1 - cc.g, 1 - cc.b, 1 - cc.a))
    )
    So for example, to restore the default of using premultiplied alpha
    blending, you would use:
@longcode(#
al_set_blender (ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
#)
    As formula:
@longcode(#
r = d.r * (1 - s.a) + s.r * 1
g = d.g * (1 - s.a) + s.g * 1
b = d.b * (1 - s.a) + s.b * 1
a = d.a * (1 - s.a) + s.a * 1
#)
    If you are using non-pre-multiplied alpha, you could use
@longcode(#
al_set_blender(ALLEGRO_ADD, ALLEGRO_ALPHA, ALLEGRO_INVERSE_ALPHA);
#)
    Additive blending would be achieved with
@longcode(#
al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ONE);
#)
    Copying the source to the destination (including alpha) unmodified
@longcode(#
al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO);
#)
    Multiplying source and destination components
@longcode(#
al_set_blender(ALLEGRO_ADD, ALLEGRO_DEST_COLOR, ALLEGRO_ZERO)
#)
    Tinting the source (like @link(al_draw_tinted_bitmap))
@longcode(#
al_set_blender(ALLEGRO_ADD, ALLEGRO_CONST_COLOR, ALLEGRO_ONE);
al_set_blend_color(al_map_rgb(0, 96, 255)); /* nice Chrysler blue */
#)
    Averaging source and destination pixels
@longcode(#
al_set_blender(ALLEGRO_ADD, ALLEGRO_CONST_COLOR, ALLEGRO_CONST_COLOR);
al_set_blend_color(al_map_rgba_f(0.5, 0.5, 0.5, 0.5));
#)
    As formula:
@longcode(#
r = d.r * 0 + s.r * d.r
g = d.g * 0 + s.g * d.g
b = d.b * 0 + s.b * d.b
a = d.a * 0 + s.a * d.a
#)
   @seealso(al_set_separate_blender) @seealso(al_set_blend_color)
   @seealso(al_get_blender) *)
  PROCEDURE al_set_blender (op: ALLEGRO_BLEND_OPERATIONS; source, dest: ALLEGRO_BLEND_MODE);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Sets the color to use for blending when using the @code(ALLEGRO_CONST_COLOR)
   or @code(ALLEGRO_INVERSE_CONST_COLOR) blend functions. See
   @link(al_set_blender) for more information.
   @seealso(al_set_blender) @seealso(al_get_blend_color) *)
  PROCEDURE al_set_blend_color (color: ALLEGRO_COLOR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the active blender for the current thread.
   @seealso(al_set_blender) @seealso(al_get_separate_blender) *)
  PROCEDURE al_get_blender (OUT op: ALLEGRO_BLEND_OPERATIONS; OUT source, dest: ALLEGRO_BLEND_MODE);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the color currently used for constant color blending (white by
   default).
   @seealso(al_set_blend_color) @seealso(al_set_blender) *)
  FUNCTION al_get_blend_color: ALLEGRO_COLOR;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Like @code(al_set_blender), but allows specifying a separate blending
   operation for the alpha channel. This is useful if your target bitmap also
   has an alpha channel and the two alpha channels need to be combined in a
   different way than the color components.
   @seealso(al_set_blender) @seealso(al_get_blender)
   @seealso(al_get_separate_blender) *)
  PROCEDURE al_set_separate_blender (op: ALLEGRO_BLEND_OPERATIONS; source, dest: ALLEGRO_BLEND_MODE;
				     alpha_op: ALLEGRO_BLEND_OPERATIONS; alpha_source, alpha_dest: ALLEGRO_BLEND_MODE);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_get_separate_blender (OUT op: ALLEGRO_BLEND_OPERATIONS; OUT source, dest: ALLEGRO_BLEND_MODE;
				     OUT alpha_op: ALLEGRO_BLEND_OPERATIONS; OUT alpha_source, alpha_dest: ALLEGRO_BLEND_MODE);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * events.h
 *)

  TYPE
  (* An integer used to distinguish between different types of events.
     @seealso(ALLEGRO_EVENT) @seealso(ALLEGRO_GET_EVENT_TYPE)
     @seealso(ALLEGRO_EVENT_TYPE_IS_USER) *)
    ALLEGRO_EVENT_TYPE = AL_UINT;

  CONST
    {@exclude}
    ALLEGRO_EVENT_JOYSTICK_AXIS          = 1;
    {@exclude}
    ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN   = 2;
    {@exclude}
    ALLEGRO_EVENT_JOYSTICK_BUTTON_UP     = 3;
    {@exclude}
    ALLEGRO_EVENT_JOYSTICK_CONFIGURATION = 4;

    {@exclude}
    ALLEGRO_EVENT_KEY_DOWN               = 10;
    {@exclude}
    ALLEGRO_EVENT_KEY_CHAR               = 11;
    {@exclude}
    ALLEGRO_EVENT_KEY_UP                 = 12;

    {@exclude}
    ALLEGRO_EVENT_MOUSE_AXES             = 20;
    {@exclude}
    ALLEGRO_EVENT_MOUSE_BUTTON_DOWN      = 21;
    {@exclude}
    ALLEGRO_EVENT_MOUSE_BUTTON_UP        = 22;
    {@exclude}
    ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY    = 23;
    {@exclude}
    ALLEGRO_EVENT_MOUSE_LEAVE_DISPLAY    = 24;
    {@exclude}
    ALLEGRO_EVENT_MOUSE_WARPED           = 25;

    {@exclude}
    ALLEGRO_EVENT_TIMER                  = 30;

    {@exclude}
    ALLEGRO_EVENT_DISPLAY_EXPOSE         = 40;
    {@exclude}
    ALLEGRO_EVENT_DISPLAY_RESIZE         = 41;
    {@exclude}
    ALLEGRO_EVENT_DISPLAY_CLOSE          = 42;
    {@exclude}
    ALLEGRO_EVENT_DISPLAY_LOST           = 43;
    {@exclude}
    ALLEGRO_EVENT_DISPLAY_FOUND          = 44;
    {@exclude}
    ALLEGRO_EVENT_DISPLAY_SWITCH_IN      = 45;
    {@exclude}
    ALLEGRO_EVENT_DISPLAY_SWITCH_OUT     = 46;
    {@exclude}
    ALLEGRO_EVENT_DISPLAY_ORIENTATION    = 47;
    {@exclude}
    ALLEGRO_EVENT_DISPLAY_HALT_DRAWING   = 48;
    {@exclude}
    ALLEGRO_EVENT_DISPLAY_RESUME_DRAWING = 49;

    {@exclude}
    ALLEGRO_EVENT_TOUCH_BEGIN            = 50;
    {@exclude}
    ALLEGRO_EVENT_TOUCH_END              = 51;
    {@exclude}
    ALLEGRO_EVENT_TOUCH_MOVE             = 52;
    {@exclude}
    ALLEGRO_EVENT_TOUCH_CANCEL           = 53;

    {@exclude}
    ALLEGRO_EVENT_DISPLAY_CONNECTED      = 60;
    {@exclude}
    ALLEGRO_EVENT_DISPLAY_DISCONNECTED   = 61;

(* Returns @true if the event type is not a builtin event type, i.e. one of
   those described in @link(ALLEGRO_EVENT_TYPE).*)
  FUNCTION ALLEGRO_EVENT_TYPE_IS_USER (t: ALLEGRO_EVENT_TYPE): AL_BOOL; INLINE;

(* Makes an event type identifier, which is a 32-bit integer. Usually, but not
   necessarily, this will be made from four 8-bit character codes, for example:
@longcode(#
  MY_EVENT_TYPE := ALLEGRO_GET_EVENT_TYPE ('MINE');
#)
   IDs less than 1024 are reserved for Allegro or its addons. Don't use
   anything lower than @code(ALLEGRO_GET_EVENT_TYPE @(#0#0#4#0@)).

   You should try to make your IDs unique so they don't clash with any 3rd
   party code you may be using. Be creative. Numbering from 1024 is not
   creative.

   If you need multiple identifiers, you could define them like this:
@longcode(#
  BASE_EVENT := ALLEGRO_GET_EVENT_TYPE ('MINE');
  BARK_EVENT := BASE_EVENT + 1;
  MEOW_EVENT := BASE_EVENT + 2;
  SQUAWK_EVENT := BASE_EVENT + 3;
#)
  @seealso(ALLEGRO_EVENT) @seealso(ALLEGRO_USER_EVENT)
  @seealso(ALLEGRO_EVENT_TYPE_IS_USER) *)
  FUNCTION ALLEGRO_GET_EVENT_TYPE (CONST str: SHORTSTRING): AL_INT; INLINE;


  TYPE
  (* Pointer to a display.

     An opaque type representing an open display or window. *)
    ALLEGRO_DISPLAYptr = AL_POINTER;
  (* A pointer to an abstract data representing a physical joystick.
     @seealso(al_get_joystick) *)
    ALLEGRO_JOYSTICKptr = AL_POINTER;
  (* Pointer to keyboard. *)
    ALLEGRO_KEYBOARDptr = AL_POINTER;
  (* Pointer to mouse. *)
    ALLEGRO_MOUSEptr = AL_POINTER;
  (* Pointer to timer. *)
    ALLEGRO_TIMERptr = AL_POINTER;


  (* Pointer to @link(ALLEGRO_EVENT_SOURCE). *)
    ALLEGRO_EVENT_SOURCEptr = ^ALLEGRO_EVENT_SOURCE;
  (* An event source is any object which can generate events.  For example, an
     @link(ALLEGRO_DISPLAYptr) can generate events, and you can get the
     @code(ALLEGRO_EVENT_SOURCE) pointer from an @code(ALLEGRO_DISPLAYptr) with
     @link(al_get_display_event_source).

     You may create your own "user" event sources that emit custom events.
     @seealso(ALLEGRO_EVENT) @seealso(al_init_user_event_source)
     @seealso(al_emit_user_event)
   *)
    ALLEGRO_EVENT_SOURCE = RECORD
      __pad : ARRAY [0..31] OF AL_INT;
    END;


  (* Contains the common information about events.
     @seealso(ALLEGRO_EVENT) *)
    ALLEGRO_ANY_EVENT = RECORD
    (* Indicates the type of event. *)
      _type: ALLEGRO_EVENT_TYPE;
    (* The event source which generated the event. *)
      source: ALLEGRO_EVENT_SOURCEptr;
    (* When the event was generated. *)
      timestamp: AL_DOUBLE;
    END;

  (* Contains display events information.
     @seealso(ALLEGRO_EVENT) *)
    ALLEGRO_DISPLAY_EVENT = RECORD
    (* Indicates the type of event. *)
      _type: ALLEGRO_EVENT_TYPE;
    (* The display that generated the event. *)
      source: ALLEGRO_DISPLAYptr;
    (* When the event was generated. *)
      timestamp: AL_DOUBLE;
    (* The top-left corner of the rectangle which was exposed or the position
       of the top-level corner of the display. *)
      x, y: AL_INT;
    (* The width and height of the rectangle which was exposed or the new size
       of the display. *)
      width, height: AL_INT;
    (* Contains one of the following values:@unorderedlist(
       @item(@bold(@code(ALLEGRO_DISPLAY_ORIENTATION_0_DEGREES)))
       @item(@bold(@code(ALLEGRO_DISPLAY_ORIENTATION_90_DEGREES)))
       @item(@bold(@code(ALLEGRO_DISPLAY_ORIENTATION_180_DEGREES)))
       @item(@bold(@code(ALLEGRO_DISPLAY_ORIENTATION_270_DEGREES)))
       @item(@bold(@code(ALLEGRO_DISPLAY_ORIENTATION_FACE_UP)))
       @item(@bold(@code(ALLEGRO_DISPLAY_ORIENTATION_FACE_DOWN)))
       )*)
      orientation: AL_INT;
    END;

  (* Contains the joystick events information.
     @seealso(ALLEGRO_EVENT) *)
    ALLEGRO_JOYSTICK_EVENT = RECORD
    (* Indicates the type of event. *)
      _type: ALLEGRO_EVENT_TYPE;
    (* The joystick which generated the event. *)
      source: ALLEGRO_JOYSTICKptr;
    (* When the event was generated. *)
      timestamp: AL_DOUBLE;
    (* The joystick which generated the event. This is not the same as the
      event source. *)
      id: ALLEGRO_JOYSTICKptr;
    (* The stick number, counting from zero. Axes on a joystick are grouped
      into "sticks". *)
      stick: AL_INT;
    (* The axis number on the stick, counting from zero. *)
      axis: AL_INT;
    (* The axis position, from -1.0 to +1.0. *)
      pos: AL_FLOAT;
    (* The button which was pressed, counting from zero. *)
      button: AL_INT;
    END;

  (* Contains the keyboard events information.
     @seealso(ALLEGRO_EVENT) *)
    ALLEGRO_KEYBOARD_EVENT = RECORD
    (* Indicates the type of event. *)
      _type: ALLEGRO_EVENT_TYPE;
    (* The keyboard which generated the event. *)
      source: ALLEGRO_KEYBOARDptr;
    (* When the event was generated. *)
      timestamp: AL_DOUBLE;
    (* The display which had keyboard focus when the event occurred. *)
      display: ALLEGRO_DISPLAYptr;
    (* The code corresponding to the physical key which was pressed or
       released. See the @link(Keyboard) section for the list of
       @code(ALLEGRO_KEY_* ) constants. *)
      keycode: AL_INT;
    (* A Unicode code point (character). This may be zero or negative if the
       event was generated for a non-visible "character", such as an arrow or
       Function key. In that case you can act upon the keycode field.

       Some special keys will set the unichar field to their standard ASCII
       values: Tab=9, Return=13, Escape=27. In addition if you press the
       Control key together with A to Z the unichar field will have the values
       1 to 26. For example Ctrl-A will set unichar to 1 and Ctrl-H will set it
       to 8.

       As of Allegro 5.0.2 there are some inconsistencies in the treatment of
       Backspace (8 or 127) and Delete (127 or 0) keys on different platforms.
       These can be worked around by checking the keycode field. *)
      unichar: AL_INT;
    (* This is a bitfield of the modifier keys which were pressed when the
       event occurred. See @link(Keyboard modifier flags) for the constants. *)
      modifiers: AL_UINT;
    (* Indicates if this is a repeated character. *)
      _repeat: AL_BOOL;
    END;

  (* Contains the mouse events information.
     @seealso(ALLEGRO_EVENT) *)
    ALLEGRO_MOUSE_EVENT = RECORD
    (* Indicates the type of event. *)
      _type: ALLEGRO_EVENT_TYPE;
    (* The mouse which generated the event. *)
      source: ALLEGRO_MOUSEptr;
    (* When the event was generated. *)
      timestamp: AL_DOUBLE;
    (* The display which had mouse focus. *)
      display: ALLEGRO_DISPLAYptr;
    (* x-coordinate. *)
      x,
    (* y-coordinate. *)
      y,
    (* z-coordinate. This usually means the vertical axis of a mouse wheel,
      where up is positive and down is negative. *)
      z,
    (* w-coordinate. This usually means the horizontal axis of a mouse wheel. *) 
      w: AL_INT;
    (* Change in the coordinates value since the previous
       @code(ALLEGRO_EVENT_MOUSE_AXES) event. *)
      dx, dy, dz, dw: AL_INT;
    (* The mouse button which was pressed or released, numbering from 1. *)
      button: AL_UINT;
    (* Pressure, ranging from 0.0 to 1.0. *)
      pressure: AL_FLOAT;
    END;

  (* Contains the timer events information.
     @seealso(ALLEGRO_EVENT) *)
    ALLEGRO_TIMER_EVENT = RECORD
    (* Indicates the type of event. *)
      _type: ALLEGRO_EVENT_TYPE;
    (* The timer which generated the event. *)
      source: ALLEGRO_TIMERptr;
    (* When the event was generated. *)
      timestamp: AL_DOUBLE;
    (* The timer count value. *)
      count: AL_INT64;
    { @exclude undocumented (?) }
      error: AL_DOUBLE;
    END;

  (* Contains the touch input events information.
     @seealso(ALLEGRO_EVENT) *)
    ALLEGRO_TOUCH_EVENT = RECORD
    (* Indicates the type of event. *)
      _type: ALLEGRO_EVENT_TYPE;
    (* The event source which generated the event. *)
      source: AL_POINTER;
    (* When the event was generated. *)
      timestamp: AL_DOUBLE;
    (* The display which was touched.  *)
      display: AL_POINTER;
    (* An identifier for this touch. If supported by the device it will stay
       the same for events from the same finger until the touch ends. *)
      id: AL_INT;
    (* The coordinate of the touch in pixels. *)
      x, y: AL_DOUBLE;
    (* Movement speed in pixels. *)
      dx, dy: AL_DOUBLE;
    (* Whether this is the only/first touch or an additional touch. *)
      primary: AL_BOOL;
    END;

    ALLEGRO_USER_EVENT_DESCRIPTORptr = POINTER;

    ALLEGRO_USER_EVENTptr = ^ALLEGRO_USER_EVENT;
    ALLEGRO_USER_EVENT = RECORD
      _type : ALLEGRO_EVENT_TYPE;
      source : AL_POINTER;
      timestamp : AL_DOUBLE;
      __internal__descr : ALLEGRO_USER_EVENT_DESCRIPTORptr;
      data1 : AL_POINTER;
      data2 : AL_POINTER;
      data3 : AL_POINTER;
      data4 : AL_POINTER;
    END;

  (* Pointer to @code(ALLEGRO_EVENT) *)
    ALLEGRO_EVENTptr = ^ALLEGRO_EVENT;
  (* An ALLEGRO_EVENT is an union of all builtin event structures, i.e. it is
     an object large enough to hold the data of any event type. All events have
     the following fields in common:
     @unorderedlist(
       @item(@bold(_type @(@link(ALLEGRO_EVENT_TYPE)@)) Indicates the type of
         event.)
       @item(@bold(any.source @(ALLEGRO_EVENT_SOURCEptr@)) The event source
         which generated the event.)
       @item(@bold(any.timestamp @(DOUBLE@)) When the event was generated.)
     )
     By examining the type field you can then access type-specific fields. The
     @code(any.source) field tells you which event source generated that
     particular event. The @code(any.timestamp) field tells you when the event
     was generated. The time is referenced to the same starting point as
     @link(al_get_time).

     Each event is of one of the following types, with the usable fields given.
     @unorderedlist(
       @item(@bold(@code(ALLEGRO_EVENT_JOYSTICK_AXIS)) A joystick axis value
         changed.)
       @item(@bold(@code(ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN)) A joystick button
         was pressed.)
       @item(@bold(@code(ALLEGRO_EVENT_JOYSTICK_BUTTON_UP)) A joystick button
         was released.)
       @item(@bold(@code(ALLEGRO_EVENT_JOYSTICK_CONFIGURATION)) A joystick was
         plugged in or unplugged. See @link(al_reconfigure_joysticks) for
	 details.)
       @item(@bold(@code(ALLEGRO_EVENT_KEY_DOWN)) A keyboard key was pressed.

        @bold(Note:) this event is about the physical keys being pressed on the
       	keyboard. Look for @code(ALLEGRO_EVENT_KEY_CHAR) events for character
       	input.)
       @item(@bold(@code(ALLEGRO_EVENT_KEY_UP)) A keyboard key was released.)
       @item(@bold(@code(ALLEGRO_EVENT_KEY_CHAR)) A character was typed on the
         keyboard, or a character was auto-repeated.
     
	 @bold(Note:) in many input methods, characters are not entered
	 one-for-one with physical key presses. Multiple key presses can
	 combine to generate a single character, e.g. apostrophe + e may
	 produce '�'. Fewer key presses can also generate more characters, e.g.
	 macro sequences expanding to common phrases.)
       @item(@bold(@code(ALLEGRO_EVENT_MOUSE_AXES)) One or more mouse axis
         values changed.

         @bold(Note:) Calling @link(al_set_mouse_xy) also will result in a
	 change of axis values, but such a change is reported with
	 @code(ALLEGRO_EVENT_MOUSE_WARPED) events instead which are identical
	 except for their type.

         Note: currently @code(mouse.display) may be @nil if an event is
	 generated in response to al_set_mouse_axis.)
       @item(@bold(@code(ALLEGRO_EVENT_MOUSE_BUTTON_DOWN)) A mouse button was
         pressed.)
       @item(@bold(@code(ALLEGRO_EVENT_MOUSE_BUTTON_UP)) A mouse button was
         released.)
       @item(@bold(@code(ALLEGRO_EVENT_MOUSE_WARPED)) @link(al_set_mouse_xy)
         was called to move the mouse. This event is identical to
	 @code(ALLEGRO_EVENT_MOUSE_AXES) otherwise.)
       @item(@bold(@code(ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY)) The mouse cursor
         entered a window opened by the program.)
       @item(@bold(@code(ALLEGRO_EVENT_MOUSE_LEAVE_DISPLAY)) The mouse cursor
         left the boundaries of a window opened by the program.)
       @item(@bold(@code(ALLEGRO_EVENT_TOUCH_BEGIN)) The touch input device
         registered a new touch.)
       @item(@bold(@code(ALLEGRO_EVENT_TOUCH_END)) A touch ended.)
       @item(@bold(@code(ALLEGRO_EVENT_TOUCH_MOVE)) The position of a touch
         changed.)
       @item(@bold(@code(ALLEGRO_EVENT_TOUCH_CANCEL)) A touch was cancelled.
         This is device specific but could for example mean that a finger moved
	 off the border of the device or moved so fast that it could not be
	 tracked any longer.)
       @item(@bold(@code(ALLEGRO_EVENT_TIMER)) A timer counter incremented.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_EXPOSE)) The display @(or a
	 portion thereof@) has become visible.

         @bold(Note:) The display needs to be created with
	 @code(ALLEGRO_GENERATE_EXPOSE_EVENTS) flag for these events to be
	 generated.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_RESIZE)) The window has been resized.

         You should normally respond to these events by calling
	 @code(al_acknowledge_resize). Note that further resize events may be
	 generated by the time you process the event, so these fields may hold
	 outdated information.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_CLOSE)) The close button of the
         window has been pressed.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_LOST)) When using Direct3D,
         displays can enter a "lost" state. In that state, drawing calls are
	 ignored, and upon entering the state, bitmap's pixel data can become
	 undefined. Allegro does its best to preserve the correct contents of
	 bitmaps @(see the @code(ALLEGRO_NO_PRESERVE_TEXTURE) flag@) and
	 restore them when the device is "found" @(see
	 @code(ALLEGRO_EVENT_DISPLAY_FOUND)@). However, this is not 100% fool
	 proof @(see discussion in @link(al_create_bitmap)'s documentation@).

         @bold(Note:) This event merely means that the display was lost, that
	 is, DirectX suddenly lost the contents of all video bitmaps. In
	 particular, you can keep calling drawing functions -- they just most
	 likely won't do anything. If Allegro's restoration of the bitmaps
	 works well for you then no further action is required when you receive
	 this event.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_FOUND)) Generated when a lost
         device is restored to operating state. See
	 @code(ALLEGRO_EVENT_DISPLAY_LOST).)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_SWITCH_OUT)) The window is no
         longer active, that is the user might have clicked into another window
	 or "tabbed" away.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_SWITCH_IN)) The window is the
         active one again.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_ORIENTATION)) Generated when the
         rotation or orientation of a display changes.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_HALT_DRAWING)) When a display
         receives this event it should stop doing any drawing and then call
	 @link(al_acknowledge_drawing_halt) immediately.

         This is currently only relevant for Android and iOS. It will be sent
	 when the application is switched to background mode, in addition to
	 @code(ALLEGRO_EVENT_DISPLAY_SWITCH_OUT). The latter may also be sent
	 in situations where the application is not active but still should
	 continue drawing, for example when a popup is displayed in front of
	 it.

         @bold(Note:) This event means that the next time you call a drawing
         function, your program will crash. So you must stop drawing and you
	 must immediately reply with @link(al_acknowledge_drawing_halt).
	 Allegro sends this event because it cannot handle this automatically.
	 Your program might be doing the drawing in a different thread from the
	 event handling, in which case the drawing thread needs to be signaled
	 to stop drawing before acknowledging this event.

         @bold(Note:) Mobile devices usually never quit an application, so to
	 prevent the battery from draining while your application is halted it
	 can be a good idea to call @code(al_stop_timer) on all your timers,
	 otherwise they will keep generating events. If you are using audio,
	 you can also stop all audio voices @(or pass @nil to
	 @link(al_set_default_voice) if you use the default mixer@), otherwise
	 Allegro will keep streaming silence to the voice even if the stream or
	 mixer are stopped or detached.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_RESUME_DRAWING)) When a display
         receives this event, it may resume drawing again, and it must call
	 @link(al_acknowledge_drawing_resume) immediately.

         This is currently only relevant for Android and iOS. The event will be
	 sent when an application returns from background mode and is allowed
	 to draw to the display again, in addition to
	 @code(ALLEGRO_EVENT_DISPLAY_SWITCH_IN). The latter event may also be
	 sent in a situation where the application is already active, for
	 example when a popup in front of it closes.

         @bold(Note:) Unlike @code(ALLEGRO_EVENT_DISPLAY_FOUND) it is not
	 necessary to reload any bitmaps when you receive this event.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_CONNECTED)) This event is sent
         when a physical display is connected to the device Allegro runs on.
	 Currently, on most platforms, Allegro supports only a single physical
	 display. However, on iOS, a secondary physical display is suported.)
       @item(@bold(@code(ALLEGRO_EVENT_DISPLAY_DISCONNECTED)) This event is
         sent when a physical display is disconnected from the device Allegro
	 runs on. Currently, on most platforms, Allegro supports only a single
	 physical display. However, on iOS, a secondary physical display is
	 suported.)
     ) *)
    ALLEGRO_EVENT = RECORD
      case LONGINT OF
      (* The event type. *)
	0: ( _type: ALLEGRO_EVENT_TYPE );
      (* @code(any) is to allow the user to access the other fields which are
         common to all event types, without using some specific type structure.
       *)
	1: ( any: ALLEGRO_ANY_EVENT );
      (* Information of display events. *)
	2: ( display: ALLEGRO_DISPLAY_EVENT );
      (* Information of joysitck events. *)
	3: ( joystick: ALLEGRO_JOYSTICK_EVENT );
      (* Information of keyboard events. *)
	4: ( keyboard: ALLEGRO_KEYBOARD_EVENT );
      (* Information of mouse events. *)
	5: ( mouse: ALLEGRO_MOUSE_EVENT );
      (* Information of timer events. *)
	6: ( timer: ALLEGRO_TIMER_EVENT );
      (* Information of touch events. *)
        7: ( touch: ALLEGRO_TOUCH_EVENT );
      (* Information of user events. *)
	8: ( user: ALLEGRO_USER_EVENT );
      END;

    (* User event destructor. @seealso(al_emit_user_event) *)
      ALLEGRO_EVENT_DTOR_PROC = PROCEDURE (evt: ALLEGRO_USER_EVENTptr); CDECL;

(* Initialices an event source for emitting user events. The space for the event
   source must already have been allocated.

   One possible way of creating custom event sources is to derive other
   structures with @code(ALLEGRO_EVENT_SOURCE) at the head, e.g.
@longcode(#
TYPE
  THINGptr = ^THING;
  THING = RECORD
    event_source: ALLEGRO_EVENT_SOURCE;
    field1, field2: INTEGER;
    // etc.
  END;

FUNCTION CreateThing: THINGptr;
BEGIN
  RESULT := getmem (sizeof (THING));
  IF RESULT <> NIL THEN
  BEGIN
    al_init_user_event_source (@@(RESULT^.event_source));
    RESULT^.field1 := 0;
    RESULT^.field2 := 0;
  END
END;
#)

  The advantage here is that the @code(THING) pointer will be the same as the
  @code(ALLEGRO_EVENT_SOURCE) pointer. Events emitted by the event source will
  have the event source pointer as the source field, from which you can get a
  pointer to a @code(THING) by a simple cast (after ensuring checking the event
  is of the correct type).

  However, it is only one technique and you are not obliged to use it.

  The user event source will never be destroyed automatically. You must destroy
  it manually with @code(al_destroy_user_event_source).
  @seealso(ALLEGRO_EVENT_SOURCE) @seealso(al_destroy_user_event_source)
  @seealso(al_emit_user_event) @seealso(ALLEGRO_USER_EVENT) *)
  PROCEDURE al_init_user_event_source (source: ALLEGRO_EVENT_SOURCEptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Destroys an event source initialised with @link(al_init_user_event_source).

   This does not free the memory, as that was user allocated to begin with.
   @seealso(ALLEGRO_EVENT_SOURCE) *)
  PROCEDURE al_destroy_user_event_source (source: ALLEGRO_EVENT_SOURCEptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* The second argument is ALLEGRO_EVENT instead of ALLEGRO_USER_EVENT
 * to prevent users passing a pointer to a too-short structure.
 *)
  FUNCTION al_emit_user_event (
    source: ALLEGRO_EVENT_SOURCEptr; Event: ALLEGRO_EVENTptr;
    dtor: ALLEGRO_EVENT_DTOR_PROC
  ): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_unref_user_event (event: ALLEGRO_USER_EVENTptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_set_event_source_data (source: ALLEGRO_EVENT_SOURCEptr; data: AL_POINTER);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_event_source_data (CONST source: ALLEGRO_EVENT_SOURCEptr): AL_POINTER;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



  TYPE
    ALLEGRO_EVENT_QUEUEptr = AL_POINTER;

(* Creates a new, empty event queue.
   @return(A pointer to the newly created object if successful, @nil on error.)
   @seealso(al_register_event_source) @seealso(al_destroy_event_queue)
   @seealso(ALLEGRO_EVENT_QUEUEptr) *)
  FUNCTION al_create_event_queue: ALLEGRO_EVENT_QUEUEptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Destroys the event queue specified. All event sources currently registered
   with the queue will be automatically unregistered before the queue is
   destroyed.
   @seealso(al_create_event_queue) @seealso(ALLEGRO_EVENT_QUEUEptr) *)
  PROCEDURE al_destroy_event_queue (queue: ALLEGRO_EVENT_QUEUEptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_is_event_source_registered (queue: ALLEGRO_EVENT_QUEUEptr; source: ALLEGRO_EVENT_SOURCEptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Register the event source with the event queue specified. An event source
   may be registered with any number of event queues simultaneously, or none.
   Trying to register an event source with the same event queue more than once
   does nothing.
   @seealso(al_unregister_event_source) @seealso(ALLEGRO_EVENT_SOURCE) *)
  PROCEDURE al_register_event_source (queue: ALLEGRO_EVENT_QUEUEptr; source: ALLEGRO_EVENT_SOURCEptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_unregister_event_source (queue: ALLEGRO_EVENT_QUEUEptr; source: ALLEGRO_EVENT_SOURCEptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_pause_event_queue (queue: ALLEGRO_EVENT_QUEUEptr; pause: AL_BOOL);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_is_event_queue_paused (CONST queue: ALLEGRO_EVENT_QUEUEptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_is_event_queue_empty (queue: ALLEGRO_EVENT_QUEUEptr): AL_BOOL;
    CDECL;EXTERNAL ALLEGRO_LIB_NAME;
(* Takes the next event out of the event queue specified, and copy the contents
   into @code(ret_event), returning @true.  The original event will be removed
   from the queue.  If the event queue is empty, returns @false and the
   contents of @code(ret_event) are unspecified.
   @seealso(ALLEGRO_EVENT) @seealso(al_peek_next_event)
   @seealso(al_wait_for_event) *)
  FUNCTION al_get_next_event (queue: ALLEGRO_EVENT_QUEUEptr; OUT ret_event: ALLEGRO_EVENT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_peek_next_event (queue: ALLEGRO_EVENT_QUEUEptr; OUT ret_event: ALLEGRO_EVENT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_drop_next_event (queue: ALLEGRO_EVENT_QUEUEptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_flush_event_queue (queue: ALLEGRO_EVENT_QUEUEptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Wait until the event queue specified is non-empty. The first event in the
   queue will be copied into @code(ret_event) and removed from the queue.
   @seealso(ALLEGRO_EVENT) @seealso(al_wait_for_event_timed)
   @seealso(al_wait_for_event_until) @seealso(al_get_next_event) *)
  PROCEDURE al_wait_for_event (queue: ALLEGRO_EVENT_QUEUEptr; OUT ret_event: ALLEGRO_EVENT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_wait_for_event_timed (queue: ALLEGRO_EVENT_QUEUEptr; OUT event: ALLEGRO_EVENT; secs: AL_FLOAT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_wait_for_event_until (queue: ALLEGRO_EVENT_QUEUEptr; OUT event: ALLEGRO_EVENT; VAR timeout: ALLEGRO_TIMEOUT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * display.h
 *****************************************************************************)


  CONST
  (* Possible bit combinations for the flags parameter of al_set_new_display_flags. *)
    {@exclude}
    ALLEGRO_DEFAULT                     = 0 SHL 0;
    {@exclude}
    ALLEGRO_WINDOWED                    = 1 SHL 0;
    {@exclude}
    ALLEGRO_FULLSCREEN                  = 1 SHL 1;
    {@exclude}
    ALLEGRO_OPENGL                      = 1 SHL 2;
    {@exclude}
    ALLEGRO_DIRECT3D_INTERNAL           = 1 SHL 3;
    {@exclude}
    ALLEGRO_RESIZABLE                   = 1 SHL 4;
    {@exclude}
    ALLEGRO_FRAMELESS                   = 1 SHL 5;
    {@exclude}
    ALLEGRO_NOFRAME                     = ALLEGRO_FRAMELESS;
    {@exclude}
    ALLEGRO_GENERATE_EXPOSE_EVENTS      = 1 SHL 6;
    {@exclude}
    ALLEGRO_OPENGL_3_0                  = 1 SHL 7;
    {@exclude}
    ALLEGRO_OPENGL_FORWARD_COMPATIBLE   = 1 SHL 8;
    {@exclude}
    ALLEGRO_FULLSCREEN_WINDOW           = 1 SHL 9;
    {@exclude}
    ALLEGRO_MINIMIZED                   = 1 SHL 10;
    {@exclude}
    ALLEGRO_PROGRAMMABLE_PIPELINE       = 1 SHL 11;
    {@exclude}
    ALLEGRO_GTK_TOPLEVEL_INTERNAL       = 1 SHL 12;
    {@exclude}
    ALLEGRO_MAXIMIZED                   = 1 SHL 13;
    {@exclude}
    ALLEGRO_OPENGL_ES_PROFILE           = 1 SHL 14;

  TYPE
  (* Possible parameters for al_set_display_option.

     Make sure to update ALLEGRO_EXTRA_DISPLAY_SETTINGS if you modify
     anything here.  *)
    ALLEGRO_DISPLAY_OPTIONS = (
      ALLEGRO_RED_SIZE = 0,
      ALLEGRO_GREEN_SIZE = 1,
      ALLEGRO_BLUE_SIZE = 2,
      ALLEGRO_ALPHA_SIZE = 3,
      ALLEGRO_RED_SHIFT = 4,
      ALLEGRO_GREEN_SHIFT = 5,
      ALLEGRO_BLUE_SHIFT = 6,
      ALLEGRO_ALPHA_SHIFT = 7,
      ALLEGRO_ACC_RED_SIZE = 8,
      ALLEGRO_ACC_GREEN_SIZE = 9,
      ALLEGRO_ACC_BLUE_SIZE = 10,
      ALLEGRO_ACC_ALPHA_SIZE = 11,
      ALLEGRO_STEREO = 12,
      ALLEGRO_AUX_BUFFERS = 13,
      ALLEGRO_COLOR_SIZE = 14,
      ALLEGRO_DEPTH_SIZE = 15,
      ALLEGRO_STENCIL_SIZE = 16,
      ALLEGRO_SAMPLE_BUFFERS = 17,
      ALLEGRO_SAMPLES = 18,
      ALLEGRO_RENDER_METHOD = 19,
      ALLEGRO_FLOAT_COLOR = 20,
      ALLEGRO_FLOAT_DEPTH = 21,
      ALLEGRO_SINGLE_BUFFER = 22,
      ALLEGRO_SWAP_METHOD = 23,
      ALLEGRO_COMPATIBLE_DISPLAY = 24,
      ALLEGRO_UPDATE_DISPLAY_REGION = 25,
      ALLEGRO_VSYNC = 26,
      ALLEGRO_MAX_BITMAP_SIZE = 27,
      ALLEGRO_SUPPORT_NPOT_BITMAP = 28,
      ALLEGRO_CAN_DRAW_INTO_BITMAP = 29,
      ALLEGRO_SUPPORT_SEPARATE_ALPHA = 30,
      ALLEGRO_AUTO_CONVERT_BITMAPS = 31,
      ALLEGRO_SUPPORTED_ORIENTATIONS = 32,
      ALLEGRO_OPENGL_MAJOR_VERSION = 33,
      ALLEGRO_OPENGL_MINOR_VERSION = 34,
      ALLEGRO_DISPLAY_OPTIONS_COUNT
    );

  CONST
    ALLEGRO_DISPLAY_ORIENTATION_UNKNOWN = 0;
    ALLEGRO_DISPLAY_ORIENTATION_0_DEGREES = 1;
    ALLEGRO_DISPLAY_ORIENTATION_90_DEGREES = 2;
    ALLEGRO_DISPLAY_ORIENTATION_180_DEGREES = 4;
    ALLEGRO_DISPLAY_ORIENTATION_PORTRAIT = 5;
    ALLEGRO_DISPLAY_ORIENTATION_270_DEGREES = 8;
    ALLEGRO_DISPLAY_ORIENTATION_LANDSCAPE = 10;
    ALLEGRO_DISPLAY_ORIENTATION_ALL = 15;
    ALLEGRO_DISPLAY_ORIENTATION_FACE_UP = 16;
    ALLEGRO_DISPLAY_ORIENTATION_FACE_DOWN = 32;

    ALLEGRO_DONTCARE = 0;
    ALLEGRO_REQUIRE = 1;
    ALLEGRO_SUGGEST = 2;

{ enum ALLEGRO_DISPLAY_ORIENTATION declared at section "events.h". }

  { Formelly part of the primitives addon. }
    _ALLEGRO_PRIM_MAX_USER_ATTR = 10;

{ pointer ALLEGRO_DISPLAYptr declared at section "events.h". }

    ALLEGRO_NEW_WINDOW_TITLE_MAX_SIZE = 255;



(* Creates a display, or window, with the specified dimensions. The parameters
   of the display are determined by the last calls to
   @code(al_set_new_display_* ). Default parameters are used if none are set
   explicitly. Creating a new display will automatically make it the active
   one, with the backbuffer selected for drawing.

   Each display that uses OpenGL as a backend has a distinct OpenGL rendering
   context associated with it. See @link(al_set_target_bitmap) for the
   discussion about rendering contexts.
   @returns(@nil on error.)
   @seealso(al_set_new_display_flags) @seealso(al_set_new_display_option)
   @seealso(al_set_new_display_refresh_rate)
   @seealso(al_set_new_display_adapter) @seealso(al_set_new_window_title)
   @seealso(al_destroy_display) *)
  FUNCTION al_create_display (w, h: AL_INT): ALLEGRO_DISPLAYptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Destroys a display.

   If the target bitmap of the calling thread is tied to the display, then it
   implies a call to @code(al_set_target_bitmap @(@nil@);) before the display
   is destroyed.

   That special case notwithstanding, you should make sure no threads are
   currently targeting a bitmap which is tied to the display before you destroy
   it.
   @seealso(al_set_target_bitmap) *)
  PROCEDURE al_destroy_display (display: ALLEGRO_DISPLAYptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

(* Sets various flags to be used when creating new displays on the calling
   thread. flags is a bitfield containing any reasonable combination of the following:
   @unorderedlist(
     @item(@bold(@code(ALLEGRO_WINDOWED)) Prefer a windowed mode.

      Under multi-head X (not XRandR/TwinView), the use of more than one
      adapter is impossible due to bugs in X and GLX. @code(al_create_display)
      will fail if more than one adapter is attempted to be used.)
     @item(@bold(@code(ALLEGRO_FULLSCREEN_WINDOW)) Make the window span the
      entire screen. Unlike @code(ALLEGRO_FULLSCREEN) this will never attempt
      to modify the screen resolution. Instead the pixel dimensions of the
      created display will be the same as the desktop.

      The passed width and height are only used if the window is switched out
      of fullscreen mode later but will be ignored initially.

      Under Windows and X11 a fullscreen display created with this flag will
      behave differently from one created with the @code(ALLEGRO_FULLSCREEN)
      flag - even if the @code(ALLEGRO_FULLSCREEN) display is passed the
      desktop dimensions. The exact difference is platform dependent, but some
      things which may be different is how alt-tab works, how fast you can
      toggle between fullscreen/windowed mode or how additional monitors behave
      while your display is in fullscreen mode.

      Additionally under X, the use of more than one adapter in multi-head mode
      or with true Xinerama enabled is impossible due to bugs in X/GLX,
      creation will fail if more than one adapter is attempted to be used.)
     @item(@bold(@code(ALLEGRO_FULLSCREEN)) Prefer a fullscreen mode.

      Under X the use of more than one FULLSCREEN display when using multi-head
      X, or true Xinerama is not possible due to bugs in X and GLX, display
      creation will fail if more than one adapter is attempted to be used.

      @bold(Note:) Prefer using @code(ALLEGRO_FULLSCREEN_WINDOW) as it
      typically provides a better user experience as the monitor doesn't change
      resolution and switching away from your game via Alt-Tab works smoothly.
      @code(ALLEGRO_FULLSCREEN) is typically less well supported compared to
      @code(ALLEGRO_FULLSCREEN_WINDOW).)
     @item(@bold(@code(ALLEGRO_RESIZABLE)) The display is resizable @(only
      applicable if combined with @code(ALLEGRO_WINDOWED)@).)
     @item(@bold(@code(ALLEGRO_MAXIMIZED)) The display window will be maximized
      @(only applicable if combined with @code(ALLEGRO_RESIZABLE)@).)
     @item(@bold(@code(ALLEGRO_OPENGL)) Require the driver to provide an
      initialized OpenGL context after returning successfully.)
     @item(@bold(@code(ALLEGRO_OPENGL_3_0)) Require the driver to provide an
      initialized OpenGL context compatible with OpenGL version 3.0.)
     @item(@bold(@code(ALLEGRO_OPENGL_FORWARD_COMPATIBLE)) If this flag is set,
      the OpenGL context created with @code(ALLEGRO_OPENGL_3_0) will be forward
      compatible only, meaning that all of the OpenGL API declared deprecated
      in OpenGL 3.0 will not be supported. Currently, a display created with
      this flag will not be compatible with Allegro drawing routines; the
      display option @code(ALLEGRO_COMPATIBLE_DISPLAY) will be set to false.)
     @item(@bold(@code(ALLEGRO_OPENGL_ES_PROFILE)) Used together with
      @code(ALLEGRO_OPENGL), requests that the OpenGL context uses the OpenGL
      ES profile. A specific version can be requested with
      @link(al_set_new_display_option). @bold(Note:) Currently this is only
      supported by the X11/GLX driver.)
     @item(@bold(@code(ALLEGRO_DIRECT3D)) Require the driver to do rendering
      with Direct3D and provide a Direct3D device.)
     @item(@bold(@code(ALLEGRO_PROGRAMMABLE_PIPELINE)) Require a programmable
      graphics pipeline. This flag is required to use @code(ALLEGRO_SHADER)
      objects.)
     @item(@bold(@code(ALLEGRO_FRAMELESS)) Try to create a window without a
      frame @(i.e. no border or titlebar@). This usually does nothing for
      fullscreen modes, and even in windowed modes it depends on the underlying
      platform whether it is supported or not.)
     @item(@bold(@code(ALLEGRO_GENERATE_EXPOSE_EVENTS)) Let the display
      generate expose events.)
     @item(@bold(@code(ALLEGRO_GTK_TOPLEVEL)) Create a GTK toplevel window for
      the display, on X. This flag is conditionally defined by the native
      dialog addon. You must call @link(al_init_native_dialog_addon) for it to
      succeed. @code(ALLEGRO_GTK_TOPLEVEL) is incompatible with
      @code(ALLEGRO_FULLSCREEN).)
   )
   0 can be used for default values.
   @seealso(al_set_new_display_option) @seealso(al_get_display_option)
   @seealso(al_set_display_option) *)
  PROCEDURE al_set_new_display_flags (flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Set an extra display option, to be used when creating new displays on the
   calling thread.  Display options differ from display flags, and specify some
   details of the context to be created within the window itself.  These mainly
   have no effect on Allegro itself, but you may want to specify them, for
   example if you want to use multisampling.

   The @code(importance) parameter can be either:@unorderedlist(
    @item(@bold(@code(ALLEGRO_REQUIRE)) - The display will not be created if
     the setting can not be met.)
    @item(@bold(@code(ALLEGRO_SUGGEST)) - If the setting is not available, the
     display will be created anyway with a setting as close as possible to the
     requested one.  You can query the actual value used in that case by
     calling @link(al_get_display_option) after the display has been created.)
    @item(@bold(@code(ALLEGRO_DONTCARE)) - If you added a display option with
     one of the above two settings before, it will be removed again.  Else this
     does nothing.)
   )
   The supported options are:@unorderedlist(
    @item(@bold(@code(ALLEGRO_COLOR_SIZE)) - This can be used to ask for a
     specific bit depth. For example to force a 16-bit framebuffer set this to
     16.)
    @item(@bold(@code(ALLEGRO_RED_SIZE, ALLEGRO_GREEN_SIZE, ALLEGRO_BLUE_SIZE,
     ALLEGRO_ALPHA_SIZE)) - Individual color component size in bits.)
    @item(@bold(@code(ALLEGRO_RED_SHIFT, ALLEGRO_GREEN_SHIFT,
     ALLEGRO_BLUE_SHIFT, ALLEGRO_ALPHA_SHIFT)) - Together with the previous
     settings these can be used to specify the exact pixel layout the display
     should use. Normally there is no reason to use these.)
    @item(@bold(@code(ALLEGRO_ACC_RED_SIZE, ALLEGRO_ACC_GREEN_SIZE,
     ALLEGRO_ACC_BLUE_SIZE, ALLEGRO_ACC_ALPHA_SIZE)) - This can be used to
     define the required accumulation buffer size.)
    @item(@bold(@code(ALLEGRO_STEREO)) - Whether the display is a stereo display.)
    @item(@bold(@code(ALLEGRO_AUX_BUFFERS)) - Number of auxiliary buffers the
     display should have.)
    @item(@bold(@code(ALLEGRO_DEPTH_SIZE)) - How many depth buffer @(z-buffer@)
     bits to use.)
    @item(@bold(@code(ALLEGRO_STENCIL_SIZE)) - How many bits to use for the
     stencil buffer.)
    @item(@bold(@code(ALLEGRO_SAMPLE_BUFFERS)) - Whether to use multisampling
     @(@code(1)@) or not @(@code(0)@).)
    @item(@bold(@code(ALLEGRO_SAMPLES)) - If the above is @code(1), the number
     of samples to use per pixel. Else @code(0).)
    @item(@bold(@code(ALLEGRO_RENDER_METHOD:)) - @code(0) if hardware
     acceleration is not used with this display.)
    @item(@bold(@code(ALLEGRO_FLOAT_COLOR)) - Whether to use floating point
     color components.)
    @item(@bold(@code(ALLEGRO_FLOAT_DEPTH)) - Whether to use a floating point
     depth buffer.)
    @item(@bold(@code(ALLEGRO_SINGLE_BUFFER)) - Whether the display uses a
     single buffer @(@code(1)@) or another update method @(@code(0)@).)
    @item(@bold(@code(ALLEGRO_SWAP_METHOD)) - If the above is @code(0), this is
     set to @code(1) to indicate the display is using a copying method to make
     the next buffer in the flip chain available, or to @code(2) to indicate a
     flipping or other method.)
    @item(@bold(@code(ALLEGRO_COMPATIBLE_DISPLAY)) - Indicates if Allegro's
     graphics functions can use this display. If you request a display not
     useable by Allegro, you can still use for example OpenGL to draw graphics.)
    @item(@bold(@code(ALLEGRO_UPDATE_DISPLAY_REGION)) - Set to @code(1) if the
     display is capable of updating just a region, and @code(0) if calling
     @link(al_update_display_region) is equivalent to @code(al_flip_display).)
    @item(@bold(@code(ALLEGRO_VSYNC)) - Set to @code(1) to tell the driver to
     wait for vsync in @link(al_flip_display), or to @code(2) to force vsync
     off.  The default of @code(0) means that Allegro does not try to modify
     the vsync behavior so it may be on or off.  Note that even in the case of
     1 or 2 it is possible to override the vsync behavior in the graphics
     driver so you should not rely on it.)
    @item(@bold(@code(ALLEGRO_MAX_BITMAP_SIZE)) - When queried this returns the
     maximum size @(width as well as height@) a bitmap can have for this
     display.  Calls to @link(al_create_bitmap) or @link(al_load_bitmap) for
     bitmaps larger than this size will fail.  It does not apply to memory
     bitmaps which always can have arbitrary size @(but are slow for drawing@).)
    @item(@bold(@code(ALLEGRO_SUPPORT_NPOT_BITMAP)) - Set to 1 if textures used
     for bitmaps on this display can have a size which is not a power of two.
     This is mostly useful if you use Allegro to load textures as otherwise
     only power-of-two textures will be used internally as bitmap storage.)
    @item(@bold(@code(ALLEGRO_CAN_DRAW_INTO_BITMAP)) - Set to @code(1) if you
     can use @link(al_set_target_bitmap) on bitmaps of this display to draw
     into them. If this is not the case software emulation will be used when
     drawing into display bitmaps @(which can be very slow@).)
    @item(@bold(@code(ALLEGRO_SUPPORT_SEPARATE_ALPHA)) - This is set to
    @code(1) if the @link(al_set_separate_blender) function is supported.
     Otherwise the alpha parameters will be ignored.)
    @item(@bold(@code(ALLEGRO_AUTO_CONVERT_BITMAPS)) - This is on by
     default. It causes any existing memory bitmaps with the
     @code(ALLEGRO_CONVERT_BITMAP) flag to be converted to a display bitmap of
     the newly created display with the option set.)
    @item(@bold(@code(ALLEGRO_SUPPORTED_ORIENTATIONS)) - This is a
     bit-combination of the orientations supported by the application. The
     orientations are the same as for @link(al_get_display_orientation) with
     the additional possibilities:@unorderedlist(

     @item(@bold(@code(ALLEGRO_DISPLAY_ORIENTATION_PORTRAIT)) - means only the
      two portrait orientations are supported.)
     @item(@bold(@code(ALLEGRO_DISPLAY_ORIENTATION_LANDSCAPE)) - means only the
      two landscape orientations)
     @item(@bold(@code(ALLEGRO_DISPLAY_ORIENTATION_ALL)) - allows all four
      orientations.))
     When the orientation changes between a portrait and a landscape
     orientation the display needs to be resized.  This is done by sending an
     @code(ALLEGRO_EVENT_DISPLAY_RESIZE) message which should be handled by
     calling @link(al_acknowledge_resize).)
    @item(@bold(@code(ALLEGRO_OPENGL_MAJOR_VERSION)) - Request a specific
     OpenGL major version.)
    @item(@bold(@code(ALLEGRO_OPENGL_MINOR_VERSION)) - Request a specific
     OpenGL minor version.)
   )
   @seealso(al_set_new_display_flags) @seealso(al_get_display_option) *)
  PROCEDURE al_set_new_display_option (option: ALLEGRO_DISPLAY_OPTIONS; value, importance: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

(* Gets the flags of the display.

   In addition to the flags set for the display at creation time with
   @link(al_set_new_display_flags) it can also have the @code(ALLEGRO_MINIMIZED)
   flag set, indicating that the window is currently minimized.  This flag is
   very platform-dependent as even a minimized application may still render a
   preview version so normally you should not care whether it is minimized or
   not.
   @seealso(al_set_new_display_flags) @seealso(al_set_display_flag) *)
  FUNCTION al_get_display_flags (display: ALLEGRO_DISPLAYptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Enable or disable one of the display flags. The flags are the same as for
   @link(al_set_new_display_flags).  The only flags that can be changed after
   creation are:
@longcode(#
    ALLEGRO_FULLSCREEN_WINDOW
    ALLEGRO_FRAMELESS
    ALLEGRO_MAXIMIZED
#)
   You can use @code(al_get_display_flags) to query whether the given display
   property actually changed.
   @return(@true if the driver supports toggling the specified flag else
     @false.)
   @seealso(al_set_new_display_flags) @seealso(al_get_display_flags) *)
  FUNCTION al_set_display_flag
    (display: ALLEGRO_DISPLAYptr; flag: AL_INT; onoff: AL_BOOL): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  PROCEDURE al_set_new_display_refresh_rate (refresh_rate: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_new_display_refresh_rate: AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_new_display_flags: AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  PROCEDURE al_set_new_window_title (CONST title: AL_STR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_new_window_title: AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  FUNCTION al_get_display_width (display: ALLEGRO_DISPLAYptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_display_height (display: ALLEGRO_DISPLAYptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Gets the pixel format of the display. *)
  FUNCTION al_get_display_format (display: ALLEGRO_DISPLAYptr): ALLEGRO_PIXEL_FORMAT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_display_refresh_rate (display: ALLEGRO_DISPLAYptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_display_orientation (display: ALLEGRO_DISPLAYptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_toggle_display_flag (display: ALLEGRO_DISPLAYptr; flag: AL_INT; onoff: AL_BOOL): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



  FUNCTION al_get_current_display: ALLEGRO_DISPLAYptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* This function selects the bitmap to which all subsequent drawing operations
   in the calling thread will draw to. To return to drawing to a display, set
   the backbuffer of the display as the target bitmap, using
   @link(al_get_backbuffer). As a convenience, you may also use
   @link(al_set_target_backbuffer).

   Each video bitmap is tied to a display. When a video bitmap is set to as the
   target bitmap, the display that the bitmap belongs to is automatically made
   "current" for the calling thread (if it is not current already). Then
   drawing other bitmaps which are tied to the same display can be hardware
   accelerated.

   A single display cannot be current for multiple threads simultaneously. If
   you need to release a display, so it is not current for the calling thread,
   call @code(al_set_target_bitmap @(@nil@);)

   Setting a memory bitmap as the target bitmap will not change which display
   is current for the calling thread.

   On some platforms, Allegro automatically backs up the contents of video
   bitmaps because they may be occasionally lost (see discussion in
   @link(al_create_bitmap)'s documentation). If you're completely recreating
   the bitmap contents often (e.g. every frame) then you will get much better
   performance by creating the target bitmap with
   @code(ALLEGRO_NO_PRESERVE_TEXTURE) flag.

   @bold(OpenGL note:)

   Framebuffer objects (FBOs) allow OpenGL to directly draw to a bitmap, which
   is very fast. When using an OpenGL display, if all of the following
   conditions are met an FBO will be created for use with the bitmap:
   @unorderedlist(
    @item(The @code(GL_EXT_framebuffer_object) OpenGL extension is available.)
    @item(The bitmap is not a memory bitmap.)
    @item(The bitmap is not currently locked.)
   )
   In Allegro 5.0.0, you had to be careful as an FBO would be kept around until
   the bitmap is destroyed or you explicitly called @link(al_remove_opengl_fbo)
   on the bitmap, wasting resources. In newer versions, FBOs will be freed
   automatically when the bitmap is no longer the target bitmap, unless you
   have called @link(al_get_opengl_fbo) to retrieve the FBO id.

   In the following example, no FBO will be created:
@longcode(#
lock := al_lock_bitmap (bitmap);
al_set_target_bitmap (bitmap);
al_put_pixel (x, y, color);
al_unlock_bitmap (bitmap);
#)
   The above allows using @code(al_put_pixel) on a locked bitmap without
   creating an FBO.

   In this example an FBO is created however:
@longcode(#
al_set_target_bitmap(bitmap);
al_draw_line(x1, y1, x2, y2, color, 0);
#)
   An OpenGL command will be used to directly draw the line into the bitmap's
   associated texture.
   @seealso(al_get_target_bitmap) @seealso(al_set_target_backbuffer) *)
  PROCEDURE al_set_target_bitmap (Bitmap: ALLEGRO_BITMAPptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Same as @code(al_set_target_bitmap@(al_get_backbuffer@(display@)@);).
   @seealso(al_set_target_bitmap) @seealso(al_get_backbuffer) *)
  PROCEDURE al_set_target_backbuffer (display: ALLEGRO_DISPLAYptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns a special bitmap representing the back-buffer of the display.

   Care should be taken when using the backbuffer bitmap (and its sub-bitmaps)
   as the source bitmap (e.g as the bitmap argument to @link(al_draw_bitmap)).
   Only untransformed operations are hardware accelerated. These consist of
   @link(al_draw_bitmap) and @link(al_draw_bitmap_region) when the current
   transformation is the identity. If the tranformation is not the identity, or
   some other drawing operation is used, the call will be routed through the
   memory bitmap routines, which are slow. If you need those operations to be
   accelerated, then first copy a region of the backbuffer into a temporary
   bitmap (via the @link(al_draw_bitmap) and @link(al_draw_bitmap_region)), and
   then use that temporary bitmap as the source bitmap. *)
  FUNCTION al_get_backbuffer (display: ALLEGRO_DISPLAYptr): ALLEGRO_BITMAPptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the target bitmap of the calling thread.
   @seealso(al_set_target_bitmap) *)
  FUNCTION al_get_target_bitmap: ALLEGRO_BITMAPptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* When the user receives a resize event from a resizable display, if they wish
   the display to be resized they must call this function to let the graphics
   driver know that it can now resize the display.

   Adjusts the clipping rectangle to the full size of the backbuffer. This also
   resets the backbuffers projection transform to default orthographic
   transform (see @link(al_use_projection_transform)).

   Note that a resize event may be outdated by the time you acknowledge it;
   there could be further resize events generated in the meantime.
   @return(@true on success.)
   @seealso(al_resize_display) @seealso(ALLEGRO_EVENT) *)
  FUNCTION al_acknowledge_resize (display: ALLEGRO_DISPLAYptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_resize_display (display: ALLEGRO_DISPLAYptr; width, height: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Copies or updates the front and back buffers so that what has been drawn
   previously on the currently selected display becomes visible on screen.
   Pointers to the special back buffer bitmap remain valid and retain their
   semantics as the back buffer, although the contents may have changed.

   Several display options change how this function behaves:
   @unorderedlist(
    @item(With @code(ALLEGRO_SINGLE_BUFFER), no flipping is done. You still have
     to call this function to display graphics, depending on how the used
     graphics system works.)
    @item(The @code(ALLEGRO_SWAP_METHOD) option may have additional information
     about what kind of operation is used internally to flip the front and back
     buffers.)
    @item(If @code(ALLEGRO_VSYNC) is 1, this function will force waiting for
     vsync. If @code(ALLEGRO_VSYNC) is 2, this function will not wait for
     vsync. With many drivers the vsync behavior is controlled by the user and
     not the application, and @code(ALLEGRO_VSYNC) will not be set; in this
     case @code(al_flip_display) will wait for vsync depending on the settings
     set in the system's graphics preferences.)
   )
   @seealso(al_set_new_display_flags) @seealso(al_set_new_display_option) *)
  PROCEDURE al_flip_display;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_update_display_region (x, y, Width, height: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_is_compatible_bitmap (bitmap: ALLEGRO_BITMAPptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Wait for the beginning of a vertical retrace. Some driver/card/monitor
   combinations may not be capable of this.

   Note how @code(al_flip_display) usually already waits for the vertical
   retrace, so unless you are doing something special, there is no reason to
   call this function.
   @returns(@false if not possible, @true if successful.)
   @seealso(al_flip_display) *)
  FUNCTION al_wait_for_vsync: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Retrieve the associated event source. See the documentation on events for a
   list of the events displays will generate. *)
  FUNCTION al_get_display_event_source (display: ALLEGRO_DISPLAYptr): ALLEGRO_EVENT_SOURCEptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



  PROCEDURE al_set_display_icon (display: ALLEGRO_DISPLAYptr; icon: ALLEGRO_BITMAPptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_set_display_icons (display: ALLEGRO_DISPLAYptr; num_icons: AL_INT; VAR icons: ARRAY OF ALLEGRO_BITMAPptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Stuff for multihead/window management *)
  FUNCTION al_get_new_display_adapter: AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_set_new_display_adapter (adapter: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_set_new_window_position (x, y: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_get_new_window_position (OUT x, y: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_set_window_position (display: ALLEGRO_DISPLAYptr; x, y: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_get_window_position (display: ALLEGRO_DISPLAYptr; OUT x, y: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_set_window_constraints (display: ALLEGRO_DISPLAYptr; min_w, min_h, max_w, max_h: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_window_constraints (display: ALLEGRO_DISPLAYptr; OUT min_w, min_h, max_w, max_h: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



  PROCEDURE al_set_window_title (display: ALLEGRO_DISPLAYptr; const title: AL_STR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



  FUNCTION al_get_new_display_option (option: ALLEGRO_DISPLAY_OPTIONS; VAR importance: AL_INT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_reset_new_display_options;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_set_display_option (display: ALLEGRO_DISPLAYptr; option: ALLEGRO_DISPLAY_OPTIONS; value: AL_INT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_display_option (display: ALLEGRO_DISPLAYptr; option: ALLEGRO_DISPLAY_OPTIONS): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(* Deferred drawing *)
  PROCEDURE al_hold_bitmap_drawing (hold: AL_BOOL);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_is_bitmap_drawing_held: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



  PROCEDURE al_acknowledge_drawing_halt (display: ALLEGRO_DISPLAYptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_acknowledge_drawing_resume (display: ALLEGRO_DISPLAYptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * clipboard.h
 *
 *   Clipboard handling.
 *****************************************************************************)

  FUNCTION al_get_clipboard_text (display: ALLEGRO_DISPLAYptr): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_set_clipboard_text
    (display: ALLEGRO_DISPLAYptr; CONST text: AL_STR): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_clipboard_has_text (display: ALLEGRO_DISPLAYptr): AL_BOOL
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * config.h
 *****************************************************************************)

  TYPE
  (* An abstract configuration structure. *)
    ALLEGRO_CONFIGptr = AL_POINTER;
  (* An opaque structure used for iterating across sections in a configuration
     structure. *)
    ALLEGRO_CONFIG_SECTIONptr = AL_POINTER;
  (* An opaque structure used for iterating across entries in a configuration
     section. *)
    ALLEGRO_CONFIG_ENTRYptr = AL_POINTER;

  (* Creates an empty configuration structure.
     @seealso(al_load_config_file) @seealso(al_destroy_config) *)
    FUNCTION al_create_config: ALLEGRO_CONFIGptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Adds a section to a configuration structure with the given name. If the
     section already exists then nothing happens. *)
    PROCEDURE al_add_config_section (config: ALLEGRO_CONFIGptr; CONST name: AL_STR);
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Sets a value in a section of a configuration. If the section doesn't yet
     exist, it will be created. If a value already existed for the given key,
     it will be overwritten. The section can be @code('') for the global
     section.

     For consistency with the on-disk format of config files, any leading and
     trailing whitespace will be stripped from the value. If you have
     significant whitespace you wish to preserve, you should add your own quote
     characters and remove them when reading the values back in.
     @seealso(al_get_config_value) *)
    PROCEDURE al_set_config_value (config: ALLEGRO_CONFIGptr; CONST section, key, value: AL_STR);
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Adds a comment in a section of a configuration. If the section doesn't yet
     exist, it will be created. The section can be @code('') for the global
     section.

     The comment may or may not begin with a hash character. Any newlines in
     the comment string will be replaced by space characters.
     @seealso(al_add_config_section) *)
    PROCEDURE al_add_config_comment (config: ALLEGRO_CONFIGptr; CONST section, comment: AL_STR);
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Sets a pointer to an internal character buffer that will only remain valid
     as long as the @link(ALLEGRO_CONFIGptr) structure is not destroyed. Copy the
     value if you need a copy.  The section can be @code('') for the global
     section.
     @return(@nil if section or key do not exist.)
     @seealso(al_set_config_value) *)
    FUNCTION al_get_config_value (CONST config: ALLEGRO_CONFIGptr; CONST section, key: AL_STR): AL_STRptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Read a configuration file from disk.

     The configuration structure should be destroyed with
     @link(al_destroy_config).)
     @return(Pointer to configuration or @nil on error.)
     @seealso(al_load_config_file_f) @seealso(al_save_config_file) *)
    FUNCTION al_load_config_file (CONST filename: AL_STR): ALLEGRO_CONFIGptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Read a configuration file from an already open file.
     @return(@nil on error. The configuration structure should be destroyed
      with @link(al_destroy_config). The file remains open afterwards.)
     @seealso(al_load_config_file) *)
    FUNCTION al_load_config_file_f (fp: ALLEGRO_FILEptr): ALLEGRO_CONFIGptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Write out a configuration file to disk.
     @return(@true on success, @false on error.)
     @seealso(al_save_config_file_f) @seealso(al_load_config_file) *)
    FUNCTION al_save_config_file 
      (CONST filename: AL_STR; CONST config: ALLEGRO_CONFIGptr): AL_BOOL;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Write out a configuration file to an already open file.
     @return(@true on success, @false on error. The file remains open
	     afterwards.)
     @seealso(al_save_config_file) *)
    FUNCTION al_save_config_file_f
      (fp: ALLEGRO_FILEptr; CONST config: ALLEGRO_CONFIGptr): AL_BOOL;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
{
AL_FUNC(void, al_merge_config_into, (ALLEGRO_CONFIG *master, const ALLEGRO_CONFIG *add));
AL_FUNC(ALLEGRO_CONFIG *, al_merge_config, (const ALLEGRO_CONFIG *cfg1, const ALLEGRO_CONFIG *cfg2));
}
  (* Frees the resources used by a configuration structure. Does nothing if
     passed @nil. *)
    PROCEDURE al_destroy_config (config: ALLEGRO_CONFIGptr);
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Removes a section of a configuration.
     @return(@true if the section was removed, or @false if the section did not
	exist.) *)
    FUNCTION al_remove_config_section
      (config: ALLEGRO_CONFIGptr; CONST section: AL_STR): AL_BOOL;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Removes a key and its associated value in a section of a configuration.
     @return(@true if the entry was removed, or @false if the entry did not
	exist.) *)
    FUNCTION al_remove_config_key
      (config: ALLEGRO_CONFIGptr; CONST section, key: AL_STR): AL_BOOL;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  (* Returns the name of the first section in the given config file. Usually
     this will return an empty string for the global section, even it contains
     no values. The iterator parameter will receive an opaque iterator which is
     used by @link(al_get_next_config_section) to iterate over the remaining
     sections.

     The returned string and the iterator are only valid as long as no change
     is made to the passed @code(ALLEGRO_CONFIGptr).
     @seealso(al_get_next_config_section) *)
    FUNCTION al_get_first_config_section
      (CONST config: ALLEGRO_CONFIGptr; OUT iterator: ALLEGRO_CONFIG_SECTIONptr): AL_STRptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Returns the name of the next section in the given config file or @nil if
     there are no more sections. The iterator must have been obtained with
     @link(al_get_first_config_section) first.
     @seealso(al_get_first_config_section) *)
    FUNCTION al_get_next_config_section (VAR iterator: ALLEGRO_CONFIG_SECTIONptr): AL_STRptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Returns the name of the first key in the given section in the given config
     or @nil if the section is empty. The @code(iterator) works like the one
     for @link(al_get_first_config_section)

     The returned string and the iterator are only valid as long as no change
     is made to the passed @code(ALLEGRO_CONFIGptr).
     @seealso(al_get_next_config_entry) *)
    FUNCTION al_get_first_config_entry (
      CONST config: ALLEGRO_CONFIGptr; CONST section: AL_STR;
      OUT iterator: ALLEGRO_CONFIG_ENTRYptr
    ): AL_STRptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  (* Returns the next key for the iterator obtained by
     @link(al_get_first_config_entry). The iterator works like the one for
     @link(al_get_next_config_section). *)
    FUNCTION al_get_next_config_entry (VAR iterator: ALLEGRO_CONFIG_ENTRYptr): AL_STRptr;
      CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * cpu.h
 *
 *   CPU and system information handling.
 *****************************************************************************)

(* Returns the number of CPU cores that the system Allegro is running on has
   and which could be detected, or a negative number if detection failed.  Even
   if a positive number is returned, it might be that it is not correct.  For
   example, Allegro running on a virtual machine will return the amount of
   CPU's of the VM, and not that of the underlying system.

   Furthermore even if the number is correct, this only gives you information
   about the total CPU cores of the system Allegro runs on.  The amount of
   cores available to your program may be less due to circumstances such as
   programs that are currently running.

   Therefore, it's best to use this for advisory purposes only.  It is
   certainly a bad idea to make your program exclusive to systems for which
   this function returns a certain "desirable" number.

   This function may be called prior to @link(al_install_system) or
   @link(al_init). *)
  FUNCTION al_get_cpu_count: AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the size in MB of the random access memory that the system Allegro
   is running on has and which could be detected, or a negative number if
   detection failed.  Even if a positive number is returned, it might be that
   it is not correct.  For example, Allegro running on a virtual machine will
   return the amount of RAM of the VM, and not that of the underlying system.

   Furthermore even if the number is correct, this only gives you information
   about the total physical memory of the system Allegro runs on.  The memory
   available to your program may be less due to circumstances such as virtual
   memory, and other programs that are currently running.

   Therefore, it's best to use this for advisory purposes only.  It is
   certainly a bad idea to make your program exclusive to systems for which
   this function returns a certain "desirable" number.

   This function may be called prior to @link(al_install_system) or
   @link(al_init). *)
  FUNCTION al_get_ram_size: AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * debug.h
 *
 *   Debug facilities.
 *
 *   By Shawn Hargreaves.
 *****************************************************************************)

{ TODO:
  At the moment I'll not include this header.

  Actually I'll add this unit only if it's necessary or helpful. }



(*
 * drawing.h
 *****************************************************************************)

(* Clears the complete target bitmap, but confined by the clipping rectangle.
   @seealso(al_set_clipping_rectangle) @seealso(al_clear_depth_buffer) *)
  PROCEDURE al_clear_to_color (color: ALLEGRO_COLOR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_clear_depth_buffer (x: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_draw_pixel (x, y: AL_FLOAT; color: ALLEGRO_COLOR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * error.h
 *     Error handling.
 *****************************************************************************)

(* Some Allegro functions will set an error number as well as returning an
   error code.  Call this function to retrieve the last error number set for
   the calling thread. @seealso(al_set_errno) *)
  FUNCTION al_get_errno: AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

(* Sets the error number for the calling thread. @seealso(al_get_errno) *)
  PROCEDURE al_set_errno (errnum: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * fixed.h
 *
 *   Fixed point type.
 *
 *   By Shawn Hargreaves.
 *****************************************************************************)

 { TODO: Coming soon ;). }



(*
 * fmath.h
 *
 *   Fixed point math routines.
 *
 *   By Shawn Hargreaves.
 *****************************************************************************)

 { TODO: Coming soon ;). }



(*
 * fshook.h
 *
 * File system hooks.
 *****************************************************************************)

 { TODO: Don't do nothing until file.h is added. }



(*
 * fullscreen_mode.h
 *****************************************************************************)

  TYPE
    ALLEGRO_DISPLAY_MODEptr = ^ALLEGRO_DISPLAY_MODE;
    ALLEGRO_DISPLAY_MODE = RECORD
      width, height, format, refresh_rate: AL_INT;
    END;

  FUNCTION al_get_num_display_modes: AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Retrieves a fullscreen mode.  Display parameters should not be changed
   between a call of @code(al_get_num_display_modes) and
   @code(al_get_display_mode).
   @param(index Must be between 0 and the number returned from
     @code(al_get_num_display_modes - 1).)
   @param(mode Must be an allocated @code(ALLEGRO_DISPLAY_MODE) structure.)
   @return(@nil on failure, and the mode parameter that was passed in on
     success.)
   @seealso(ALLEGRO_DISPLAY_MODE) @seealso(al_get_num_display_modes) *)
  FUNCTION al_get_display_mode (index: AL_INT; OUT mode: ALLEGRO_DISPLAY_MODE): ALLEGRO_DISPLAY_MODEptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * joystick.h
 *
 *   Joystick routines.
 *****************************************************************************)

  CONST
  (* internal values *)
    _AL_MAX_JOYSTICK_AXES    =  3;
    _AL_MAX_JOYSTICK_STICKS  = 16;
    _AL_MAX_JOYSTICK_BUTTONS = 32;

  TYPE
  (* This is a structure that is used to hold a @italic("snapshot") of a
     joystick's axes and buttons at a particular instant. All fields public
     and read-only. @seealso(al_get_joystick_state) *)
    ALLEGRO_JOYSTICK_STATE = RECORD
    { -1.0 to 1.0 }
      stick: ARRAY [0.._AL_MAX_JOYSTICK_STICKS - 1] OF RECORD
	axis: ARRAY [0.._AL_MAX_JOYSTICK_AXES - 1] OF AL_FLOAT;
      END;
    { 0 to 32767 }
      button: ARRAY [0.._AL_MAX_JOYSTICK_BUTTONS - 1] OF AL_INT;
    END;



  (* @bold(Deprecated), this is a holdover from the old API and may be
     removed). @seealso(al_get_joystick_stick_flags) *)
    ALLEGRO_JOYFLAGS = (
      ALLEGRO_JOYFLAG_DIGITAL  = $01,
      ALLEGRO_JOYFLAG_ANALOGUE = $02
    );

(* Installs a joystick driver, returning @true if successful.  If a joystick
   driver was already installed, returns @true immediately.
   @seealso(al_uninstall_joystick) *)
  FUNCTION al_install_joystick: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Uninstalls the active joystick driver. All outstanding
   @code(ALLEGRO_JOYSTICKptr) pointers are invalidated.  If no joystick driver
   was active, this function does nothing.

   This function is automatically called when Allegro is shut down.
   @seealso(al_install_joystick) *)
  PROCEDURE al_uninstall_joystick;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns @true if @link(al_install_joystick) was called successfully. *)
  FUNCTION al_is_joystick_installed: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_reconfigure_joysticks: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  FUNCTION al_get_num_joysticks: AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_joystick (joyn: AL_INT): ALLEGRO_JOYSTICKptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* This procedure currently does nothing. @seealso(al_get_joystick) *)
  PROCEDURE al_release_joystick (j: ALLEGRO_JOYSTICKptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns if the joystick handle is "active", i.e. in the current
   configuration, the handle represents some physical device plugged into the
   system. @link(al_get_joystick) returns active handles. After
   reconfiguration, active handles may become inactive, and vice versa.
   @seealso(al_reconfigure_joysticks) *)
  FUNCTION al_get_joystick_active (j: ALLEGRO_JOYSTICKptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the name of the given joystick.
   @seealso(al_get_joystick_stick_name) @seealso(al_get_joystick_axis_name)
   @seealso(al_get_joystick_button_name) *)
  FUNCTION al_get_joystick_name (j: ALLEGRO_JOYSTICKptr): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  FUNCTION al_get_joystick_num_sticks (j: ALLEGRO_JOYSTICKptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_joystick_stick_flags (j: ALLEGRO_JOYSTICKptr; stick: AL_INT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_joystick_stick_name (j: ALLEGRO_JOYSTICKptr; stick: AL_INT): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  FUNCTION al_get_joystick_num_axes (j: ALLEGRO_JOYSTICKptr; stick: AL_INT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_joystick_axis_name (j: ALLEGRO_JOYSTICKptr; stick, axis: AL_INT): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  FUNCTION al_get_joystick_num_buttons (j: ALLEGRO_JOYSTICKptr): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_joystick_button_name (j: ALLEGRO_JOYSTICKptr; buttonn: AL_INT): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  PROCEDURE al_get_joystick_state (j: ALLEGRO_JOYSTICKptr; OUT ret_state: ALLEGRO_JOYSTICK_STATE);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  FUNCTION al_get_joystick_event_source: ALLEGRO_EVENT_SOURCEptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * keycodes.h
 *****************************************************************************)

{$include keycodes.inc}



(*
 * keyboard.h
 *
 *   Keyboard routines.
 *****************************************************************************)

  TYPE
  (* Holds a "snapshot" of keyboard. This is a structure that is used to hold
     the keyboard's state at a particular instant.

     You cannot read the state of keys directly. Use the function
     @link(al_key_down). @seealso(al_get_keyboard_state) *)
    ALLEGRO_KEYBOARD_STATE = RECORD
    (* points to the display that had keyboard focus at the time the state was
       saved. If no display was focused, this points to @nil. *)
      display: ALLEGRO_DISPLAYptr;
    { @exclude internal }
      __key_down__internal__: ARRAY [0..((ALLEGRO_KEY_MAX + 31) DIV 32) - 1] OF AL_UINT;
    END;
(* Returns @true if @link(al_install_keyboard) was called successfully. *)
  FUNCTION al_is_keyboard_installed: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Installs a keyboard driver.

   Returns @true if successful.  If a driver was already installed, nothing
   happens and @true is returned.
   @seealso(al_uninstall_keyboard) @seealso(al_is_keyboard_installed) *)
  FUNCTION al_install_keyboard: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Uninstalls the active keyboard driver, if any. This will automatically
   unregister the keyboard event source with any event queues.

   This function is automatically called when Allegro is shut down.
   @seealso(al_install_keyboard) *)
  PROCEDURE al_uninstall_keyboard;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

  FUNCTION al_set_keyboard_leds (leds: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Converts the given keycode to a description of the key. *)
  FUNCTION al_keycode_to_name (keycode: AL_INT): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Save the state of the keyboard specified at the time the function is called
   into the structure pointed to by ret_state.
   @seealso(al_key_down) @seealso(ALLEGRO_KEYBOARD_STATE) *)
  PROCEDURE al_get_keyboard_state (OUT ret_state: ALLEGRO_KEYBOARD_STATE);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns @true if the key specified was held down in the state specified.
   @seealso(ALLEGRO_KEYBOARD_STATE) *)
  FUNCTION al_key_down (VAR state: ALLEGRO_KEYBOARD_STATE; keycode: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

(* Retrieve the keyboard event source. All keyboard events are generated by
   this event source.
   @return(@nil if the keyboard subsystem was not installed.)
   @seealso(al_register_event_source) *)
  FUNCTION al_get_keyboard_event_source: ALLEGRO_EVENT_SOURCEptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * mouse.h
 *
 *  Mouse routines.
 *****************************************************************************)

  CONST
  (* Allow up to four extra axes for future expansion. *)
    ALLEGRO_MOUSE_MAX_EXTRA_AXES = 4;

  TYPE
  (* Stores mouse state.  Fields are read-only.
     @seealso(al_get_mouse_state) @seealso(al_get_mouse_state_axis)
     @seealso(al_mouse_button_down) *)
    ALLEGRO_MOUSE_STATE = RECORD
    (* Mouse X position. *)
      x,
    (* Mouse Y position. *)
      y,
    (* Mouse weel position (2D @italic(ball)). *)
      z, w: AL_INT;
    (* @exclude *)
      more_axes: ARRAY [0..(ALLEGRO_MOUSE_MAX_EXTRA_AXES - 1)] OF AL_INT;
    (* Mouse buttons bitfield.

      The zeroth bit is set if the primary mouse button is held down, the first
      bit is set if the secondary mouse button is held down, and so on. *)
      buttons: AL_INT;
    (* Pressure, ranging from 0.0 to 1.0. *)
      pressure: AL_FLOAT;
    (* Display were the mouse is at the moment(?). *)
      display: ALLEGRO_DISPLAYptr;
    END;



(* Returns @true if @link(al_install_mouse) was called successfully. *)
  FUNCTION al_is_mouse_installed: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Installs mouse driver.

   Returns @true if successful.  If a driver was already installed, nothing
   happens and @true is returned. *)
  FUNCTION al_install_mouse: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Uninstalls the active mouse driver, if any. This will automatically
   unregister the mouse event source with any event queues.

   This function is automatically called when Allegro is shut down. *)
  PROCEDURE al_uninstall_mouse;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the number of buttons on the mouse. The first button is 1.
   @seealso(al_get_mouse_num_axes) *)
  FUNCTION al_get_mouse_num_buttons: AL_UINT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the number of axes on the mouse. The first axis is 0.
   @seealso(al_get_mouse_num_buttons) *)
  FUNCTION al_get_mouse_num_axes: AL_UINT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Tryes to position the mouse at the given coordinates on the given display.
   The mouse movement resulting from a successful move will generate an
   @code(ALLEGRO_EVENT_MOUSE_WARPED) event.
   @return(@true on success, @false on failure.)
   @seealso(al_set_mouse_z) @seealso(al_set_mouse_w) *)
  FUNCTION al_set_mouse_xy (display: ALLEGRO_DISPLAYptr; x, y: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Sets the mouse wheel position to the given value.
   @return(@true on success, @false on failure.)
   @seealso(al_set_mouse_xy) @seealso(al_set_mouse_w) *)
  FUNCTION al_set_mouse_z (z: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Sets the second mouse wheel position to the given value.
   @return(@true on success, @false on failure.)
   @seealso(al_set_mouse_xy) @seealso(al_set_mouse_z) *)
  FUNCTION al_set_mouse_w (w: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Sets the given mouse axis to the given value.

   The axis number must not be 0 or 1, which are the X and Y axes. Use
   @code(al_set_mouse_xy) for that.
   @returns(@true on success, @false on failure.)
   @seealso(al_set_mouse_xy) @seealso(al_set_mouse_z,) @seealso(l_set_mouse_w) *)
  FUNCTION al_set_mouse_axis (axis, value: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_get_mouse_state (OUT ret_state: ALLEGRO_MOUSE_STATE);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns @true if the mouse button specified was held down in the state
   specified. Unlike most things, the first mouse button is numbered 1.
   @seealso(ALLEGRO_MOUSE_STATE) @seealso(al_get_mouse_state)
   @seealso(al_get_mouse_state_axis) *)
  FUNCTION al_mouse_button_down (VAR state: ALLEGRO_MOUSE_STATE; button: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Extracts the mouse axis value from the saved state. The axes are numbered
   from 0, in this order: x-axis, y-axis, z-axis, w-axis.
   @seealso(ALLEGRO_MOUSE_STATE) @seealso(al_get_mouse_state)
   @seealso(al_mouse_button_down) *)
  FUNCTION al_get_mouse_state_axis (VAR state: ALLEGRO_MOUSE_STATE; axis: AL_INT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* On platforms where this information is available, this function returns the
   global location of the mouse cursor, relative to the desktop. You should not
   normally use this function, as the information is not useful except for
   special scenarios as moving a window.
   @return(@true on success, @false on failure.) *)
  FUNCTION al_get_mouse_cursor_position (OUT ret_x, ret_y: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_grab_mouse (display: ALLEGRO_DISPLAYptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Stop confining the mouse cursor to any display belonging to the program.

   @bold(Note:) not yet implemented on Mac OS X.
   @seealso(al_grab_mouse) *)
  FUNCTION al_ungrab_mouse: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_set_mouse_wheel_precision (precision: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Gets the precision of the mouse wheel (the z and w coordinates).
   @seealso(al_set_mouse_wheel_precision) *)
  FUNCTION al_get_mouse_wheel_precision: AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

(* Retrieve the mouse event source. All mouse events are generated by this
   event source.
   @return(@nil if the mouse subsystem was not installed.)
   @seealso(al_register_event_source) *)
  FUNCTION al_get_mouse_event_source: ALLEGRO_EVENT_SOURCEptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * touch_input.h
 *
 *   Touch input routines.
 *****************************************************************************)

{ TODO: Not yet. }



(*
 * haptic.h
 *
 *   Haptic (that is, force feedback) routines for Allegro.
 *
 *   By Beoran.
 *****************************************************************************)

{ TODO: Not yet.  Needs touch_input.h. }



(*
 * memory.h
 *
 *   Memory management routines.
 *****************************************************************************)

 TYPE
 (* Used to define the memory management functions.
    @seealso(al_set_memory_interface) *)
   ALLEGRO_MEMORY_INTERFACE = RECORD
     mi_malloc: FUNCTION (n: AL_SIZE_T; line: AL_INT; CONST afile, func: AL_STR): AL_POINTER; CDECL;
     mi_free: PROCEDURE (ptr: AL_POINTER; line: AL_INT; CONST afile, func: AL_STR); CDECL;
     mi_realloc: FUNCTION (ptr: AL_POINTER; n: AL_SIZE_T; line: AL_INT; CONST afile, func: AL_STR): AL_POINTER; CDECL;
     mi_calloc: FUNCTION (n, count: AL_SIZE_T; line: AL_INT; CONST afile, func: AL_STR): AL_POINTER; CDECL;
   END;

(* Overrides the memory management functions with implementations of
   @link(al_malloc_with_context), @link(al_free_with_context),
   @link(al_realloc_with_context) and @link(al_calloc_with_context). The
   context arguments may be used for debugging. The new functions should be
   thread safe.
   @seealso(ALLEGRO_MEMORY_INTERFACE) @seealso(al_restore_memory_interface) *)
  PROCEDURE al_set_memory_interface (VAR iface: ALLEGRO_MEMORY_INTERFACE);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Restores the default behavior of the memory management functions.
   @seealso(al_set_memory_interface) *)
  PROCEDURE al_restore_memory_interface; INLINE;


(* Like @code(malloc) in the C standard library, but the implementation may be
   overridden.
   @seealso(al_free) @seealso(al_realloc) @seealso(al_calloc)
   @seealso(al_malloc_with_context) @seealso(al_set_memory_interface) *)
  FUNCTION al_malloc (CONST n: AL_SIZE_T): AL_POINTER; INLINE;
(* Like @code(free) in the C standard library, but the implementation may be
   overridden.

   Additionally, on Windows, a memory block allocated by one DLL must be freed
   from the same DLL. In the few places where an Allegro function returns a
   pointer that must be freed, you must use al_free for portability to Windows.
   @seealso(al_malloc) @seealso(al_free_with_context) *)
  PROCEDURE al_free (p: AL_POINTER); INLINE;
(* Like @code(realloc) in the C standard library, but the implementation may be
   overridden.
   @seealso(al_malloc) @seealso(al_realloc_with_context) *)
  FUNCTION al_realloc (p: AL_POINTER; CONST n: AL_SIZE_T): AL_POINTER; INLINE;
(* Like @code(calloc) in the C standard library, but the implementation may be
   overridden.
   @seealso(al_malloc) @seealso(al_calloc_with_context) *)
  FUNCTION al_calloc (CONST c, n: AL_SIZE_T): AL_POINTER; INLINE;



(* This calls @code(malloc) from the Allegro library (this matters on Windows),
   unless overridden with @link(al_set_memory_interface).

   Generally you should use the @link(al_malloc) function. *)
  FUNCTION al_malloc_with_context
    (n: AL_SIZE_T; line: AL_INT; CONST afile, func: AL_STR): AL_POINTER;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* This calls @code(free) from the Allegro library (this matters on Windows),
   unless overridden with @link(al_set_memory_interface).

   Generally you should use the @link(al_free) function. *)
  PROCEDURE al_free_with_context
    (ptr: AL_POINTER; line: AL_INT; CONST afile, func: AL_STR);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* This calls @code(realloc) from the Allegro library (this matters on Windows),
   unless overridden with @link(al_set_memory_interface).

   Generally you should use the @link(al_realloc) function. *)
  FUNCTION al_realloc_with_context
    (ptr: AL_POINTER; n: AL_SIZE_T; line: AL_INT;
     CONST afile, func: AL_STR): AL_POINTER;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* This calls @code(calloc) from the Allegro library (this matters on Windows),
   unless overridden with @link(al_set_memory_interface).

   Generally you should use the @link(al_calloc) function. *)
  FUNCTION al_calloc_with_context
    (n, count: AL_SIZE_T; line: AL_INT; CONST afile, func: AL_STR): AL_POINTER;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * monitor.h
 *****************************************************************************)

  CONST
    ALLEGRO_DEFAULT_DISPLAY_ADAPTER = -1;

  TYPE
    ALLEGRO_MONITOR_INFOptr = ^ALLEGRO_MONITOR_INFO;
    ALLEGRO_MONITOR_INFO = RECORD
      x1, y1, x2, y2: AL_INT;
    END;

  FUNCTION al_get_num_video_adapters: AL_INT; CDECL;
    EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_monitor_info (adapter: AL_INT; OUT info: ALLEGRO_MONITOR_INFO): AL_BOOL; CDECL;
    EXTERNAL ALLEGRO_LIB_NAME;



(*
 * mouse_cursor.h
 *****************************************************************************)

  TYPE
  (* Pointer to a custom mouse cursor *)
    ALLEGRO_MOUSE_CURSORptr = AL_POINTER;

  (* Used to identify the mouse cursor. @seealso(al_set_system_mouse_cursor) *)
    ALLEGRO_SYSTEM_MOUSE_CURSOR = (
      ALLEGRO_SYSTEM_MOUSE_CURSOR_NONE        =  0,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_DEFAULT     =  1,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_ARROW       =  2,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_BUSY        =  3,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_QUESTION    =  4,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_EDIT        =  5,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_MOVE        =  6,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_N    =  7,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_W    =  8,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_S    =  9,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_E    = 10,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_NW   = 11,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_SW   = 12,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_SE   = 13,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_NE   = 14,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_PROGRESS    = 15,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_PRECISION   = 16,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_LINK        = 17,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_ALT_SELECT  = 18,
      ALLEGRO_SYSTEM_MOUSE_CURSOR_UNAVAILABLE = 19,
      ALLEGRO_NUM_SYSTEM_MOUSE_CURSORS
    );

  FUNCTION al_create_mouse_cursor (sprite: ALLEGRO_BITMAPptr; xfocus, yfocus: AL_INT): ALLEGRO_MOUSE_CURSORptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Frees the memory used by the given cursor.

   It has no effect if @code(cursor) is @nil.
   @seealso(al_create_mouse_cursor) *)
  PROCEDURE al_destroy_mouse_cursor (cursor: ALLEGRO_MOUSE_CURSORptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_set_mouse_cursor (display: ALLEGRO_DISPLAYptr; cursor: ALLEGRO_MOUSE_CURSORptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_set_system_mouse_cursor (display: ALLEGRO_DISPLAYptr; cursor_id: ALLEGRO_SYSTEM_MOUSE_CURSOR): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Make a mouse cursor visible in the given display.
   @return(@true if a mouse cursor is shown as a result of the call @(or one
    already was visible@), @false otherwise.)
   @seealso( al_hide_mouse_cursor) *)
  FUNCTION al_show_mouse_cursor (display: ALLEGRO_DISPLAYptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Hide the mouse cursor in the given display. This has no effect on what the
   current mouse cursor looks like; it just makes it disappear.
   @return(@true on success @(or if the cursor already was hidden@), @false
    otherwise.)
   @seealso(al_show_mouse_cursor) *)
  FUNCTION al_hide_mouse_cursor (display: ALLEGRO_DISPLAYptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * render_state.h
 *****************************************************************************)

  TYPE
  { Used by @link(al_set_render_state). }
    ALLEGRO_RENDER_STATE = (
    (* ALLEGRO_ALPHA_TEST was the name of a rare bitmap flag only used on the
       Wiz port.  Reuse the name but retain the same value. *)
    { If this is set to 1, the values of @code(ALLEGRO_ALPHA_FUNCTION) and
      @code(ALLEGRO_ALPHA_TEST_VALUE) define a comparison function which is
      performed for each pixel. Only if it evaluates to true the pixel is
      written. Otherwise no subsequent processing @(like depth test or
	blending@) is performed. }
      ALLEGRO_ALPHA_TEST = $0010,
    { This determines how the framebuffer and depthbuffer are updated whenever
      a pixel is written @(in case alpha and/or depth testing is enabled: after
      all such enabled tests succeed@). Depth values are only written if
      @code(ALLEGRO_DEPTH_TEST) is 1, in addition to the write mask flag being
      set. }
      ALLEGRO_WRITE_MASK,
    { If this is set to 1, compare the depth value of any newly written pixels
      with the depth value already in the buffer, according to
      @code(ALLEGRO_DEPTH_FUNCTION). Allegro primitives with no explicit z
      coordinate will write a value of 0 into the depth buffer. }
      ALLEGRO_DEPTH_TEST,
    { One of @code(ALLEGRO_RENDER_NEVER) @code(ALLEGRO_RENDER_ALWAYS)
      @code(ALLEGRO_RENDER_LESS) @code(ALLEGRO_RENDER_EQUAL)
      @code(ALLEGRO_RENDER_LESS_EQUAL) @code(ALLEGRO_RENDER_GREATER)
      @code(ALLEGRO_RENDER_NOT_EQUAL) @code(ALLEGRO_RENDER_GREATER_EQUAL), only
      used when @code(ALLEGRO_DEPTH_TEST) is 1. }
      ALLEGRO_DEPTH_FUNCTION,
    { One of @code(ALLEGRO_RENDER_NEVER) @code(ALLEGRO_RENDER_ALWAYS)
      @code(ALLEGRO_RENDER_LESS) @code(ALLEGRO_RENDER_EQUAL)
      @code(ALLEGRO_RENDER_LESS_EQUAL) @code(ALLEGRO_RENDER_GREATER)
      @code(ALLEGRO_RENDER_NOT_EQUAL) @code(ALLEGRO_RENDER_GREATER_EQUAL), only
      used when @code(ALLEGRO_ALPHA_TEST) is 1.}
      ALLEGRO_ALPHA_FUNCTION,
    { Only used when @code(ALLEGRO_ALPHA_TEST) is 1. }
      ALLEGRO_ALPHA_TEST_VALUE
    );

  CONST
    { @exclude }
    ALLEGRO_RENDER_NEVER = 0;
    { @exclude }
    ALLEGRO_RENDER_ALWAYS = 1;
    { @exclude }
    ALLEGRO_RENDER_LESS = 2;
    { @exclude }
    ALLEGRO_RENDER_EQUAL = 3;
    { @exclude }
    ALLEGRO_RENDER_LESS_EQUAL = 4;
    { @exclude }
    ALLEGRO_RENDER_GREATER = 5;
    { @exclude }
    ALLEGRO_RENDER_NOT_EQUAL = 6;
    { @exclude }
    ALLEGRO_RENDER_GREATER_EQUA = 7;

    { @exclude }
    ALLEGRO_MASK_RED = 1 SHL 0;
    { @exclude }
    ALLEGRO_MASK_GREEN = 1 SHL 1;
    { @exclude }
    ALLEGRO_MASK_BLUE = 1 SHL 2;
    { @exclude }
    ALLEGRO_MASK_ALPHA = 1 SHL 3;
    { @exclude }
    ALLEGRO_MASK_DEPTH = 1 SHL 4;
    { @exclude }
    ALLEGRO_MASK_RGB = (ALLEGRO_MASK_RED OR ALLEGRO_MASK_GREEN OR ALLEGRO_MASK_BLUE);
    { @exclude }
    ALLEGRO_MASK_RGBA = (ALLEGRO_MASK_RGB OR ALLEGRO_MASK_ALPHA);

(* Set one of several render attributes.

   This function does nothing if the target bitmap is a memory bitmap.
   @param(state Possible render states which can be one of
     @link(ALLEGRO_RENDER_STATE).) *)
  PROCEDURE al_set_render_state (state: ALLEGRO_RENDER_STATE; value: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * transformations.h
 *****************************************************************************)

  TYPE
    ALLEGRO_TRANSFORMptr = ^ALLEGRO_TRANSFORM;
    ALLEGRO_TRANSFORM = RECORD
      m: ARRAY [0..3] OF ARRAY [0..3] OF AL_FLOAT;
    END;

(* Transformations*)
  PROCEDURE al_use_transform (VAR trans: ALLEGRO_TRANSFORM);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_use_projection_transform (VAR trans: ALLEGRO_TRANSFORM);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_copy_transform (OUT dest: ALLEGRO_TRANSFORM; VAR src: ALLEGRO_TRANSFORM);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_identity_transform (OUT trans: ALLEGRO_TRANSFORM);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_build_transform (OUT trans: ALLEGRO_TRANSFORM; x, y, sx, sy, theta: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_build_camera_transform (OUT trans: ALLEGRO_TRANSFORM;
    position_x, position_y, position_z,
    look_x, look_y, look_z,
    up_x, up_y, up_z: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_translate_transform (VAR trans: ALLEGRO_TRANSFORM; x, y: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_translate_transform_3d (VAR trans: ALLEGRO_TRANSFORM; x, y, z: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_rotate_transform (VAR trans: ALLEGRO_TRANSFORM; theta: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_rotate_transform_3d (VAR trans: ALLEGRO_TRANSFORM; x, y, z, theta: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_scale_transform (VAR trans: ALLEGRO_TRANSFORM; sx, sy: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_scale_transform_3D (VAR trans: ALLEGRO_TRANSFORM; sx, sy, sz: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_transform_coordinates (VAR trans: ALLEGRO_TRANSFORM; OUT x, y: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_transform_coordinates_3d (VAR trans: ALLEGRO_TRANSFORM; OUT x, y, z: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_compose_transform (VAR trans, other: ALLEGRO_TRANSFORM);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_current_transform: ALLEGRO_TRANSFORMptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_current_inverse_transform: ALLEGRO_TRANSFORMptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_current_projection_transform: ALLEGRO_TRANSFORMptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_invert_transform (VAR trans: ALLEGRO_TRANSFORM);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_check_inverse (VAR trans: ALLEGRO_TRANSFORM; tol: AL_FLOAT): AL_INT;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_orthographic_transform (VAR trans: ALLEGRO_TRANSFORM; left, top, n, right, bottom, f: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_perspective_transform (VAR trans: ALLEGRO_TRANSFORM; left, top, n, right, bottom, f: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_horizontal_shear_transform (VAR trans: ALLEGRO_TRANSFORM; theta: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_vertical_shear_transform (VAR trans: ALLEGRO_TRANSFORM; theta: AL_FLOAT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * shader.h
 *****************************************************************************)

  TYPE
  (* An @code(ALLEGRO_SHADER) is a program that runs on the GPU.  It combines
     both a vertex and a pixel shader. (In OpenGL terms, an
     @code(ALLEGRO_SHADER) is actually a program which has one or more shaders
     attached. This can be confusing.)

     The source code for the underlying vertex or pixel shader can be provided
     either as GLSL or HLSL, depending on the value of
     @link(ALLEGRO_SHADER_PLATFORM) used when creating it. *)
    ALLEGRO_SHADERptr = AL_POINTER;

  (* Used with @link(al_attach_shader_source) and
     @link(al_attach_shader_source_file) to specify how to interpret the
     attached source.  *)
    ALLEGRO_SHADER_TYPE = (
    (* A vertex shader is executed for each vertex it is used with. The program
       will output exactly one vertex at a time.

       When Allegro's graphics are being used then in addition to all vertices
       of primitives from the primitives addon, each drawn bitmap also consists
       of four vertices. *)
      ALLEGRO_VERTEX_SHADER = 1,
    (* A pixel shader is executed for each pixel it is used with.  The program
       will output exactly one pixel at a time - either in the backbuffer or in
       the current target bitmap.

       With Allegro's builtin graphics this means the shader is for example
       called for each destination pixel of the output of an
       @link(al_draw_bitmap) call.

       A more accurate term for pixel shader would be fragment shader since one
       final pixel in the target bitmap is not necessarily composed of only a
       single output but of multiple fragments (for example when multi-sampling
       is being used). *)
      ALLEGRO_PIXEL_SHADER = 2
    );

  (* The underlying platform which the @code(ALLEGRO_SHADER) is built on top
     of, which dictates the language used to program the shader. *)
    ALLEGRO_SHADER_PLATFORM = (
      ALLEGRO_SHADER_AUTO = 0,
    (* OpenGL Shading Language. *)
      ALLEGRO_SHADER_GLSL = 1,
    (* High Level Shader Language (for Direct3D). *)
      ALLEGRO_SHADER_HLSL = 2
    );


  CONST
  { @exclude }
    ALLEGRO_SHADER_VAR_COLOR           = 'al_color';
  { @exclude }
    ALLEGRO_SHADER_VAR_POS             = 'al_pos';
  { @exclude }
    ALLEGRO_SHADER_VAR_PROJVIEW_MATRIX = 'al_projview_matrix';
  { @exclude }
    ALLEGRO_SHADER_VAR_TEX             = 'al_tex';
  { @exclude }
    ALLEGRO_SHADER_VAR_TEXCOORD        = 'al_texcoord';
  { @exclude }
    ALLEGRO_SHADER_VAR_TEX_MATRIX      = 'al_tex_matrix';
  { @exclude }
    ALLEGRO_SHADER_VAR_USER_ATTR       = 'al_user_attr_';
  { @exclude }
    ALLEGRO_SHADER_VAR_USE_TEX         = 'al_use_tex';
  { @exclude }
    ALLEGRO_SHADER_VAR_USE_TEX_MATRIX  = 'al_use_tex_matrix';

  (* Creates a shader object.

     The platform argument is one of the @code(ALLEGRO_SHADER_PLATFORM) values,
     and specifies the type of shader object to create, and which language is
     used to program the shader.

     The shader platform must be compatible with the type of display that you
     will use the shader with.  For example, you cannot create and use a HLSL
     shader on an OpenGL display, nor a GLSL shader on a Direct3D display.

     The @code(ALLEGRO_SHADER_AUTO) value automatically chooses the appropriate
     platform for the display currently targeted by the calling thread; there
     must be such a display.  It will create a GLSL shader for an OpenGL
     display, and a HLSL shader for a Direct3D display.
     @return(The shader object on success. Otherwise, returns @nil.)
     @seealso(al_attach_shader_source) @seealso(al_attach_shader_source_file)
     @seealso(al_build_shader) @seealso(al_use_shader)
     @seealso(al_destroy_shader) @seealso(al_get_shader_platform) *)
  FUNCTION al_create_shader (platform: ALLEGRO_SHADER_PLATFORM): ALLEGRO_SHADERptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Attaches the shader's source code to the shader object and compiles it.
   Passing @nil deletes the underlying (OpenGL or DirectX) shader.  See also
   @link(al_attach_shader_source_file) if you prefer to obtain your shader
   source from an external file.

   If you do not use @code(ALLEGRO_PROGRAMMABLE_PIPELINE) Allegro's graphics
   functions will not use any shader specific functions themselves. In case of
   a system with no fixed function pipeline (like OpenGL ES 2 or OpenGL 3 or 4)
   this means Allegro's drawing functions cannot be used.

   TODO: Is @code(ALLEGRO_PROGRAMMABLE_PIPELINE) set automatically in this
   case?

   When @code(ALLEGRO_PROGRAMMABLE_PIPELINE) is used the following shader
   uniforms are provided by Allegro and can be accessed in your shaders:
   @unorderedlist(
    @item(@bold(al_projview_matrix) matrix for Allegro's orthographic
      projection multiplied by the al_use_transform matrix. The type is
      @code(mat4) in GLSL, and @code(float4x4) in HLSL.)
    @item(@bold(al_use_tex) whether or not to use the bound texture. The type
      is @code(bool) in both GLSL and HLSL.)
    @item(@bold(al_tex) the texture if one is bound. The type is
      @code(sampler2D) in GLSL and @code(texture) in HLSL.)
    @item(@bold(al_use_tex_matrix) whether or not to use a texture matrix
      @(used by the primitives addon@). The type is @code(bool) in both GLSL
      and HLSL.)
    @item(@bold(al_tex_matrix) the texture matrix @(used by the primitives
      addon@). Your shader should multiply the texture coordinates by this
      matrix. The type is @code(mat4) in GLSL, and @code(float4x4) in HLSL.)
   )

   For GLSL shaders the vertex attributes are passed using the following variables:
   @unorderedlist(
    @item(@bold(al_pos) vertex position attribute. Type is @code(vec4).)
    @item(@bold(al_texcoord) vertex texture coordinate attribute. Type is
      @code(vec2).)
    @item(@bold(al_color) vertex color attribute. Type is @code(vec4).)
   )

   For HLSL shaders the vertex attributes are passed using the following semantics:
   @unorderedlist(
    @item(@bold(POSITION0) vertex position attribute. Type is @code(float4).)
    @item(@bold(TEXCOORD0) vertex texture coordinate attribute. Type is
     @code(float2).)
    @item(@bold(TEXCOORD1) vertex color attribute. Type is @code(float4).)
   )

   Also, each shader variable has a corresponding macro name that can be used
   when defining the shaders using string literals. Don't use these macros with
   the other shader functions as that will lead to undefined behavior.
   @unorderedlist(
    @item(@code(ALLEGRO_SHADER_VAR_PROJVIEW_MATRIX) for "al_projview_matrix")
    @item(@code(ALLEGRO_SHADER_VAR_POS) for "al_pos")
    @item(@code(ALLEGRO_SHADER_VAR_COLOR) for "al_color")
    @item(@code(ALLEGRO_SHADER_VAR_TEXCOORD) for "al_texcoord")
    @item(@code(ALLEGRO_SHADER_VAR_USE_TEX) for "al_use_tex")
    @item(@code(ALLEGRO_SHADER_VAR_TEX) for "al_tex")
    @item(@code(ALLEGRO_SHADER_VAR_USE_TEX_MATRIX) for "al_use_tex_matrix")
    @item(@code(ALLEGRO_SHADER_VAR_TEX_MATRIX for) "al_tex_matrix")
   )
   Examine the output of @link(al_get_default_shader_source) for an example of
   how to use the above uniforms and attributes.
   @return(@true on success and @false on error, in which case the error log is
     updated. The error log can be retrieved with @link(al_get_shader_log).)
   @seealso(al_attach_shader_source_file) @seealso(al_build_shader)
   @seealso(al_get_default_shader_source) @seealso(al_get_shader_log) *)
  FUNCTION al_attach_shader_source (shader: ALLEGRO_SHADERptr; aType: ALLEGRO_SHADER_TYPE; CONST Source: AL_STR): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Like @link(al_attach_shader_source) but reads the source code for the shader
   from the named file.
   @return(@true on success and @false on error, in which case the error log is
     updated. The error log can be retrieved with @link(al_get_shader_log).)
   @seealso(al_attach_shader_source) @seealso(al_build_shader)
   @seealso(al_get_shader_log) *)
  FUNCTION al_attach_shader_source_file (shader: ALLEGRO_SHADERptr; aType: ALLEGRO_SHADER_TYPE; CONST filename: AL_STR): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* This is required before the shader can be used with @link(al_use_shader). It
   should be called after successfully attaching the pixel and/or vertex
   shaders with @link(al_attach_shader_source) or
   @link(al_attach_shader_source_file).

   @bold(Note:) If you are using the @code(ALLEGRO_PROGRAMMABLE_PIPELINE) flag,
   then you must specify both a pixel and a vertex shader sources for anything
   to be rendered.

   @return(@true on success and @false on error, in which case the error log is
     updated. The error log can be retrieved with @link(al_get_shader_log).)
   @seealso(al_use_shader) @seealso(al_get_shader_log) *)
  FUNCTION al_build_shader (shader: ALLEGRO_SHADERptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Return a read-only string containing the information log for a shader
   program. The log is updated by certain functions, such as
   @code(al_attach_shader_source) or @code(al_build_shader) when there is an
   error.

   This function never returns @nil.
   @seealso(al_attach_shader_source) @seealso(al_attach_shader_source_file)
   @seealso(al_build_shader) *)
  FUNCTION al_get_shader_log (shader: ALLEGRO_SHADERptr): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Returns the platform the shader was created with (either
   @code(ALLEGRO_SHADER_HLSL) or @code(ALLEGRO_SHADER_GLSL)).
   @seealso(al_create_shader) *)
  FUNCTION al_get_shader_platform (shader: ALLEGRO_SHADERptr): ALLEGRO_SHADER_PLATFORM;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Uses the shader for subsequent drawing operations on the current target
   bitmap. Pass @nil to stop using any shader on the current target bitmap.

   @return(@true on success. Otherwise returns @false, e.g. because the shader
     is incompatible with the target bitmap.)
   @seealso(al_destroy_shader) @seealso(al_set_shader_sampler)
   @seealso(al_set_shader_matrix) @seealso(al_set_shader_int)
   @seealso(al_set_shader_float) @seealso(al_set_shader_bool)
   @seealso(al_set_shader_int_vector) @seealso(al_set_shader_float_vector) *)
  FUNCTION al_use_shader (shader: ALLEGRO_SHADERptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Destroy a shader. Any bitmaps which currently use the shader will implicitly
   stop using the shader. In multi-threaded programs, be careful that no such
   bitmaps are being accessed by other threads at the time.

   As a convenience, if the target bitmap of the calling thread is using the
   shader then the shader is implicitly unused before being destroyed.

   This function does nothing if the shader argument is @nil.
   @seealso(al_create_shader) *)
  PROCEDURE al_destroy_shader (shader: ALLEGRO_SHADERptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

(* Sets a texture sampler uniform and texture unit of the current target
   bitmap's shader. The given bitmap must be a video bitmap.

   Different samplers should use different units. The bitmap passed to
   Allegro's drawing functions uses the 0th unit, so if you're planning on
   using the @code(al_tex) variable in your pixel shader as well as another
   sampler, set the other sampler to use a unit different from 0. With the
   primitives addon, it is possible to free up the 0th unit by passing @nil as
   the texture argument to the relevant drawing functions. In this case, you
   may set a sampler to use the 0th unit and thus not use @code(al_tex) (the
   @code(al_use_tex) variable will be set to false).
   @return(@true on success. Otherwise returns @false, e.g. if the uniform by
     that name does not exist in the shader.)
   @seealso(al_use_shader) *)
  FUNCTION al_set_shader_sampler (CONST name: AL_STR; bitmap: ALLEGRO_BITMAPptr; aUnit: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Sets a matrix uniform of the current target bitmap's shader.
   @return(@true on success. Otherwise returns @false, e.g. if the uniform by
     that name does not exist in the shader.)
   @seealso(al_use_shader) *)
  FUNCTION al_set_shader_matrix (CONST name: AL_STR; VAR matrix: ALLEGRO_TRANSFORM): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Sets an integer uniform of the current target bitmap's shader.
   @return(@true on success. Otherwise returns @false, e.g. if the uniform by
     that name does not exist in the shader.)
   @seealso(al_use_shader) *)
  FUNCTION al_set_shader_int (CONST name: AL_STR; i: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Sets a float uniform of the current target bitmap's shader.
   @return(@true on success. Otherwise returns @false, e.g. if the uniform by
     that name does not exist in the shader.)
   @seealso(al_use_shader) *)
  FUNCTION al_set_shader_float (CONST name: AL_STR; f: AL_FLOAT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Sets a boolean uniform of the current target bitmap's shader.
   @return(@true on success. Otherwise returns @false, e.g. if the uniform by
     that name does not exist in the shader.)
   @seealso(al_use_shader) *)
  FUNCTION al_set_shader_bool (CONST name: AL_STR; b: AL_BOOL): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Sets an integer vector array uniform of the current target bitmap's shader.
   The @code(num_components) parameter can take one of the values 1, 2, 3 or 4.
   If it is 1 then an array of @code(num_elems) integer elements is added.
   Otherwise each added array element is assumed to be a vector with 2, 3 or 4
   components in it.

   For example, if you have a GLSL uniform declared as uniform @code(ivec3
   flowers[4]) or an HLSL uniform declared as uniform @code(int3 flowers[4]),
   then you'd use this function from your code like so:
@longcode(#
VAR
  Flowers: ARRAY [0..3] OF ARRAY [0..2] OF AL_INT =
  (
   (1, 2, 3),
   (4, 5, 6),
   (7, 8, 9),
   (2, 5, 7)
  );
BEGIN
  ...
  al_set_shader_int_vector ('flowers', 3, @Flowers, 4);
  ...
END
#)
   @return(@true on success. Otherwise returns @false, e.g. if the uniform by
     that name does not exist in the shader.)
   @seealso(al_set_shader_float_vector) @seealso(al_use_shader) *)
  FUNCTION al_set_shader_int_vector (CONST name: AL_STR; num_components: AL_INT; i: AL_INTptr; num_elems: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Same as @link(al_set_shader_int_vector) except all values are float instead
   of intteger.
   @seealso(al_set_shader_int_vector) @seealso(al_use_shader) *)
  FUNCTION al_set_shader_float_vector (CONST name: AL_STR; num_components: AL_INT; f: AL_FLOATptr; num_elems: AL_INT): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

(* Returns a string containing the source code to Allegro's default vertex or
   pixel shader appropriate for the passed platform. The
   @code(ALLEGRO_SHADER_AUTO) value means GLSL is used if OpenGL is being used
   otherwise HLSL.  @code(ALLEGRO_SHADER_AUTO) requires that there is a current
   display set on the calling thread. This function can return @nil if Allegro
   was built without support for shaders of the selected platform.
   @seealso(al_attach_shader_source) *)
  FUNCTION al_get_default_shader_source (platform: ALLEGRO_SHADER_PLATFORM; aType: ALLEGRO_SHADER_TYPE): AL_STRptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * system.h
 *****************************************************************************)

  TYPE
  (* Pointer to the Allegro system description record.
     For internal use only. *)
    ALLEGRO_SYSTEMptr = AL_POINTER;

(* Like @link(al_install_system), but automatically passes in the version and
   uses the @code(atexit) function visible in the current compilation unit.

   @bold(Note:) It is typically wrong to call al_init anywhere except the final
   game binary. In particular, do not call it inside a shared library unless
   you know what you're doing. In those cases, it is better to call
   @link(al_install_system) either with a @nil @code(atexit_ptr), or with a
   pointer to @code(atexit) provided by the user of this shared library.  *)
  FUNCTION al_init: AL_BOOL;



(* Initializes the Allegro system.  No other Allegro functions can be called
   before this (with one or two exceptions).
   @param(version Should always be set to @link(ALLEGRO_VERSION_INT).)
   @param(atexit_ptr If non-@nil, and if hasn't been done already,
    @code(al_uninstall_system) will be registered as an atexit function.)
   @returns(@true if Allegro was successfully initialized by this function
    call @(or already was initialized previously@), @false if Allegro cannot
    be used.)
   @seealso(al_init)
 *)
  FUNCTION al_install_system (version: AL_INT; atexit_ptr: AL_POINTER): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Closes down the Allegro system.

   In most cases you don't need to call this, because it's called by the
   @code(FINALIZATION) section.
   @seealso(al_init) @seealso(al_install_system)
 *)
  PROCEDURE al_uninstall_system;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

(* Returns @true if Allegro is initialized, otherwise returns @false. *)
  FUNCTION al_is_system_installed: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



{ TODO: Some stuff needs the "path.h" section. }



(* This function allows the user to stop the system screensaver from starting
   up if @true is passed, or resets the system back to the default state (the
   state at program start) if @false is passed.
   @returns(@true if the state was set successfully, otherwise @false.)
 *)
  FUNCTION al_inhibit_screensaver (inhibit: AL_BOOL): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * timer.h
 *
 *  Timer routines.
 *****************************************************************************)

(* Converts microseconds to seconds. *)
  FUNCTION ALLEGRO_USECS_TO_SECS (x: AL_INT): AL_DOUBLE; INLINE;
(* Converts milliseconds to seconds. *)
  FUNCTION ALLEGRO_MSECS_TO_SECS (x: AL_INT): AL_DOUBLE; INLINE;
(* Converts beats per second to seconds. *)
  FUNCTION ALLEGRO_BPS_TO_SECS (x: AL_INT): AL_DOUBLE; INLINE;
(* Converts beats per minute to seconds. *)
  FUNCTION ALLEGRO_BPM_TO_SECS (x: AL_INT): AL_DOUBLE; INLINE;



(* Allocates and initializes a timer. The new timer is initially stopped.

   Usage note:  typical granularity is on the order of microseconds, but with
   some drivers might only be milliseconds.
   @param(speed_secs Seconds per "tick". Must be positive.)
   @returns(If successful, a pointer to a new timer object is returned,
     otherwise @nil is returned.)
  @seealso(al_start_timer) @seealso(al_destroy_timer) *)
  FUNCTION al_create_timer (speed_secs: AL_DOUBLE): ALLEGRO_TIMERptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_destroy_timer (timer: ALLEGRO_TIMERptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Starts the timer specified.  From then, the timer's counter will increment
   at a constant rate, and it will begin generating events.  Starting a timer
   that is already started does nothing.  Starting a timer that was stopped
   will reset the timer's counter, effectively restarting the timer from the
   beginning.
   @seealso(al_stop_timer) @seealso(al_get_timer_started)
   @seealso(al_resume_timer) *)
  PROCEDURE al_start_timer (timer: ALLEGRO_TIMERptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_stop_timer (timer: ALLEGRO_TIMERptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_resume_timer (timer: ALLEGRO_TIMERptr);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_timer_started (CONST timer: ALLEGRO_TIMERptr): AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_timer_speed (CONST timer: ALLEGRO_TIMERptr): AL_DOUBLE;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_set_timer_speed (timer: ALLEGRO_TIMERptr; speed_secs: AL_DOUBLE);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_timer_count (CONST timer: ALLEGRO_TIMERptr): AL_INT64;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_set_timer_count (timer: ALLEGRO_TIMERptr; count: AL_INT64);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  PROCEDURE al_add_timer_count (timer: ALLEGRO_TIMERptr; diff: AL_INT64);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
  FUNCTION al_get_timer_event_source (timer: ALLEGRO_TIMERptr): ALLEGRO_EVENT_SOURCEptr;
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;



(*
 * tls.h
 *      Thread local storage routines.
 *****************************************************************************)

  CONST
  { @exclude }
    ALLEGRO_STATE_NEW_DISPLAY_PARAMETERS = $0001;
  { @exclude }
    ALLEGRO_STATE_NEW_BITMAP_PARAMETERS  = $0002;
  { @exclude }
    ALLEGRO_STATE_DISPLAY                = $0004;
  { @exclude }
    ALLEGRO_STATE_TARGET_BITMAP          = $0008;
  { @exclude }
    ALLEGRO_STATE_BITMAP                 = $000A; { ALLEGRO_STATE_TARGET_BITMAP + ALLEGRO_STATE_NEW_BITMAP_PARAMETERS, }
  { @exclude }
  { @exclude }
    ALLEGRO_STATE_BLENDER                = $0010;
  { @exclude }
    ALLEGRO_STATE_NEW_FILE_INTERFACE     = $0020;
  { @exclude }
    ALLEGRO_STATE_TRANSFORM              = $0040;
  { @exclude }
    ALLEGRO_STATE_PROJECTION_TRANSFORM   = $0100;
  { @exclude }
    ALLEGRO_STATE_ALL                    = $FFFF;



  TYPE
  (* Opaque type which is passed to
     @link(al_store_state)/@link(al_restore_state).

     The various state kept internally by Allegro can be displayed like this:
@longcode(#
  global
      active system driver
          current config
  per thread
      new bitmap params
      new display params
      active file interface
      errno
      current blending mode
      current display
          deferred drawing
      current target bitmap
          current transformation
          current projection transformation
          current clipping rectangle
          bitmap locking
          current shader
#)
     In general, the only real global state is the active system driver. All
     other global state is per-thread, so if your application has multiple
     separate threads they never will interfere with each other. (Except if
     there are objects accessed by multiple threads of course. Usually you want
     to minimize that though and for the remaining cases use synchronization
     primitives described in the threads section or events described in the
     events section to control inter-thread communication.)
  *)
    ALLEGRO_STATE = RECORD
    { Internally, a thread_local_state structure is placed here. }
      _tls: ARRAY [0..1023] OF AL_CHAR;
    END;

(* Stores part of the state of the current thread in the given
   @code(ALLEGRO_STATE) object. The flags parameter can take any
   bit-combination of these flags:
   @unorderedlist(
    @item(@code(ALLEGRO_STATE_NEW_DISPLAY_PARAMETERS) - new_display_format,
      new_display_refresh_rate, new_display_flags)
    @item(@code(ALLEGRO_STATE_NEW_BITMAP_PARAMETERS) - new_bitmap_format,
      new_bitmap_flags)
    @item(@code(ALLEGRO_STATE_DISPLAY) - current_display)
    @item(@code(ALLEGRO_STATE_TARGET_BITMAP) - target_bitmap)
    @item(@code(ALLEGRO_STATE_BLENDER) - blender)
    @item(@code(ALLEGRO_STATE_TRANSFORM) - current_transformation)
    @item(@code(ALLEGRO_STATE_PROJECTION_TRANSFORM) -
      current_projection_transformation)
    @item(@code(ALLEGRO_STATE_NEW_FILE_INTERFACE) - new_file_interface)
    @item(@code(ALLEGRO_STATE_BITMAP) - same as
      @code(ALLEGRO_STATE_NEW_BITMAP_PARAMETERS) and
      @code(ALLEGRO_STATE_TARGET_BITMAP))
    @item(@code(ALLEGRO_STATE_ALL) - all of the above)
   )
   @seealso(al_restore_state) *)
  PROCEDURE al_store_state (OUT state: ALLEGRO_STATE; flags: AL_INT);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;
(* Restores part of the state of the current thread from the given
   @code(ALLEGRO_STATE) object.
   @seealso(al_store_state) *)
  PROCEDURE al_restore_state (VAR state: ALLEGRO_STATE);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME;

IMPLEMENTATION

(*
 * base.h
 *****************************************************************************)

  FUNCTION AL_ID (CONST str: SHORTSTRING): AL_INT;
  BEGIN
    AL_ID := (ORD (str[1]) SHL 24) OR (ORD (str[2]) SHL 16)
	     OR (ORD (str[3]) SHL  8) OR  ORD (str[4])
  END;



(*
 * events.h
 *****************************************************************************)

  FUNCTION ALLEGRO_EVENT_TYPE_IS_USER (t: ALLEGRO_EVENT_TYPE): AL_BOOL;
  BEGIN
    ALLEGRO_EVENT_TYPE_IS_USER := t >= 512
  END;



  FUNCTION ALLEGRO_GET_EVENT_TYPE (CONST str: SHORTSTRING): AL_INT;
  BEGIN
    ALLEGRO_GET_EVENT_TYPE := AL_ID (str)
  END;



(*
 * memory.h
 *****************************************************************************)

  PROCEDURE _al_set_memory_interface_ (iface: AL_POINTER);
    CDECL; EXTERNAL ALLEGRO_LIB_NAME NAME 'al_set_memory_interface';

  PROCEDURE al_restore_memory_interface;
  BEGIN
    _al_set_memory_interface_ (NIL)
  END;



  FUNCTION al_malloc (CONST n: AL_SIZE_T): AL_POINTER;
  BEGIN
    al_malloc := al_malloc_with_context (n, 0, '', '')
  END;



  PROCEDURE al_free (p: AL_POINTER);
  BEGIN
    al_free_with_context (p, 0, '', '')
  END;



  FUNCTION al_realloc (p: AL_POINTER; CONST n: AL_SIZE_T): AL_POINTER;
  BEGIN
    al_realloc := al_realloc_with_context (p, n, 0, '', '')
  END;



  FUNCTION al_calloc (CONST c, n: AL_SIZE_T): AL_POINTER;
  BEGIN
    al_calloc := al_calloc_with_context (c, n, 0, '', '')
  END;



(*
 * system.h
 *****************************************************************************)

  FUNCTION al_init: AL_BOOL;
  BEGIN
    al_init := al_install_system (ALLEGRO_VERSION_INT, NIL)
  END;



(*
 * timer.h
 *****************************************************************************)

  FUNCTION ALLEGRO_USECS_TO_SECS (x: AL_INT): AL_DOUBLE;
  BEGIN
    ALLEGRO_USECS_TO_SECS := x / 1000000
  END;

  FUNCTION ALLEGRO_MSECS_TO_SECS (x: AL_INT): AL_DOUBLE;
  BEGIN
    ALLEGRO_MSECS_TO_SECS := x / 1000
  END;

  FUNCTION ALLEGRO_BPS_TO_SECS (x: AL_INT): AL_DOUBLE;
  BEGIN
    ALLEGRO_BPS_TO_SECS := 1 / x
  END;

  FUNCTION ALLEGRO_BPM_TO_SECS (x: AL_INT): AL_DOUBLE;
  BEGIN
    ALLEGRO_BPM_TO_SECS := 60 / x
  END;

INITIALIZATION
{ Delphi forces an INITIALIZATION section if FINALIZATION is used. }
  ;
{ Next code suggested by FPC mailing list user.  This should fix some issues
  with memory.  Removed as it seems to be fixed by Allegro itself. }

{ $if defined(cpui386) or defined(cpux86_64)}
{ SetExceptionMask(GetExceptionMask + [exZeroDivide, exInvalidOp]); }
{ $ENDIF}

FINALIZATION
{ Ensures that we call it, as Pascal hasn't an "atexit" function. }
  al_uninstall_system
END.

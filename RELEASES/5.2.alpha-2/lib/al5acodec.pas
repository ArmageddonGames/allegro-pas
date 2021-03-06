UNIT al5acodec;
(*<This unit registers bitmap format handlers for @link(al_load_sample),
  @link(al_save_sample), @link(al_load_audio_stream), etc. *)
(* Copyright (c) 2012-2016 Guillermo Martínez J.

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

{$include allegro5.cfg}

INTERFACE

  USES
    al5base;

  CONST
  (* @exclude Builds library name. *)
    ALLEGRO_ACODEC_LIB_NAME = _A5_LIB_PREFIX_+'allegro_acodec'+_DBG_+_A5_LIB_EXT_;


(* Registers all the known audio file type handlers for @link(al_load_sample),
   @link(al_save_sample), @link(al_load_audio_stream), etc.

  Depending on what libraries are available, the full set of recognised
  extensions is: .wav, .flac, .ogg, .it, .mod, .s3m, .xm.

  @bold(Limitations)
  @unorderedlist(
    @item(Saving is only supported for wav files.)
    @item(The wav file loader currently only supports 8/16 bit little endian
      PCM files. 16 bits are used when saving wav files. Use flac files if more
      precision is required.)
    @item(Module files @(.it, .mod, .s3m, .xm@) are often composed with
      streaming in mind, and sometimes cannot be easily rendered into a finite
      length sample. Therefore they cannot be loaded with
      @link(al_load_sample) and must be streamed with
      @link(al_load_audio_stream).)
    @item(.voc file streaming is unimplemented.)
  )
  @return(@true on success.)
 *)
  FUNCTION al_init_acodec_addon: AL_BOOL;
    CDECL; EXTERNAL ALLEGRO_ACODEC_LIB_NAME;

(* Returns the (compiled) version of the addon, in the same format as
  @link(al_get_allegro_version). *)
  FUNCTION al_get_allegro_acodec_version: AL_UINT32;
    CDECL; EXTERNAL ALLEGRO_ACODEC_LIB_NAME;

IMPLEMENTATION

END.

-- -*-haskell-*-
--  Clutter Media
--
--  Author : Matthew Arsenault
--
--  Created: 2 Oct 2009
--
--  Copyright (C) 2009 Matthew Arsenault
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 3 of the License, or (at your option) any later version.
--
--  This library is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  Lesser General Public License for more details.
--
{-# LANGUAGE ForeignFunctionInterface #-}

#include <clutter/clutter.h>

{# context lib="clutter" prefix="clutter" #}


-- | Media — An interface for controlling playback of media data
module Graphics.UI.Clutter.Media (
-- * Description
-- | 'Media' is an interface for controlling playback of media
--   sources.
--
-- Clutter core does not provide an implementation of this interface,
-- but other integration libraries like Clutter-GStreamer implement it
-- to offer a uniform API for applications.
--
-- 'Media' is available since Clutter 0.2
--

-- * Class Hierarchy
-- |
-- @
-- |  'GInterface'
-- |     +----'Media'
-- @

-- * Types
  Media,
  MediaClass,

-- * Methods
  mediaSetURI,
  mediaGetURI,
  mediaSetPlaying,
  mediaGetPlaying,
  mediaSetProgress,
  mediaGetProgress,
  mediaSetAudioVolume,
  mediaGetAudioVolume,
  mediaGetCanSeek,
  mediaGetBufferFill,
  mediaGetDuration,
  mediaSetFilename,

#if CLUTTER_CHECK_VERSION(1,2,0)
  mediaSetSubtitleURI,
  mediaGetSubtitleURI,
  mediaSetSubtitleFontName,
  mediaGetSubtitleFontName,
#endif

-- * Attributes
  mediaAudioVolume,
  mediaBufferFill,
  mediaCanSeek,
  mediaDuration,
  mediaPlaying,
  mediaProgress,
  mediaURI,
#if CLUTTER_CHECK_VERSION(1,2,0)
  mediaSubtitleURI,
  mediaSubtitleFontName,
#endif
-- * Signals
  eos,
  error
  ) where

{# import Graphics.UI.Clutter.Types #}
{# import Graphics.UI.Clutter.Utility #}
{# import Graphics.UI.Clutter.Signals #}

import Prelude hiding (error)
import C2HS
import System.Glib.GError
import System.Glib.Attributes


-- | Sets the URI of media to uri.
--
-- [@media@] a Media
--
-- [@uri@] the URI of the media stream
--
-- * Since 0.2
--
{# fun unsafe media_set_uri as mediaSetURI
  `(MediaClass m)' => { withMediaClass* `m', `String' } -> `()' #}

-- | Retrieves the URI from media.
--
-- [@media@] a Media
--
-- [@Returns@] the URI of the media stream
--
-- * Since 0.2
--
{# fun unsafe media_get_uri as mediaGetURI
       `(MediaClass m)' => { withMediaClass* `m' } -> `String' peekNFreeString* #}


-- | Starts or stops playing of media.
--
-- [@media@] a Media
--
-- [@playing@] @True@ to start playing
--
-- * Since 0.2
--
{# fun unsafe media_set_playing as ^ `(MediaClass m)' => { withMediaClass* `m', `Bool' } -> `()' #}

-- | Retrieves the playing status of media.
--
-- [@media@] A Media object
--
-- [@Returns@] @True@ if playing, @False@ if stopped.
--
-- * Since 0.2
--
{# fun unsafe media_get_playing as ^ `(MediaClass m)' => { withMediaClass* `m' } -> `Bool' #}

-- | Sets the playback progress of media. The progress is a normalized
--   value between 0.0 (begin) and 1.0 (end).
--
-- [@media@] a Media
--
-- [@progress@] the progress of the playback, between 0.0 and 1.0
--
-- * Since 1.0
--
{# fun unsafe media_set_progress as ^
       `(MediaClass m)' => { withMediaClass* `m', `Double' } -> `()' #}

-- | Retrieves the playback progress of media.
--
-- [@media@] a Media
--
-- [@Returns@] the playback progress, between 0.0 and 1.0
--
-- * Since 1.0
--
{# fun unsafe media_get_progress as ^
       `(MediaClass m)' => { withMediaClass* `m' } -> `Double' #}


-- | Sets the playback volume of media to volume.
--
-- [@media@] a Media
--
-- [@volume@] the volume as a double between 0.0 and 1.0
--
-- * Since 1.0
--
{# fun unsafe media_set_audio_volume as ^
       `(MediaClass m)' => { withMediaClass* `m', `Double' } -> `()' #}

-- | Retrieves the playback volume of media.
--
-- [@media@] a Media
--
-- [@Returns@] The playback volume between 0.0 and 1.0
--
-- * Since 1.0
{# fun unsafe media_get_audio_volume as ^
       `(MediaClass m)' => { withMediaClass* `m' } -> `Double' #}

-- | Retrieves whether media is seekable or not.
--
-- [@media@] a Media
--
-- [@Returns@] @True@ if media can seek, @False@ otherwise.
--
-- * Since 0.2
--
{# fun unsafe media_get_can_seek as ^ `(MediaClass m)' => { withMediaClass* `m' } -> `Bool' #}


-- | Retrieves the amount of the stream that is buffered.
--
-- [@media@] a Media
--
-- [@Returns@] the fill level, between 0.0 and 1.0
--
-- * Since 1.0
--
{# fun unsafe media_get_buffer_fill as ^
       `(MediaClass m)' => { withMediaClass* `m' } -> `Double' #}

-- | Retrieves the duration of the media stream that media represents.
--
-- [@media@] a Media
--
-- [@Returns@] the duration of the media stream, in seconds
--
-- * Since 0.2
--
{# fun unsafe media_get_duration as ^
       `(MediaClass m)' => { withMediaClass* `m' } -> `Double' #}

-- | Sets the source of media using a file path.
--
-- [@media@] a Media
--
-- [@filename@] A filename
--
-- * Since 0.2
--
{# fun unsafe media_set_filename as ^
       `(MediaClass m)' => { withMediaClass* `m', `String' } -> `()' #}


#if CLUTTER_CHECK_VERSION(1,2,0)

-- | Sets the location of a subtitle file to display while playing
-- media.
--
-- [@media@] a 'Media'
--
-- [@uri@] the URI of a subtitle file
--
-- * Since 1.2
--
{# fun unsafe media_set_subtitle_uri as mediaSetSubtitleURI
  `(MediaClass m)' => { withMediaClass* `m', withMaybeString* `Maybe String' } -> `()' #}


-- | Retrieves the URI of the subtitle file in use.
--
-- [@media@] a 'Media'
--
-- [@Returns@] the URI of the subtitle file.
--
-- * Since 1.2
--
{# fun unsafe media_get_subtitle_uri as mediaGetSubtitleURI
  `(MediaClass m)' => { withMediaClass* `m' } -> `Maybe String' peekNFreeMaybeString* #}


-- | Sets the font used by the subtitle renderer. The font_name string
-- must be either @Nothing@, which means that the default font name of
-- the underlying implementation will be used; or must follow the
-- grammar recognized by 'Pango.fontDescriptionFromString' like:
--
-- > 'mediaSetSubtitleFontName media "Sans 24pt"
--
-- [@media@] a 'Media'
--
-- [@font_name@] @Just@ a font name, or @Nothing@ to set the default
-- font name
--
-- * Since 1.2
--
{# fun unsafe media_set_subtitle_font_name as ^
  `(MediaClass m)' => { withMediaClass* `m', withMaybeString* `Maybe String' } -> `()' #}

-- | Retrieves the font name currently used.
--
-- [@media@] a 'Media'
--
-- [@Returns@] a string containing the font name.
--
-- * Since 1.2
--
{# fun unsafe media_get_subtitle_font_name as ^
  `(MediaClass m)' => { withMediaClass* `m' } -> `Maybe String' peekNFreeMaybeString* #}


#endif


-- attributes

mediaAudioVolume :: (MediaClass media) => Attr media Double
mediaAudioVolume = newNamedAttr "audio-volume" mediaGetAudioVolume mediaSetAudioVolume

mediaBufferFill :: (MediaClass media) => ReadAttr media Double
mediaBufferFill = readNamedAttr "buffer-fill" mediaGetBufferFill

mediaCanSeek :: (MediaClass media) => ReadAttr media Bool
mediaCanSeek = readAttr mediaGetCanSeek

mediaDuration :: (MediaClass media) => ReadAttr media Double
mediaDuration = readNamedAttr "duration" mediaGetDuration

mediaPlaying :: (MediaClass media) => Attr media Bool
mediaPlaying = newNamedAttr "playing" mediaGetPlaying mediaSetPlaying

mediaProgress :: (MediaClass media) => Attr media Double
mediaProgress = newNamedAttr "progress" mediaGetProgress mediaSetProgress

mediaURI :: (MediaClass media) => Attr media String
mediaURI = newNamedAttr "uri" mediaGetURI mediaSetURI


-- signals

-- | The ::eos signal is emitted each time the media stream ends.
--
eos :: (MediaClass media) => Signal media (IO ())
eos = Signal (connect_NONE__NONE "eos")

--CHECKME:checky
-- | The ::'error' signal is emitted each time an error occurred.
--
-- [@error@] : the GError
--
-- * Since 0.2
--
error :: Signal Timeline (GError -> IO ())
error = Signal (connect_BOXED__NONE "error" peek)

#if CLUTTER_CHECK_VERSION(1,2,0)

-- | The font used to display subtitles. The font description has to
-- follow the same grammar as the one recognized by
-- Pango.fontDescriptionFromString'.
--
-- Default value: @Nothing@
--
-- * Since 1.2
--
mediaSubtitleFontName :: (MediaClass self) => Attr self (Maybe String)
mediaSubtitleFontName = newNamedAttr "subtitle-font-name" mediaGetSubtitleFontName mediaSetSubtitleFontName


-- | The location of a subtitle file, expressed as a valid URI.
--
-- Default value: @Nothing@
--
-- * Since 1.2
--
mediaSubtitleURI :: (MediaClass self) => Attr self (Maybe String)
mediaSubtitleURI = newNamedAttr "subtitle-uri" mediaGetSubtitleURI mediaSetSubtitleURI

#endif


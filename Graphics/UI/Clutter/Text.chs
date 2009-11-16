-- -*-haskell-*-
--  Clutter Text
--
--  Author : Matthew Arsenault
--
--  Created: 17 Sep 2009
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
#include <pango/pango.h>

{# context lib="clutter" prefix="clutter" #}
{# context lib="pango" prefix="pango" #}

-- | 'Text' — An actor for displaying and editing text
module Graphics.UI.Clutter.Text (
-- * Class Hierarchy
-- |
-- @
-- |  'GObject'
-- |    +----'Actor'
-- |           +----'Text'
-- @

-- * Constructors
  textNew,
  textNewFull,
  textNewWithText,

-- * Methods
  textGetText,
  textSetText,

  textSetMarkup,

  textGetActivatable,
  textSetActivatable,

  textSetAttributes,
  textGetAttributes,

  textGetColor,
  textSetColor,

  textGetEllipsize,
  textSetEllipsize,

  textGetFontName,
  textSetFontName,

  textSetPasswordChar,
  textGetPasswordChar,

  textGetJustify,
  textSetJustify,

  textGetLayout,

  textSetLineAlignment,
  textGetLineAlignment,

  textGetLineWrap,
  textSetLineWrap,

  textSetLineWrapMode,
  textGetLineWrapMode,

  textSetMaxLength,
  textGetMaxLength,

  textSetSelectable,
  textGetSelectable,

  textSetSelection,
  textGetSelection,

  textGetSelectionBound,
  textSetSelectionBound,

  textSetSingleLineMode,
  textGetSingleLineMode,

  textSetUseMarkup,
  textGetUseMarkup,

  textSetEditable,
  textGetEditable,

  textInsertText,
  textInsertUnichar,

  textDeleteChars,
  textDeleteText,

  textDeleteSelection,
  textGetChars,

  textGetCursorColor,
  textSetCursorColor,

  textGetSelectionColor,
  textSetSelectionColor,

  textSetCursorPosition,
  textGetCursorPosition,

  textSetCursorVisible,
  textGetCursorVisible,

  textSetCursorSize,
  textGetCursorSize,

  textActivate,
  textPositionToCoords,

#if CLUTTER_CHECK_VERSION(1,2,0)
  textSetPreeditString,
#endif

--TODO: Title for this
-- * Related Types
  --TODO: Export more of Pango?
  PangoLayout,
  LayoutWrapMode,
  LayoutAlignment,
  EllipsizeMode,

-- * Attributes
  textText,
  textActivatable,
--textAttributes,
  textColor,
  textEllipsize,
--textFontName,
  textPasswordChar,
  textJustify,
  textLayout,
  textLineWrap,
  textLineAlignment,
  textLineWrapMode,
  textMaxLength,
  textSelectable,
--textSelection,
  textSelectionBound,
  textSingleLineMode,
  textUseMarkup,
  textEditable,
  textCursorColor,
  textSelectionColor,
  textCursorPosition,
  textCursorVisible,
  textCursorSize,

-- * Signals
  onActivate,
  afterActivate,
  activate,
  onCursorEvent,
  afterCursorEvent,
  cursorEvent,
  onTextChanged,
  afterTextChanged,
  textChanged
  ) where

{# import Graphics.UI.Clutter.Types #}
{# import Graphics.UI.Clutter.Utility #}
{# import Graphics.UI.Clutter.Signals #}

import C2HS
import System.Glib.GObject
import System.Glib.Attributes
import System.Glib.UTFString

import Control.Monad (liftM)
import Data.IORef

import Graphics.UI.Gtk.Types (PangoLayoutRaw, mkPangoLayoutRaw)
import Graphics.UI.Gtk.Pango.Types
import Graphics.UI.Gtk.Pango.Layout
import Graphics.UI.Gtk.Pango.Attributes
import Graphics.UI.Gtk.Pango.Enums (EllipsizeMode)

--CHECKME: Is LayoutWrapMode/LayoutAlignment the wrap mode we want?


-- | Creates a new 'Text' actor. This actor can be used to display and
--   edit text.
--
-- [@Returns@] the newly created 'Text' actor
--
-- * Since 1.0
--
{# fun unsafe text_new as ^ { } -> `Text' newText* #}



-- | Creates a new 'Text' actor, using font_name as the font
-- description; text will be used to set the contents of the actor;
-- and color will be used as the color to render text.
--
-- This function is equivalent to calling 'textNew',
-- 'textSetFontName', 'textSetText' and 'textSetColor'.
--
-- [@font_name@] a string with a font description
--
-- [@text@] the contents of the actor
--
-- [@color@] the color to be used to render text
--
-- [@Returns@] the newly created 'Text' actor
--
-- * Since 1.0
--
{# fun unsafe text_new_full as ^ { `String', `String', withColor* `Color' } -> `Text' newText* #}



-- | Creates a new 'Text' actor, using font_name as the font
--   description; text will be used to set the contents of the actor.
--
-- This function is equivalent to calling 'textNew',
-- 'textSetFontName', and 'textSetText'.
--
-- [@font_name@] a string with a font description
--
-- [@text@] the contents of the actor
--
-- [@Returns@] the newly created 'Text' actor
--
-- * Since 1.0
--
{# fun unsafe text_new_with_text as ^ { `String', `String' } -> `Text' newText* #}


-- | Sets the contents of a 'Text' actor.
--
-- [@self@] a 'Text'
--
-- [@text@] the text to set.
--
-- * Since 1.0
--
{# fun unsafe text_set_text as ^ { withText* `Text', `String' } -> `()' #}

{# fun unsafe text_get_text as ^ { withText* `Text' } -> `String' #}

textText :: Attr Text String
textText = newAttr textGetText textSetText


-- | Sets markup as the contents of a 'Text'.
--
-- This is a convenience function for setting a string containing
-- Pango markup, and it is logically equivalent to:
--
--
-- >  textSetUseMarkup aTextActor True
-- > textSetText aTextActor markup
--
-- [@self@] a Text
--
-- [@markup@] a string containing Pango markup
--
-- * Since 1.0
--
{# fun unsafe text_set_markup as ^ { withText* `Text', `String' } -> `()' #}



-- | Sets whether a 'Text' actor should be activatable.
--
-- An activatable 'Text' actor will emit the "activate" signal
-- whenever the 'Enter' (or 'Return') key is pressed; if it is not
-- activatable, a new line will be appended to the current content.
--
-- An activatable 'Text must also be set as editable using
-- 'textSetEditable.'
--
-- [@self@] a 'Text'
--
-- [@activatable@] whether the 'Text' actor should be activatable
--
-- * Since 1.0
--
{# fun unsafe text_set_activatable as ^ { withText* `Text', `Bool' } -> `()' #}


-- | Retrieves whether a 'Text' is activatable or not.
--
-- [@self@] a 'Text'
--
-- [@Returns@] @True@ if the actor is activatable
--
-- * Since 1.0
--
{# fun unsafe text_get_activatable as ^ { withText* `Text' } -> `Bool' #}




-- | whether a 'Text actor should be activatable.
--
-- An activatable 'Text 'actor will emit the "activate" signal
-- whenever the 'Enter' (or 'Return') key is pressed; if it is not
-- activatable, a new line will be appended to the current content.
--
-- * Since 1.0
--
textActivatable :: Attr Text Bool
textActivatable = newAttr textGetActivatable textSetActivatable

--CHECKME: Something seems unsafe about this, also stupid get text out for correction
--CHECKME: Empty list unset

-- | Sets the attributes list that are going to be applied to the
--   'Text' contents.
--
-- The 'Text' actor will take a reference on the PangoAttrList passed to this function.
--
-- [@self@] a 'Text'
--
-- [@attrs@] a list of 'PangoAttribute'
--
-- * Since 1.0
--
textSetAttributes :: Text -> [PangoAttribute] -> IO ()
textSetAttributes txt pattrs = let func = {# call unsafe text_set_attributes #}
                               in withText txt $ \txtPtr -> do
                                    pStr <- makeNewPangoString =<< textGetText txt
                                    withAttrList pStr pattrs $ \attrPtr ->
                                      func txtPtr attrPtr

--getting text out seems convoluted and avoidable
--also why [[PA]]? and not [PA]?
-- | Gets the attribute list that was set on the 'Text' actor
--   'textSetAttributes', if any.
--
-- [@self@] a 'Text'
--
-- [@Returns@] The 'PangoAttribute' list set on the 'Text'
--
-- * Since 1.0
--
textGetAttributes :: Text -> IO [[PangoAttribute]]
textGetAttributes text = withText text $ \txtPtr -> do
                           attrPtr <- {# call unsafe text_get_attributes #} txtPtr
                           correct <- liftM genUTFOfs (textGetText text)  --TODO: silly
                           fromAttrList correct attrPtr


--textAttributes :: Attr Text [PangoAttribute]
--textAttributes = newAttr textGetAttributes textSetAttributes



-- | Sets the color of the contents of a 'Text' actor.
--
-- The overall opacity of the 'Text' actor will be the result of the
-- alpha value of color and the composited opacity of the actor itself
-- on the scenegraph, as returned by 'actorGetPaintOpacity'.
--
-- [@self@] a 'Text'
--
-- [@color@] a 'Color'
--
-- * Since 1.0
--
{# fun unsafe text_set_color as ^ {withText* `Text', withColor* `Color' } -> `()' #}


-- | Retrieves the text color as set by 'textSetColor'.
--
-- [@self@] a 'Text'
--
-- [@Returns@] a 'Color'
--
-- * Since 1.0
--
{# fun unsafe text_get_color as ^ {withText* `Text', alloca- `Color' peek* } -> `()' #}

textColor :: Attr Text Color
textColor = newAttr textGetColor textSetColor


-- | Sets the mode used to ellipsize (add an ellipsis: "...") to the
--   text if there is not enough space to render the entire contents
--   of a 'Text' actor
--
-- [@self@] a 'Text'
--
-- [@mode@] : a 'PangoEllipsizeMode'
--
-- * Since 1.0
--
{# fun unsafe text_set_ellipsize as ^ {withText* `Text', cFromEnum `EllipsizeMode' } -> `()' #}


-- | Returns the ellipsizing position of a 'Text' actor, as set by
--   'textSetEllipsize'.
--
-- [@self@] a 'Text'
--
-- [@Returns@] a 'PangoEllipsizeMode'
--
-- * Since 1.0
--
{# fun unsafe text_get_ellipsize as ^ {withText* `Text' } -> `EllipsizeMode' cToEnum #}

textEllipsize :: Attr Text EllipsizeMode
textEllipsize = newAttr textGetEllipsize textSetEllipsize


--CHECKME: Can set nothing, what do you get back?
-- | Sets the font used by a 'Text'. The font_name string must either
--   be @Nothing@, which means that the font name from the default
--   ClutterBackend will be used; or be something that can be parsed
--   by the pango_font_description_from_string() function, like:
--
-- >  textSetFontName text "Sans 10pt"
-- >  textSetFontName text "Serif 16px"
-- >  textSetFontName text "Helvetica 10"
--
-- [@self@] a 'Text'
--
-- [@font_name@] @Just@ a font name, or @Nothing@ to set the default
-- font name
--
-- * Since 1.0
--
{# fun unsafe text_set_font_name as ^ { withText* `Text', withMaybeString* `Maybe String' } -> `()' #}



-- | Retrieves the font name as set by 'textSetFontName'.
--
-- [@self@] a 'Text'
--
-- [@Returns@] a string containing the font name. The returned string
-- is owned by the 'Text' actor and should not be modified or freed
--
-- * Since 1.0
--
{# fun unsafe text_get_font_name as ^ { withText* `Text' } -> `String' #}

--textFontName :: Attr Text String
--textFontName = newAttr textGetFontName textSetFontName

--TODO: Do something with unicode stuff
--TODO: Maybe this
-- | Sets the character to use in place of the actual text in a password text actor.
--
-- If wc is 0 the text will be displayed as it is entered in the ClutterText actor.
--
-- [@self@] a 'Text'
--
-- [@wc@] @Just@ a Unicode character, or @Nothing@ to unset the
-- password character
--
-- * Since 1.0
--
{# fun unsafe text_set_password_char as ^ {withText* `Text', cIntConv `GUnichar' } -> `()' #}


-- | Retrieves the character to use in place of the actual text as set
--   by 'textSetPasswordChar'.
--
-- [@self@] a 'Text'
--
-- [@Returns@] @Just@ a Unicode character or @Nothing@ if the password
-- character is not set
--
-- * Since 1.0
--
{# fun unsafe text_get_password_char as ^ {withText* `Text' } -> `GUnichar' cIntConv #}

textPasswordChar :: Attr Text GUnichar
textPasswordChar = newAttr textGetPasswordChar textSetPasswordChar


-- | Sets whether the text of the 'Text' actor should be justified on
--   both margins. This setting is ignored if Clutter is compiled
--   against Pango < 1.18.
--
-- [@self@] a 'Text'
--
-- [@justify@] whether the text should be justified
--
-- * Since 1.0
--
{# fun unsafe text_set_justify as ^ { withText* `Text', `Bool'} -> `()' #}

-- | Retrieves whether the 'Text' actor should justify its contents on
--   both margins.
--
-- [@self@] a 'Text'
--
-- [@Returns@] @True@ if the text should be justified
--
-- * Since 0.6
--
{# fun unsafe text_get_justify as ^ { withText* `Text' } -> `Bool' #}

textJustify :: Attr Text Bool
textJustify = newAttr textGetJustify textSetJustify


--FIXME: Pango doc
--CHECKME: I have no idea if this is right or makes sense.
--particularly the getting the text from the layoutraw and putting it
--in PangoLayout, the newGObject followed by the with, and really just
--this whole function needs to be looked at
-- | Retrieves the current PangoLayout used by a 'Text' actor.
--
-- [@self@] a 'Text'
--
-- [@Returns@] 'PangoLayout'
--
-- * Since 1.0
--
textGetLayout :: Text -> IO PangoLayout
textGetLayout self = withText self $ \ctextptr -> do
                       pl <- constructNewGObject mkPangoLayoutRaw $ liftM castPtr $ {# call unsafe text_get_layout #} ctextptr
                       withPangoLayoutRaw pl $ \plptr -> do
                                                    str <- {#call unsafe layout_get_text#} (castPtr plptr) >>= peekUTFString
                                                    ps <- makeNewPangoString str
                                                    psRef <- newIORef ps
                                                    return (PangoLayout psRef pl)

textLayout :: ReadAttr Text PangoLayout
textLayout = readAttr textGetLayout


-- | Sets the way that the lines of a wrapped label are aligned with
--   respect to each other. This does not affect the overall alignment
--   of the label within its allocated or specified width.
--
-- To align a 'Text' actor you should add it to a container that
-- supports alignment, or use the anchor point.
--
-- [@self@] a 'Text'
--
-- [@alignment@] A 'PangoAlignment'
--
-- * Since 1.0
--
{# fun unsafe text_set_line_alignment as ^ { withText* `Text', cFromEnum `LayoutAlignment'} -> `()' #}

-- | Retrieves the alignment of a 'Text', as set by
--   'textSetLineAlignment'.
--
-- [@self@] a 'Text'
--
-- [@Returns@] a 'PangoAlignment'
--
-- * Since 1.0
--
{# fun unsafe text_get_line_alignment as ^ { withText* `Text' } -> `LayoutAlignment' cToEnum #}

textLineAlignment :: Attr Text LayoutAlignment
textLineAlignment = newAttr textGetLineAlignment textSetLineAlignment


-- | Sets whether the contents of a 'Text' actor should wrap, if they
--   don't fit the size assigned to the actor.
--
-- [@self@] a 'Text'
--
-- [@line_wrap@] whether the contents should wrap
--
-- * Since 1.0
--
{# fun unsafe text_set_line_wrap as ^ { withText* `Text', `Bool'} -> `()' #}

-- | Retrieves the value set using 'textSetLineWrap'.
--
-- [@self@] a 'Text'
--
-- [@Returns@] @True@ if the 'Text' actor should wrap its contents
--
-- * Since 1.0
--
{# fun unsafe text_get_line_wrap as ^ { withText* `Text' } -> `Bool' #}

textLineWrap :: Attr Text Bool
textLineWrap = newAttr textGetLineWrap textSetLineWrap

--CHECKME: Link to pango doc
-- | If line wrapping is enabled (see 'textSetLineWrap') this function
--   controls how the line wrapping is performed. The default is
--   'PangoWrapWord' which means wrap on word boundaries.
--
-- [@self@] a 'Text'
--
-- [@wrap_mode@] the line wrapping mode
--
-- * Since 1.0
--
{# fun unsafe text_set_line_wrap_mode as ^ { withText* `Text', cFromEnum `LayoutWrapMode' } -> `()' #}



-- | Retrieves the line wrap mode used by the 'Text' actor.
--
-- See 'textSetLineWrapMode'.
--
-- [@self@] a 'Text'
--
-- [@Returns@] the wrap mode used by the 'Text'
--
-- * Since 1.0
--
{# fun unsafe text_get_line_wrap_mode as ^ { withText* `Text' } -> `LayoutWrapMode' cToEnum #}

textLineWrapMode :: Attr Text LayoutWrapMode
textLineWrapMode = newAttr textGetLineWrapMode textSetLineWrapMode


-- | Sets the maximum allowed length of the contents of the actor. If
--   the current contents are longer than the given length, then they
--   will be truncated to fit.
--
-- [@self@] a 'Text'
--
-- [@max@]  the maximum number of characters allowed in the text actor; 0 to
-- disable or -1 to set the length of the current string * Since 1.0
--
{# fun unsafe text_set_max_length as ^ { withText* `Text', `Int'} -> `()' #}

-- | Gets the maximum length of text that can be set into a text
--   actor.
--
-- See 'textSetMaxLength'.
--
-- [@self@] a 'Text'
--
-- [@Returns@] the maximum number of characters.
--
-- * Since 1.0
--
{# fun unsafe text_get_max_length as ^ { withText* `Text' } -> `Int' #}

textMaxLength :: Attr Text Int
textMaxLength = newAttr textGetMaxLength textSetMaxLength

-- | Sets whether a 'Text' actor should be selectable.
--
-- A selectable 'Text' will allow selecting its contents using the
-- pointer or the keyboard.
--
-- [@self@] a 'Text'
--
-- [@selectable@] whether the 'Text' actor should be selectable
--
-- * Since 1.0
--
{# fun unsafe text_set_selectable as ^ { withText* `Text', `Bool'} -> `()' #}


-- | Retrieves whether a 'Text' is selectable or not.
--
-- [@self@] a 'Text'
--
-- [@Returns@] @True@ if the actor is selectable
--
-- * Since 1.0
--
{# fun unsafe text_get_selectable as ^ { withText* `Text' } -> `Bool' #}

textSelectable :: Attr Text Bool
textSelectable = newAttr textGetSelectable textSetSelectable


-- | Selects the region of text between start_pos and end_pos.
--
--  This function changes the position of the cursor to match
--  start_pos and the selection bound to match end_pos.
--
-- [@self@] a 'Text'
--
-- [@start_pos@] start of the selection, in characters
--
-- [@end_pos@] end of the selection, in characters
--
-- * Since 1.0
--
{# fun unsafe text_set_selection as ^ { withText* `Text', cIntConv `GSSize', cIntConv `GSSize' } -> `()' #}

--CHECKME: Return NULL / make Maybe?
-- | Retrieves the currently selected text.
--
-- [@self@] a 'Text'
--
-- [@Returns@] a string containing the currently selected text
--
-- * Since 1.0
--
{# fun unsafe text_get_selection as ^ { withText* `Text' } -> `String' peekNFreeString* #}


-- | Sets the other end of the selection, starting from the current cursor position.
--
-- If selection_bound is -1, the selection unset.
--
-- [@self@] a 'Text'
--
-- [@selection_bound@] the position of the end of the selection, in
-- characters
--
-- * Since 1.0
--
{# fun unsafe text_set_selection_bound as ^ { withText* `Text', `Int' } -> `()' #}

-- | Retrieves the other end of the selection of a 'Text' actor, in
--   characters from the current cursor position.
--
-- [@self@] a 'Text'
--
-- [@Returns@] the position of the other end of the selection
--
-- * Since 1.0
--
{# fun unsafe text_get_selection_bound as ^ { withText* `Text' } -> `Int' #}

textSelectionBound :: Attr Text Int
textSelectionBound = newAttr textGetSelectionBound textSetSelectionBound

--CHECKME: I think these need to be safe
-- | Sets whether a 'Text' actor should be in single line mode or not.
--
-- A text actor in single line mode will not wrap text and will clip
-- the the visible area to the predefined size. The contents of the
-- text actor will scroll to display the end of the text if its length
-- is bigger than the allocated width.
--
-- When setting the single line mode the "activatable" property is
-- also set as a side effect. Instead of entering a new line
-- character, the text actor will emit the "activate" signal.
--
-- [@self@] a 'Text'
--
-- [@single_line@] whether to enable single line mode
--
-- * Since 1.0
--
{# fun text_set_single_line_mode as ^ { withText* `Text', `Bool' } -> `()' #}

-- | Retrieves whether the 'Text' actor is in single line mode.
--
-- [@self@] a 'Text'
--
-- [@Returns@] @True@ if the 'Text' actor is in single line mode
--
-- * Since 1.0
--
{# fun text_get_single_line_mode as ^ { withText* `Text' } -> `Bool' #}

textSingleLineMode :: Attr Text Bool
textSingleLineMode = newAttr textGetSingleLineMode textSetSingleLineMode


-- | Sets whether the contents of the 'Text' actor contains markup in
--   Pango's text markup language.
--
-- Setting "use-markup" on an editable 'Text' will make the actor
-- discard any markup.
--
-- [@self@] a 'Text'
--
-- [@setting@] @True@ if the text should be parsed for markup.
--
-- * Since 1.0
--
{# fun unsafe text_set_use_markup as ^ { withText* `Text', `Bool' } -> `()' #}

-- | Retrieves whether the contents of the 'Text' actor should be
--   parsed for the Pango text markup.
--
-- [@self@] a 'Text'
--
-- [@Returns@] @True@ if the contents will be parsed for markup
--
-- * Since 1.0
--
{# fun unsafe text_get_use_markup as ^ { withText* `Text' } -> `Bool' #}

textUseMarkup :: Attr Text Bool
textUseMarkup = newAttr textGetUseMarkup textSetUseMarkup



-- | Sets whether the 'Text' actor should be editable.
--
-- An editable 'Text' with key focus set using 'actorGrabKeyFocus' or
-- 'stageTakeKeyFocus' will receive key events and will update its
-- contents accordingly.
--
-- [@self@] a 'Text'
--
-- [@editable@] whether the 'Text' should be editable
--
-- * Since 1.0
--
{# fun unsafe text_set_editable as ^ { withText* `Text', `Bool' } -> `()' #}

-- | Retrieves whether a 'Text' is editable or not.
--
-- [@self@] a 'Text'
--
-- [@Returns@] @True@ if the actor is editable
--
-- * Since 1.0
--
{# fun unsafe text_get_editable as ^ { withText* `Text' } -> `Bool' #}

textEditable :: Attr Text Bool
textEditable = newAttr textGetEditable textSetEditable

--Insertions


-- | Inserts text into a 'Text' at the given position.
--
-- If position is a negative number, the text will be appended at the
-- end of the current contents of the 'Text'.
--
-- The position is expressed in characters, not in bytes.
--
-- [@self@] a 'Text'
--
-- [@text@] the text to be inserted
--
-- [@position@] the position of the insertion, or -1
--
-- * Since 1.0
--
{# fun unsafe text_insert_text as ^ { withText* `Text', `String', cIntConv `GSSize' } -> `()' #}


--FIXME: Unicode
-- | Inserts wc at the current cursor position of a 'Text' actor.
--
-- [@self@] a 'Text'
--
-- [@wc@] a Unicode character
--
-- * Since 1.0
--
{# fun unsafe text_insert_unichar as ^ { withText* `Text', cIntConv `GUnichar' } -> `()' #}

-- | Deletes n_chars inside a 'Text' actor, starting from the current
--   cursor position.
--
-- [@self@] a 'Text'
--
-- [@n_chars@] the number of characters to delete
--
-- * Since 1.0
--
{# fun unsafe text_delete_chars as ^ { withText* `Text', cIntConv `Word' } -> `()' #}

-- | Deletes the text inside a 'Text' actor between start_pos and
--   end_pos.
--
-- The starting and ending positions are expressed in characters, not
-- in bytes.
--
-- [@self@] a 'Text'
--
-- [@start_pos@] starting position
--
-- [@end_pos@] ending position
--
-- * Since 1.0
--
{# fun unsafe text_delete_text as ^ { withText* `Text', cIntConv `GSSize', cIntConv `GSSize' } -> `()' #}


--CHECKME: Subclasses it references?
-- | Deletes the currently selected text
--
-- This function is only useful in subclasses of 'Text'
--
-- [@self@] a 'Text'
--
-- [@Returns@] @True@ if text was deleted or if the text actor is
-- empty, and @False@ otherwise
--
-- * Since 1.0
--
{# fun unsafe text_delete_selection as ^ { withText* `Text' } -> `()' #}


--TODO: GSSize
-- | Retrieves the contents of the 'Text' actor between start_pos and
--   end_pos.
--
-- The positions are specified in characters, not in bytes.
--
-- [@self@] a 'Text'
--
-- [@start_pos@] start of text, in characters
--
-- [@end_pos@] end of text, in characters
--
-- [@Returns@] a string with the contents of the text actor between
-- the specified positions.
--
-- * Since 1.0
--
{# fun unsafe text_get_chars as ^ { withText* `Text', cIntConv `GSSize', cIntConv `GSSize' } -> `String' peekNFreeString* #}


--CHECKME: This can be set to Nothing, but you can't get Nothing back.
--so with the attribute, make Maybe or not?
--
-- | Sets the color of the cursor of a 'Text' actor.
--
-- If color is @Nothing@, the cursor color will be the same as the
-- text color.
--
-- [@self@] a 'Text'
--
-- [@color@] the color of the cursor, or @Nothing@ to unset it
--
-- * Since 1.0
--
{# fun unsafe text_set_cursor_color as ^ { withText* `Text', withMaybeColor* `Maybe Color' } -> `()' #}


-- | Retrieves the color of the cursor of a 'Text' actor.
--
-- [@self@] a 'Text'
--
-- [@color@] @Just@ a 'Color'
--
-- * Since 1.0
--
{# fun unsafe text_get_cursor_color as ^ { withText* `Text', alloca- `Maybe Color' maybeNullPeek* } -> `()' #}

--{# fun unsafe text_get_cursor_color as ^ { withText* `Text', alloca- `Color' peek* } -> `()' #}

-- | Sets the color of the cursor of a 'Text' actor.
--
-- If set to @Nothing@, the cursor color will be the same as the text
-- color. Note that reading this attribute will never be nothing, and
-- will return the color of the text if set to @Nothing@.
--
-- * Since 1.0
--
textCursorColor :: Attr Text (Maybe Color)
textCursorColor = newAttr textGetCursorColor textSetCursorColor


{# fun unsafe text_set_selection_color as ^ { withText* `Text', withColor* `Color' } -> `()' #}

-- | Retrieves the color of the selection of a 'Text' actor.
--
-- [@self@] a 'Text'
--
-- [@color@] a 'Color'
--
-- * Since 1.0
--
{# fun unsafe text_get_selection_color as ^ { withText* `Text', alloca- `Color' peek* } -> `()' #}

textSelectionColor :: Attr Text Color
textSelectionColor = newAttr textGetSelectionColor textSetSelectionColor


-- | Sets the cursor of a 'Text' actor at position.
--
-- The position is expressed in characters, not in bytes.
--
-- [@self@] a 'Text'
--
-- [@position@] the new cursor position, in characters
--
-- * Since 1.0
--
{# fun unsafe text_set_cursor_position as ^ { withText* `Text', `Int' } -> `()' #}

-- | Retrieves the cursor position.
--
-- [@self@] a 'Text'
--
-- [@Returns@] the cursor position, in characters
--
-- * Since 1.0
--
{# fun unsafe text_get_cursor_position as ^ { withText* `Text' } -> `Int' #}

textCursorPosition :: Attr Text Int
textCursorPosition = newAttr textGetCursorPosition textSetCursorPosition



-- | Sets whether the cursor of a 'Text' actor should be visible or
--   not.
--
-- The color of the cursor will be the same as the text color unless
-- 'textSetCursorColor' has been called.
--
-- The size of the cursor can be set using 'textSetCursorSize'.
--
-- The position of the cursor can be changed programmatically using
-- 'textSetCursorPosition'.
--
-- [@self@] a 'Text'
--
-- [@cursor_visible@] whether the cursor should be visible
--
-- * Since 1.0
--
{# fun unsafe text_set_cursor_visible as ^ { withText* `Text', `Bool' } -> `()' #}

-- | Retrieves whether the cursor of a 'Text' actor is visible.
--
-- [@self@] a 'Text'
--
-- [@Returns@] @True@ if the cursor is visible
--
-- * Since 1.0
--
{# fun unsafe text_get_cursor_visible as ^ { withText* `Text' } -> `Bool' #}

textCursorVisible :: Attr Text Bool
textCursorVisible = newAttr textGetCursorVisible textSetCursorVisible


-- | Sets the size of the cursor of a 'Text'. The cursor will only be
--   visible if the "cursor-visible" property is set to @True@.
--
-- [@self@] a 'Text'
--
-- [@size@] the size of the cursor, in pixels, or -1 to use the
--   default value
--
-- * Since 1.0
--
{# fun unsafe text_set_cursor_size as ^ { withText* `Text', `Int' } -> `()' #}


-- | Retrieves the size of the cursor of a 'Text actor.
--
-- [@self@] a 'Text'
--
-- [@Returns@] the size of the cursor, in pixels
--
-- * Since 1.0
--
{# fun unsafe text_get_cursor_size as ^ { withText* `Text' } -> `Int' #}

textCursorSize :: Attr Text Int
textCursorSize = newAttr textGetCursorSize textSetCursorSize


-- | Emits the "activate" signal, if self has been set as activatable
--   using 'textSetActivatable'.
--
-- This function can be used to emit the ::activate signal inside a
-- "captured-event" or "key-press-event" signal handlers before the
-- default signal handler for the 'Text' is invoked.
--
-- [@self@] a 'Text'
--
-- [@Returns@] @True@ if the ::activate signal has been emitted, and
-- @False@ otherwise
--
-- * Since 1.0
--
{# fun text_activate as ^ { withText* `Text' } -> `Bool' #}


--TODO: This return type is messy
-- | Retrieves the coordinates of the given position.
--
-- [@self@] a 'Text'
--
-- [@position@] position in characters
--
-- [@Returns@] (X coordinate, Y coordinate, line_height, @True@ if the conversion was successful)
--
-- * Since 1.0
--
{# fun unsafe text_position_to_coords as ^
       { withText* `Text',
         `Int',
         alloca- `Float' peekFloatConv*,
         alloca- `Float' peekFloatConv*,
         alloca- `Float' peekFloatConv*} -> `Bool' #}

#if CLUTTER_CHECK_VERSION(1,2,0)
--CHECKME: I've never used Pango, and not really sure if this is good
--also it seems weird.
textSetPreeditString :: Text -> String -> [PangoAttribute] -> Word -> IO ()
textSetPreeditString text str pattrs cpos = let func = {# call unsafe text_set_preedit_string #}
                                            in withText text $ \txtPtr ->
                                                 withUTFString str $ \strPtr -> do
                                                   pStr <- makeNewPangoString str
                                                   withAttrList pStr pattrs $ \attrPtr ->
                                                     func txtPtr strPtr attrPtr (cIntConv cpos)
#endif

--See note in Types of Activatable
instance Activatable Text where
  onActivate = connect_NONE__NONE "activate" False
  afterActivate = connect_NONE__NONE "activate" True
  activate = Signal (connect_NONE__NONE "activate")

--CHECKME: Do I work?
onCursorEvent, afterCursorEvent :: Text -> (Geometry -> IO ()) -> IO (ConnectId Text)
onCursorEvent = connect_BOXED__NONE "cursor-event" peek False
afterCursorEvent = connect_BOXED__NONE "cursor-event" peek True

--CHECKME: Event?
cursorEvent :: Signal Text (Geometry -> IO ())
cursorEvent = Signal (connect_BOXED__NONE "cursor-event" peek)


onTextChanged, afterTextChanged :: Text -> IO () -> IO (ConnectId Text)
onTextChanged = connect_NONE__NONE "text-changed" False
afterTextChanged = connect_NONE__NONE "text-changed" True

textChanged :: Signal Text (IO ())
textChanged = Signal (connect_NONE__NONE "text-changed")


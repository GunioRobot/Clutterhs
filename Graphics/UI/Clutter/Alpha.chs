-- -*-haskell-*-
--  Clutter Alpha
--
--  Author : Matthew Arsenault
--
--  Created: 22 Sep 2009
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
{-# LANGUAGE ForeignFunctionInterface, TypeSynonymInstances #-}

#include <clutter/clutter.h>

{# context lib="clutter" prefix="clutter" #}

module Graphics.UI.Clutter.Alpha (
                                  alphaNew,
                                  alphaNewFull,
                                  alphaNewWithFunc,

                                  alphaSetTimeline,
                                  alphaGetTimeline,
                                  alphaTimeline,

                                  alphaSetMode,
                                  alphaGetMode,
                                  alphaMode,

                                  alphaGetAlpha,
                                  alphaAlpha

                                --alphaSetClosure,
                                --alphaRegisterClosure,
                                --alphaRegisterFunc
                                 ) where

{# import Graphics.UI.Clutter.Types #}

import C2HS
import System.Glib.GObject
import Control.Monad (liftM)
import System.Glib.Attributes
import System.Glib.Properties

{# fun unsafe alpha_new as ^ { } -> `Alpha' newAlpha* #}

{# fun unsafe alpha_new_full as ^
       { withTimeline* `Timeline', cFromEnum `AnimationMode' } -> `Alpha' newAlpha* #}

--we don't care about the user data, and GDestroyNotify should always free the haskell function ptr
--FIXME: I'm not really sure what pointer the final argument is passed.
--It's almost certainly not the function pointer, so this is wrong.
--If I need to pass curried freeHaskellFunPtr, but that requires another wrapper call.
--Then that wrapped func, would need to be freed later, but how? No ForeignFunPtr with finalizer
--I think it might be passed the user data, so pass the function pointer to the function as the user data :p
--This somehow seems to not crash, which I really don't believe. Also somehow this works as unsafe which I don't understand.
--FIXME/CHECKME: Somewhat related, what happens when using alpha_set_func when a function was previously set?
--does the GDestroyNotify still get called and free the function (supposing any of the above worked),
--or does it start leaking functions??
alphaNewWithFunc :: Timeline -> AlphaFunc -> IO Alpha
alphaNewWithFunc tl af = withTimeline tl $ \tlptr -> do
                         afptr <- newAlphaFunc af
                         let gptr1 = castFunPtrToPtr afptr
                         let gptr2 = castFunPtr freeHaskellFunPtrPtr
                         a <- {# call unsafe alpha_new_with_func #} tlptr afptr gptr1 gptr2
                         newAlpha a

{# fun unsafe alpha_set_timeline as ^
       { withAlpha* `Alpha', withTimeline* `Timeline' } -> `()' #}
{# fun unsafe alpha_get_timeline as ^
       { withAlpha* `Alpha' } -> `Timeline' newTimeline* #}
alphaTimeline :: Attr Alpha Timeline
alphaTimeline = newAttr alphaGetTimeline alphaSetTimeline

{# fun unsafe alpha_set_mode as ^
       { withAlpha* `Alpha', cFromEnum `AnimationMode' } -> `()' #}
{# fun unsafe alpha_get_mode as ^
       { withAlpha* `Alpha' } -> `AnimationMode' cToEnum #}

alphaMode :: Attr Alpha AnimationMode
alphaMode = newAttr alphaGetMode alphaSetMode

{# fun unsafe alpha_get_alpha as ^ { withAlpha* `Alpha' } -> `Double' #}
alphaAlpha :: ReadAttr Alpha Double
alphaAlpha = readAttr alphaGetAlpha

--{# fun unsafe alpha_set_func as ^
--       { withAlpha* `Alpha', `AlphaFunc', `Userdata', `GDestroyNotify' } -> `Double' #}
--{# fun unsafe alpha_set_closure as ^ { withAlpha* `Alpha', `GClosure' } -> `()' #}
--{# fun unsafe alpha_register_closure as ^ { `GClosure' } -> `GULong' #}
--{# fun unsafe alpha_register_func as ^ { `AlphaFunc', userdata } -> `GULong' #}

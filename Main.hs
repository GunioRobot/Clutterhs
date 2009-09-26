
module Main where

import Graphics.UI.Clutter hiding (show)
import qualified Graphics.UI.Clutter as C
import System.Glib.Signals (on, after)
import System.Mem
import Control.Monad.Trans (liftIO)
import Data.Maybe (fromMaybe)

main = do
  a <- clutterInit
  print a

  let c = Color 255 0 0 210
  let c2 = Color 0 0 123 123
  let c3 = Color 0 123 0 255
  let blue = Color 0 0 255 200
  let cnamed = fromMaybe (error "color parsing failed") (colorFromString "green")
  print cnamed

  {-
  c <- colorNew 255 0 0 200
  c2 <- colorNew 0 0 123 123
  blue <- colorNew 0 0 255 200
  -}
  rec <- rectangleNewWithColor c
  rec2 <- rectangleNewWithColor blue
  stg <- stageNew
  txt <- textNewWithText "sans" "CLUTTER HASKELL LOL"

  tml <- timelineNew 9000
  alpha <- alphaNewFull tml Linear

  animateTest rec alpha ("forty three", 43::Int)
                        ("fifty seven", 57::Int)
                        ("mr. string", "arst"::String)
                        ("floating point number porn", 123.45::Double)
--  animateTest rec 2

  on stg hide (clutterMainQuit)

  on stg buttonPressEvent $
       tryEvent $ do
         t <- eventTime
         coords <- eventCoordinates
         button <- eventButton
         --modifier doesn't work quite right yet
--         mod <- eventModifierType
         liftIO $ putStrLn ("Time: " ++ show t)
         liftIO $ putStrLn ("Coords: " ++ show coords)
         liftIO $ putStrLn ("Button: " ++ show button)
--         liftIO $ putStrLn ("Modifier: " ++ show mod)


  containerAddActor stg rec
  containerAddActor stg rec2
  containerAddActor stg txt

  actorSetZRotationFromGravity rec2 45 GravityCenter

  actorSetPosition rec 50 50
  actorSetSize rec 100 100

  actorSetPosition rec2 100 100
  actorSetSize rec2 100 100

  (xpos, ypos) <- actorGetPosition rec
  print xpos
  print ypos
  stageSetColor stg cnamed

  actorSetPosition txt 100 200
  actorSetSize txt 100 30
  actorSetZRotationFromGravity txt 30 GravityCenter

  orig <- stageGetPerspective stg
  putStrLn $ "got orig: " ++ show orig


  let pers = Perspective 90 2 0.1 100

  putStrLn $ "setting to: " ++ show pers

  stageSetPerspective stg pers
  performGC

--either of these work
  onShow stg (putStrLn "I'm shown!")
--  on stg C.show (putStrLn "I'm shown!")
--  onButtonPressEvent stg (\_ -> putStrLn "I'm clicked!")

  actorShow rec
  actorShow txt
  actorShow stg

  out <- stageGetPerspective stg
  putStrLn $ "got out: " ++ show out

  actorShowAll stg

  a <- actorGetZRotationGravity rec
  print a

  putStrLn "A wild stage appeared!"
  clutterMain


import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
-- import XMonad.Hooks.EwmhDesktops
import qualified XMonad.Hooks.EwmhDesktops as E
import System.Exit
import XMonad.Hooks.SetWMName
import Data.List
import qualified XMonad.StackSet as W


-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "/home/lealwern/.cabal/bin/xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
 

baseConfig = desktopConfig

myConfig = baseConfig
	{ terminal = "xterm"
	, modMask = mod4Mask
	, layoutHook = myLayout
	, borderWidth = 1
	, manageHook = myManageHook
        , handleEventHook = mconcat [ docksEventHook, E.fullscreenEventHook ]
	, startupHook = setWMName "LG3D"
	} `additionalKeys` myKeys `additionalKeysP` myKeysP

myLayout = avoidStruts (
	Tall 1 (3/100) (1/2) |||
	Mirror (Tall 1 (3/100) (1/2))) |||
	noBorders (fullscreenFull Full)

myManageHook = composeAll
   [ className =? "Rhythmbox" --> doShift "="
   , className =? "XDvi"      --> doShift "7:dvi"
   , className =? "XDvi"      --> doShift "7:dvi"
   , className =? "Xmessage"  --> doFloat
   , fmap (isInfixOf "Chrome") title --> doShift "2"
   , fmap (isInfixOf "Figure") title --> doFloat
   , fmap (isInfixOf "Figure") title --> doShift "7"
   , fmap (isInfixOf "qiv") title --> doFloat
   , fmap (isInfixOf "Update") title --> doFloat
   ]

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]
 
myKeys = [
	((mod4Mask .|. shiftMask, xK_z     ), io (exitWith ExitSuccess)) -- %! Quit xmonad
	, ((mod4Mask              , xK_z     ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad
	, ((mod4Mask              , xK_o     ), spawn "xscreensaver-command -lock")
	]
	
myKeysP = ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
        : ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
        : ("<XF86AudioLowerVolume>", spawn "amixer -D pulse sset Master 5%-")
        : ("<XF86AudioRaiseVolume>", spawn "amixer -D pulse sset Master 5%+")
        : ("<XF86AudioMute>", spawn "amixer -D pulse sset Master toggle")
        : ("M-<F12>", spawn "scrot -e 'xclip -target image/png -selection c -i $f'")
        : ("M-S-<F12>", spawn "sleep 0.5; scrot -d 1 -s -e 'xclip -target image/png -selection c -i $f'")
        : ("M-]", spawn "xterm -e \"ssh -Y nic@10.71.2.14\"")
        : ("M-0", spawn "keyboard_layout_change.sh")
        : [
	(otherModMasks ++ "M-" ++ [key], action tag)
	| (tag, key)  <- zip myWorkspaces "123qweasd"
	, (otherModMasks, action) <- [ ("", windows . W.greedyView) -- was W.greedyView
                                     , ("S-", windows . W.shift)]
	]

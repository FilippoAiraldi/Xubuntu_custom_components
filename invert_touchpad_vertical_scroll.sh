#!/usr/bin/bash

# -------------------------------------------------------
# The shell script inverts the vertical scrolling delta, 
# de facto inverting the direction in which the mousepad
# vertically scrolls. 
# It is recommended to run this script once, at startup,
# even automatically by the booter, or when the mouse is
# disconnected.
# -------------------------------------------------------

synclient VertScrollDelta=-117

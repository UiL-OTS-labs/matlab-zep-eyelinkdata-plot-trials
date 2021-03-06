# matlab-zep-eyelinkdata-plot-trial

## Matlab code to inspect zep-based experiment data using the Eyelink 1000

The output of a zep-eyelink experiment consists of a special type of .csv file in which
events from the zep program, time and position data from the eyelink 1000 eye tracker (and
possibly other custom defined data) are are integrated.

This is now a simple set of m-files that can be used to inspect these data visually. It
will probably grow into something bigger, aiming at baby research in which an eye tracker
is used as a device to objectify infant attentional behavior. Most eye trackers are a
black box: i.e. in the case of periods of missing data, it is impossible to know what was
the exact reason for data loss, esecially when infants are the subjects. Was it a blink? 
Was the child turning towards the caretaker or experimenter? Did a foot occlude the eye 
image analysed by the eye tracker?

In order to assess these events in greater detail, the plan is to eventually use this
code as a starting point for synchronising eye tracking data files and participant video,
with the goal to automate the task of selecting usable trials and improving baby eye 
tracking workflows. This is research and development code. Production implementation is
not the goal.

## Functionality
For now, this is just a simple, quite generic plotting tool that shows graphs like this:

```

                 zoomed out                  zoomed in
                 screen pixel based          to screen
                 x-y scatterplot             x-y plot in degrees

                        |                       |
                        V                       V
		-----------------------      -----------------------
		|                      |    |                       |
		|      |---------|     |    |                       |
		|      |   *---* |     |    |      O=======O        |
		|      |---------|     |    |                       |
		|                      |    |                       |
		|----------------------|    |-----------------------|

		|---------------------------------------------------|
	x/t	|_________/---------------------\_____              |  x signal/time (degrees)
                |---------------------------------------------------|

		|---------------------------------------------------|
	y/t	|-------------------------------------              |  y signal/time (degrees)
	        |---------------------------------------------------|

		|---------------------------------------------------|
	v/t	|         /\                    /\                  |  velocity/time deg/s
                |------^=/  \=====-=-==`-====--/- \^=---------------|

```

# Usage

* Input:   Data files in the 'data' directory.
* Output:  High resolution plots of trial periods in the data file.
           In 'inspect' directory.

* Check/adapt some paths/settings in the settings section of main.m
* Run "main.m"

If you need help: get in touch with Jacco van Elst at lab support UiL OTS

			e-mail: j.c.vanelst %%%%% uu.nl

# Info, credits & references

Programmed using Matlab 2018a. Should work fine on versions 2014 and above (this is a
guesstimation).

## Matlab code
Some parts in the code have been re-used/adapted from work of Ignace Hooge,
Roy Hessels, Diederick Niehorster, Jeroen Benjamins @Utrecht University

## ZEP info
Veenker, T.J.G. (2018). The Zep Experiment Control Application (Version 1.14)
[Computer software]. Beexy Behavioral Experiment Software.
Available from http://www.beexy.org/zep/



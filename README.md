# TopLog - Not Another Logger?

With the plethora of amateur radio logging solutions out there, why would you want to use this one?

The simple answer is, **you likely wouldn't**. I created this for my own use, so I could log while out /P using an old Linux laptop booted into tty mode. I didn't want a flashy UI, I didn't want lots of different features. I simply wanted to be able to reliably log the contacts I made.

This logger can work either with CAT control or without. It can also be set up for basic serial exchange contests. The confirm process at the end of each QSO is a little clunky, but I wanted to be sure I wasn't logging garbage.

## Features

* Logs based on UTC time
* Exports log into .csv format for easy conversion to ADIF etc
* Includes support for HamLib's rigctl CAT control software
* Requires very little in the way of processing power
* Runs within the command line/terminal/BASH
* Can be used to log simple contests (more features to be added anon)
* Confirms each QSO before logging and allows you to correct any errors

## CAT Control

To make use of the CAT control features, you need to install and run HamLib's rigctld (rig control daemon) software. This is a fairly simple procedure and, included in the repository, is the file 'xiegu.sh' which I use to start the daemon when I am out /P. This daemon should be left running in the background and, if you wish, TopLog will connect to it and take frequency and mode information from the radio.

## Contests

As mentioned above, this logging software includes basic support for contests - namely a serial counter (1,2,3 etc) and a space to log the other station's serial. In time I may add other features, but bear in mind this is a simple logger and not designed to deal with complex contests. There are plenty of better contest loggers out there!

## Feedback

If you have any feedback about TopLog, or want to see new features added (within reason!), please contact me. Either using GitHub, or to gm5aug@topple.scot.

Happy logging!

73 Michael GM5AUG

gm5aug.topple.scot

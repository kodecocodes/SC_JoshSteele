# Background Modes - Audio


# Screencast Metadata

## Screencast Title

Background Modes - Audio

## Screencast Description

You can use an Audio background mode to enable your application to play audio while backgrounded.

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0 Beta 5 or greater
* **Editor**: Xcode 10.0 Beta 5 or greater


# Script

Hey everyone, it's Josh, and I'm back with another raywenderlich.com screencast.  Have you ever wondered how some apps continue to do activities, even though they're in the background?  Well, in this screencast, I'll go over how you can enable your app to play audio while in the background.  

Before we start, I'd like to give a big thanks to Chris Wagner, who wrote the original background modes tutorial, which is the basis for this screen cast, as well as a big thanks to Brody Eller who updated the tutorial for Xcode 10 and Swift 4.2  Be sure to give them 
a follow on twitter if you like what you see here.  


Waaaaaay back in 2010 when iOS 4 was released, Apple introduced multitasking, and along with it the concept of background modes.  Background modes allowed developers to execute a set of restricted tasks when the app is backgrounded.  This restriction allows the system to attempt to maintain a responsive user interface as well as extend battery life - for example, you don't want a 30 minute download going on in the background, using your battery and other resources.  

Before we start, a quick note - you should probably follow along on a real device, so you can properly background the app - the simulator can, well, simulate this, but the device will handle it better.  

One more thing to note before we dive in - if you try to do things in the background that aren't in the background modes capability list, you risk getting rejected by the App Store.  So consider yourselves warned!

Ok, background audio is really easy, and virtually automatic.  If you want to stream some audio, for example, you start a network connection and call connection callbacks to keep audio data coming in, and once put in the background, iOS will continue to make these calls, assuming the infrastructure is in place.  Let's take a look at the code to see what's needed to get our audio playing in the background 


# DEMO

I've got a project setup already that loads up some songs with AVQueuePlayer and plays them one after another.  First, I need to make sure that my team is set in my project to I can properly enable the background mode capability later on

[Checks team setting]

If I start the app now, I see the title of the track, a timer, and a play button.  If I tap play, the music plays, and the timer runs, showing the time elapsed for the song.  

[Play app]

If I background the app, the music stops playing. 

[background the app]

This is because I don't have background audio enabled yet.  Let's fix that.  Go to Xcode, select the project, then the app target, and then go to the capabilities tab.  Enable background modes, and then check the "Audio, Airplay and Picture in Picture" checkbox.  

[Enable background mode]

If I build this and run again, I can tap the play button to start the music as before.  This time when I hit the home button to send it to the background, the music keeps playing!  You also see the time elapsed is getting sent to the console, just to show you that yes, indeed, the callbacks are getting executed even though the app is in the background.  


# Outro

Background modes enable you to keep your app going even though it's not front and center - but only in certain cases.  Backgrounding audio is one of the easiest modes to enable, only requiring an enabled capability, along with your existing audio code.  
 
That's a quick look at one of the various background modes you can enable in iOS.  Keeping coming back to raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!

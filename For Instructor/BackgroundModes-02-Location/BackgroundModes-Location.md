# Background Modes - Location Updates


# Screencast Metadata

## Screencast Title

Background Modes - Location Updates

## Screencast Description

The location updates background mode allows your app to stay up to date with where you are while it's in the background.  

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0 Beta 5 or greater
* **Editor**: Xcode 10.0 Beta 5 or greater


# Script

Hey everyone, it's Josh, and I'm back with another raywenderlich.com screencast.  Have you ever wondered how some apps continue to do activities, even though they're in the background?  Well, in this screencast, I'll go over how you can enable your app to get location updates while in the background.   

Before we start, I'd like to give a big thanks to Chris Wagner, who wrote the original background modes tutorial, which is the basis for this screen cast, as well as a big thanks to Brody Eller who updated the tutorial for Xcode 10 and Swift 4.2  Be sure to give them a follow on twitter if you like what you see here.  


Waaaaaay back in 2010 when iOS 4 was released, Apple introduced multitasking, and along with it the concept of background modes.  Background modes allowed developers to execute a set of restricted tasks when the app is backgrounded.  This restriction allows the system to attempt to maintain a responsive user interface as well as extend battery life - for example, you don't want a 30 minute download going on in the background, using your battery and other resources.  

Before we start, a quick note - you should probably follow along on a real device, so you can properly background the app - the simulator can, well, simulate this, but the device will handle it better.  

One more thing to note before we dive in - if you try to do things in the background that aren't in the background modes capability list, you risk getting rejected by the App Store.  So consider yourselves warned!

Getting location updates while in the background is pretty easy to setup, and you can even change the accuracy of the updates from the background.  Let's take a look.


# DEMO

I've got a project setup already that has a map, as well as a switch that enables me to toggle location monitoring.  Pins will get added to the map as location updates are obtained.
It's just missing the ability to send updates in the background.

Don't forget that since we're working with location data here, there are 2 things the app must have - first, it must have the proper permission strings in the Info.plist file asking for permission to track the user's location.

[Add those strings]

I also need to make sure that I call `requestAlwaysAuthorization` so I can obtain the location data even though the app isn't actively in use.  Let's add that to the project.  

`requestAlwaysAuthorization()`

Before we run the app, there's one more thing to add - when the map comes back to the foreground, it needs to refresh the app.  We can do this by posting an observer to notification center to call refreshMap when the app becomes active again.  We can do this in viewDidLoad

```
 override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(refreshMap), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  

```

Don't forget to remove the observer in the deinit method.  

```
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
```

Enabling our app to receive location updates in the background is easy.  Go to Xcode, select the project, then the app target, and then go to the capabilities tab.  Enable background modes, and then check the "Location Updates" checkbox.  

[Enable background mode]

If I build this and run it in the simulator, I can toggle the switch to start monitoring location.  I can simulate location with Xcode's Debug-> Simulate Location menu item.  I'll walk through a few cities from the list, and you can see the pins appear.

[Demo adding pins via city selection]

When I background the app, I can continue to select cities from the location menu, and I see the location updates appearing in the console, and when I come back to the app, the map is updated with the pins created since I put the app in the background.  

[Video of app running]


# Outro

Background modes enable you to keep your app going even though it's not front and center - but only in certain cases.  Getting location updates in the background is pretty easy to enable - just a quick toggle of a capability in your target settings, and you're set.


That's a quick look at one of the various background modes you can enable in iOS.  Keeping coming back to raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!

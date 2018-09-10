# Background Modes - Finite Tasks


# Screencast Metadata

## Screencast Title

Background Modes - Finite Tasks

## Screencast Description

You can run tasks for a finite time in the background with a special API in iOS.  

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0 Beta 5 or greater
* **Editor**: Xcode 10.0 Beta 5 or greater


# Script

Hey everyone, it's Josh, and I'm back with another raywenderlich.com screencast.  Have you ever wondered how some apps continue to do activities, even though they're in the background?  Well, in this screencast, I'll go over how you can enable your app to perform some finite background tasks.    

Before we start, I'd like to give a big thanks to Chris Wagner, who wrote the original background modes tutorial, which is the basis for this screen cast, as well as a big thanks to Brody Eller who updated the tutorial for Xcode 10 and Swift 4.2  Be sure to give them a follow on twitter if you like what you see here.  


Waaaaaay back in 2010 when iOS 4 was released, Apple introduced multitasking, and along with it the concept of background modes.  Background modes allowed developers to execute a set of restricted tasks when the app is backgrounded.  This restriction allows the system to attempt to maintain a responsive user interface as well as extend battery life - for example, you don't want a 30 minute download going on in the background, using your battery and other resources.  

Before we start, a quick note - you should probably follow along on a real device, so you can properly background the app - the simulator can, well, simulate this, but the device will handle it better.  

One more thing to note before we dive in - if you try to do things in the background that aren't in the background modes capability list, you risk getting rejected by the App Store.  So consider yourselves warned!

Ok, performing background tasks isn't actually a "background mode" capability like some of the others you may be familiar with like audio, location updates or background fetch. It's actually its own API in iOS.  This iOS feature is typically used when you need to finish up some long running tasks, like rendering and writing a video to the camera roll.  However, that's just an example - you can pretty much do anything you want - but keep in mind that you only get a finite set of time - we're talking a small number of minutes.  

In fact, there is no well defined amount of time your task is given - however, you can always prompt the system to give you an idea of how much time you have left.  Typically the time provided to complete the task is about 3 minutes, but your mileage may vary.   


# DEMO

I've got a project setup already that calculates the Fibonacci numbers in sequence and displays the result. 

If I start the app now, the sequence counts up and is displayed on screen

[Play app]

However, if I background the app and then bring it back to the front, the app picks up where it left off, telling me that it doesn't keep counting while in the background.  

[background the app]

This is because I have nothing in my code to tell the program to keep running while in the background.  Let's change that.  First, add a property called backgroundTask, which is a UIBackgroundTaskIdenitfier, and set it to the invalid enumeration.  


`var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid`

This property will be used to identify the task that we'll ask the system to run in the background. 

Next, we'll add a method to register the task that we want to run in the background

```
func registerBackgroundTask() {
  backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
    self?.endBackgroundTask()
  }
  assert(backgroundTask != UIBackgroundTaskIdentifier.invalid)
}
```

This will tell iOS that we'll need more time to do whatever we're doing on our background task.  When we are done with the task, we'll let the system know we're done by callingg endBackgroundTask

```
func endBackgroundTask() {
  print("Background task ended.")
  UIApplication.shared.endBackgroundTask(backgroundTask)
  backgroundTask = UIBackgroundTaskIdentifier.invalid
}

```

If we don't call endBackgroundTask after a period of time our task is in the background, iOS will call the closure we defined back in registerBackgroundTask - which gives us a chance to stop executing the code - which is why endBackgroundTask is also called from the closure.  If you don't, iOS will terminate your app if you've spent too much time in the background. 

Now we can wire up the IBaction for our button to register the background task and end it.  If the button is not selected, we can add the call to registerBackgroundTask

`registerBackgroundTask()`

If the button is already selected, we can end the background task, as long as the background task isn't invalid


```
// end background task
if backgroundTask != UIBackgroundTaskIdentifier.invalid {
  endBackgroundTask()
}
```

This way, if the user stops the calculation, we'll tell the system we don't need to keep asking for CPU time

Don't forget that registerBackgroundTask and endBackgroundTask should be called in pairs.  If you call registerBackgroundTask twice, and only call endBackgroundTask once, you're still asking for CPU time.  

Let's move onto the user interface update next.  In calculateNextNumber(), let's have the app do different things based on whether we are in the background or in the active state.  For the active state, I'll just set the text of the results label to the resultsMessage, but if it is in the background, I'll print some messages to the console, which includes the time remaining as reported by the OS.  

```
switch UIApplication.shared.applicationState {
  case .active:
    resultsLabel.text = resultsMessage
  case .background:
    print("App is backgrounded. Next number = \(resultsMessage)")
    print("Background time remaining = 
      \(UIApplication.shared.backgroundTimeRemaining) seconds")
  case .inactive:
    break
}

```

If we run the app, hit play, and then background it, we can see the console reporting the current status of the calculation and the time remaining.  Usually the timer will start around 180 seconds (3 minutes) and if we let this go down to around 5 seconds or so [EDITOR: PLEASE SPEED UP VIDEO THROUGH ~8 second left], the background task will work.  To get it running again, we need to bring the app to the foreground again.  

There's one more fix we need to make for this app to work properly.  If we let the timer expire, bring our app to the foreground, and then background it again, the background task doesn't start.  That's because between the timer expiration and returning to the background, we never called `beginBackgroundTaskWithExpirationHandler`.  We can take care of this with a notification.

First, add a new method called reinstateBackgroundTask, where we'll call registerBackgroundTask if the updateTimer isn't nil and the backgroundTask is invalid

```
@objc func reinstateBackgroundTask() {
  if updateTimer != nil && (backgroundTask == 
    UIBackgroundTaskIdentifier.invalid) {
    registerBackgroundTask()
  }
}
````

Next, add some code to viewDidLoad to register an observer with NotificationCenter that will call reinstateBackgroundTask when the app transitions to become the active task

```
override func viewDidLoad() {
  super.viewDidLoad()
  NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: UIApplication.didBecomeActiveNotification, object: nil)
}

```

Finally, to clean up, make sure we remove this observer in our deinit method 

```
deinit {
  NotificationCenter.default.removeObserver(self)
}
```

Now if we run the app, background it, let it expire, bring the app back to the front, and then background it again, the OS provides time to run the background process, as you can see in the console.  


# Outro

Background modes enable you to keep your app going even though it's not front and center - but only in certain cases.  You can even perform finite tasks in the background if you need to finish up a long running process that doesn't require your user's involvement.  
 
That's a quick look at one of the various background modes you can enable in iOS.  Keeping coming back to raywenderlich.com for more screencasts and tutorials on iOS.  

Now, if you'll excuse me, when I started recording this screencast, I started my microwave on a background task to heat some water for some tea.  

See you next time!

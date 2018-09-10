# Background Modes - Background Fetch


# Screencast Metadata

## Screencast Title

Background Modes - Background Fetch

## Screencast Description

You can use fetch data in the background with a background mode, allowing your app to show the latest information to your user.  

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0 Beta 5 or greater
* **Editor**: Xcode 10.0 Beta 5 or greater


# Script

Hey everyone, it's Josh, and I'm back with another raywenderlich.com screencast.  Have you ever wondered how some apps continue to do activities, even though they're in the background?  Well, in this screencast, I'll go over how you can enable your app to fetch data in the background, so when your user brings the app to the front, it has up to date content.  

### COMMON BLOCK HERE - see audio script


Background fetch was introduced in iOS 7, allowing you to have up to date information ready to go in your app so when your view is displayed, that content is shown.  Before this, you had to show old data in your views, waiting while the app fetched new data, and then you had to refresh the views.  That's not a great user experience, so let's see how Background fetch works.   


# DEMO

I've got a project setup already that has a simplified version of that you might actually do when fetching something from the cloud - for example, grabbing some JSON from a server.  Here, however, we'll just fetch the current time instead of reaching out to a server.  Keep in mind that when doing background fetch you don't have forever.  The consensus is that you have maybe 30 seconds to get the data you need, but as always, a shorter network request is preferred, to save on battery and data usage.  

Let's start the app, and take a look at what it does.  A simple UI shows a label, showing "Not yet updated", and an "Update" button.  When you tap that button, the time is fetched and the UI is updated.  

[Show the app in the simulator]

Let's get the project updated so when the app is background, and then brought to the foreground, the time is automatically up to date, no longer requiring the user to press the button, improving their overall experience.  

First, let's enable the background fetch background mode.  Go to your project file, select the target, toggle the Background Modes switch to "On" and select the Background Fetch mode.  Easy!

Now, onto the code - in AppDelegate.swift, set the minimum background fetch interval in application(didFinishLaunchingWithOptions)

```
UIApplication.shared.setMinimumBackgroundFetchInterval(
  UIApplication.backgroundFetchIntervalMinimum)
```

This sets the minimum background fetch interval to the UIApplication class's backgroundFetchIntervalMinimum value.  Keep in mind that you don't want to set the value too small, or your app will being polling for more data too often, using too many resources.  You can also set the value to UIApplication.backgroundFetchIntervalNever if, for example, the user logs out and you don't need to keep fetching.  

Finally, you need to implement application(_:performFetchWithCompletionHandler) to enable background fetch.  In this method, we'll find the view controller, and call the fetch method, 

```
// Support for background fetch
func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
  //1
  if let viewController = window?.rootViewController as? FetchViewController
  {
       viewController.fetch {
          //4
          viewController.updateUI()
          completionHandler(.newData)
        }
  }
}
```

In this code, when fetch completes, the UI gets updated via the updateUI method, and the completionHandler that was passed in gets invoked, with a .newData argument, signaling we have new data coming in - note this could also be .noData or .failed depending on the conditions of the fetch.  

We can test this code in 2 ways.  One, is to use the "Simulate Background Fetch" menu item under the "Debug" Menu.  Start your app on the simulator, and notice the message correctly reads "Not yet updated".  Background the app, and in Xcode's Debug menu, go to Simulate Background fetch, and a background fetch request will be sent to the app.  

[Walk through these steps]

Reopen the app, and you'll see that the time is updated!

You can also make a new scheme that launches your app directly into suspension.  Clone the current app, and under the options tab in the scheme, click the checkbox next to Background Fetch - Launch due to a background fetch event.  

If you run the app now - you'll notice it never opens, but is instead launched into a suspended state.  If you manually launch it, you'll see that instead of "Not yet updated" there is actually a time displayed on screen!  


# Outro

Background modes enable you to keep your app going even though it's not front and center - but only in certain cases.  Background fetch allows you to get data in the background so that when your app is brought to the foreground, your views can display the latest and greatest information to your user, improving their overall user experience.    

That's a quick look at one of the various background modes you can enable in iOS.  Keeping coming back to raywenderlich.com for more screencasts and tutorials on iOS.  See you next time!

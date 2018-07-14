# SKStoreReviewController


# Screencast Metadata

## Screencast Title

SKStoreReviewController

## Screencast Description

The SKStoreReviewController class in StoreKit provides the Apple mandated way to ask your users to review your app - long gone are the days of a different prompt in each app.  

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0 Beta 3 or greater
* **Editor**: Xcode 10.0 Beta 3 or greater


# Script

Hey everyone, it's Josh, and in this screencast, we'll discuss a simple, but very powerful class in iOS - SKStoreReviewController.  This class has been around since iOS 10.3, and is the way to provide an app store review prompt to your users.  The days of each app having their own review prompt, which usually seem to prompt you every other time you open the app, are behind us.  Let's talk a bit about some of the rules behind using this prompt, and some best practices before looking at some code.  

[Slide 1]

First, this is the Apple approved way to ask for an app store review in your app.  So much that it is required in section 1.1.7 of the App Store Review Guidelines.  

[Slide 2]

Second, you don't need to leave your app to leave a review

[Slide 3]

Third, you don't get to call this prompt whenever you'd like.  In fact, you are restricted to displaying this prompt only 3 times in a 365 day period.  Also, the prompt doesn't always display when you ask for it.  If the user has recently submitted a review, the system will not allow the prompt to appear again.  However, if the user hasn't reviewed the app, and it has been long enough since the user was last prompted for a review, the prompt will be displayed.  

[Slide 4]

Finally, as a best practice, you can restrict however you ask for the review prompt to appear, by only focusing on presenting the prompt at key points in the use of your app, and on top of that only asking for the prompt to appear after the user has reached that point a certain number of times.  For example......

Let's take a look at how to implement the SKStoreReviewController and this best practice in code.

### Demo




### Camera

SKStoreReviewController gives developers a Apple supported - and mandated! - way to present a prompt to the user to provide a review of their apps.  


# SKStoreReviewController


# Screencast Metadata

## Screencast Title

SKStoreReviewController

## Screencast Description

The SKStoreReviewController class in StoreKit provides the Apple mandated way to ask your users to review your app - long gone are the days of a different prompt in each app.  

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12.0 Beta 5 or greater
* **Editor**: Xcode 10.0 Beta 5 or greater


# Script

Hey everyone, it's Josh, and in this screencast, we'll discuss a simple, but very powerful class in iOS - SKStoreReviewController.  This class has been around since iOS 10.3, and is the way to provide an app store review prompt to your users.  The days of each app having their own review prompt, which seem to prompt you every other time you open the app, are behind us.  Let's talk a bit about some of the rules behind using this prompt, and some best practices before looking at some code.  

[Slide 1]

First, this is the Apple approved way to ask for an app store review in your app.  So much that it's required in section 1.1.7 of the App Store Review Guidelines, which you can see here.  Note that the guideline specifically says Apple will disallow custom review prompts - meaning SKStoreReviewController is *the* method to prompt for reviews going forward

`Use the provided API to prompt users to review your app; this functionality allows customers to provide an App Store rating and review without the inconvenience of leaving your app, and we will disallow custom review prompts.`

[Slide 2]

Second, you don't need to leave the app to leave a rating.  Right from the prompt, you can select from 1-5 stars, and that value gets uploaded to the App Store automatically.  Text based reviews still need to be entered on the App Store, but this is a great improvement.  

`Insert screenshot here`

[Slide 3]

Third, you don't get to call this prompt whenever you'd like.  In fact, you are restricted to displaying this prompt only 3 times in a 365 day period.  Also, the prompt doesn't always display when you ask for it.  For example, if the user hasn't reviewed the app, and it has been long enough since the user was last prompted for a review (and didn't enter one at the time), the prompt will be displayed.   If the user has recently submitted a review, the system will not allow the prompt to appear again.  This is a heuristic built into the system, so you don't have a lot of control over when the prompt can get displayed, however.....

[Slide 4]

As a best practice, you can restrict how you ask for the review prompt to appear, by only focusing on presenting the prompt at key points in the use of your app, and on top of that only asking for the prompt to appear after the user has reached that point a certain number of times.  For example, I might prompt my users to review my health based app after entering workouts for a week (or 2) so they have had time to experience the app and submit an informed review.  

Let's take a look at how to implement the SKStoreReviewController and this best practice in code.

### Demo

Here I've got the start of a project that my designer has sent me, so I can start to integrate some of the review prompt logic into the app while the rest of the design takes place.  I've got a storyboard with a few labels that represent data the user has entered, and a submit button to save the data to the app's datastore.  That's where I will want to prompt for a review.  To get started, I'll import StoreKit

`//1. Import StoreKit`
`import StoreKit`

This brings in the necessary framework so we can access SKStoreReviewController.

When the submit button gets tapped, I want to ask for a review, so I'll call `SKStoreReviewController.requestReview()`

`//2. Request a review.  This will always happen in development, never in TestFlight, and only sometimes in release!`
`SKStoreReviewController.requestReview()`

This immediately requests a review when the button is tapped.  A note here: in development, this always appears, it never appears in TestFlight, but in release we're restricted as to how many times that prompt can be displayed.  So let's track how many times the user has entered this screen.  A value in userdefaults should do the trick - I've got a key string captured in a `entriesKey` constant up at the top of my class.  

`//3. Keep track of the times we've visited this screen to limit the number of review requests`
`let currentFinishCount = userDefaults.integer(forKey: entriesKey)`
`userDefaults.set(currentFinishCount + 1, forKey: entriesKey)`

This grabs the current stored value for the `entriesKey` key and increases it by one. 

Now, in the submitButtonTouched method, that saved value can be checked before asking for a review.  Here, I used 2 just for the purposes of the demo, but for something fitness related it may be 100, so you can get 3 prompts per year.  

`//4. If the number of entries has exceed a certain threshold, ask for a review.  For something fitness related, this number might be 100, so that 3 times a year, you can request a review.  Otherwise, iOS will determine when the review prompt gets generated`
`if userDefaults.integer(forKey: entriesKey) > 2 {`

Again, this checks that the number of entries is greater than 2, and if so, asks for the prompt.  

Finally - don't forget to reset the counter if the prompt has been displayed.  

`//5. Reset the counter.`
`userDefaults.set(0, forKey: entriesKey)`

This resets the value to 0, so it will be another 2 (or 100, or whatever) visits to this page before the prompt is displayed again.  

Let's take a look at this in the simulator.  Normally in development mode, the prompt would always appear, but we've got to visit the page at least twice before the prompt appears, and because we saved the value in user defaults, it persists between launches of the app.  

### Camera

SKStoreReviewController gives developers a Apple supported - and mandated! - way to present a prompt to the user to provide a review of their apps.   It's designed to be as unintrusive as possible, but still allow you to get periodic snapshots of app ratings from your users.  

That's a real quick look at SKStoreReviewController - keep coming back to raywenderlich.com for more screencasts and tutorials on iOS.

You know, After all of this talk about prompting for reviews, I've got to go talk to Ray about putting a review prompt in the screencasts section of the site!  See you next time!


# Autofill
## Strong Passwords

### Intro

Hey everyone, it's Josh, and in this screencast, we'll be taking a look at the absolute latest in Password Autofill, straight out of WWDC 2018.  Apple took password autofill up a notch or two in iOS 12, introducing not only the ability for iOS to suggest strong passwords, but also providing a way to grab authentication codes sent by SMS message so you don't have to that so delicate of dances back forth between messages and your app in order to make sure you get that code just right.  Better yet, Apple has designed all of these changes to be very easy to implement - so easy that you may not have to change anything at all in your app!

Now, as I mentioned, these new features build off the capabilities introduced in iOS 11.  If you haven't already checked out the 2 existing Password Autofill screencasts, I highly suggest you check those out before watching this one.  They go over the basics of getting your app setup for Password Autofill, as well as adding a file to your server to register an associated domain - which is a must when using iOS 12's strong passwords capability - more on that in a bit!

Before we start, I want to give a shout out to Andy Pereira, who wrote the Password Autofill chapter in the iOS 11 by Tutorials, and Brian Moakley who helped develop the existing screencasts.  Be sure to give Brian and Andy a follow on Twitter if you like what you see here

### Code example - Strong passwords






### Talking Head - Intro to SMS code fetch

In today's account generation world, creating a username and password is just part of the story.  Two-factor authentication is a trusted method to make sure that you definitely are the person logging in, and many websites perform this authenticaion by sending an SMS message containing a code that you have to validate against in the app.  The downside of this though is the dance back and forth between Messages and the app you're trying to put the code in to make sure you get it exactly right - so annoying.  Luckily, Apple has come to the rescue with another input type you can assign to your UITextField that lets iOS 12 recognize it as a passcode field, and when an SMS comes in, the QuickType bar surfaces with a copy of that code, ready for you to tap.  Let's take a look.  


### Code example - getting SMS codes



### Conclusion

As you can see, Apple put a lot of work into the internals of iOS 12's password autofill features so you wouldn't have to change a lot of code in your app.  Many of the new features come down to setting the correct input field properties on the UITextFields in your app, and iOS 12 takes care of the rest.  

For more about the new features in iOS 12, be sure to check out the WWDC 2018 video entitled "Automatic Strong Passwords and Security Code Autofill", and keep coming back to raywenderlich.com for more screencasts and videos on iOS development.  

Whenever someone mentions strong passwords, I can't help but think about the password "12345" - as Spaceballs: The Movie so eloquentlt put it, "Incredible! That's the same combination as my luggage!"  See you next time!







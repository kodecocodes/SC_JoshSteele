
# Autofill
## Strong passwords


# Screencast Metadata

## Screencast Title

Password Autofill in iOS 12: Strong Passwords and Passcode Autofill

## Screencast Description

In iOS 12, Apple introduced some great improvements to Password Autofill - namely automatic strong password generation, which can suggest strong passwords right on your account creation page (possibly with no code updates!), and SMS authentication code autofill, which grabs authentication codes from Messages and shows them in the QuickType bar.   

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.2
* **Platform:** iOS 12 Beta 3 or Above
* **Editor**: Xcode 10 Beta 3 or Above



# Autofill
## Strong Passwords

### Intro

Hey everyone, it's Josh, and in this screencast, we'll be taking a look at the absolute latest in Password Autofill, straight out of WWDC 2018.  Apple took password autofill up a notch or two in iOS 12, introducing not only the ability for iOS to suggest strong passwords, but also providing a way to grab authentication codes sent by SMS so you don't have do that oh-so-delicate of dances back and forth between messages and your app in order to make sure you get that code just right.  Better yet, Apple has designed all of these changes to be very easy to implement - so easy that you may not have to change anything at all in your app!

Now, as I mentioned, these new features build off the capabilities introduced in iOS 11.  If you haven't already checked out the 2 existing Password Autofill screencasts, I highly suggest you check those out before watching this one.  They go over the basics of getting your app setup for Password Autofill, as well as adding a file to your server to register an associated domain - which is a must when using iOS 12's strong passwords capability - more on that in a bit!

Before we start, I want to give a shout out to Andy Pereira, who wrote the Password Autofill chapter in the iOS 11 by Tutorials, and Brian Moakley who helped develop the existing screencasts.  Be sure to give Brian and Andy a follow on Twitter if you like what you see here.

Now, the great thing about strong passwords in iOS 12 is that, if your UI components have the right properties, you don't have to do anything else!  Let's take a look.

### Code example - Strong passwords

Here's the AppManager project from the pervious screencasts, which is already setup to use Autofill by Domain, which lets iOS suggest logins to you in the QuickType bar if a matching domain is found in your iCloud Keychain.  But what about creating a new account?  

I've added two new view controllers to the existing AppManager app, and we'll look at the NewAccountViewController first.  In fact, I'm going to focus on the storyboard, and not the code, because all we have to do is check a few properties to enable strong password suggestion.  In this view controller, I've got a username text field, a password text field, and a button to sign up the new user.  Let's look at the attributes inspector for the username text field.  Here, as in the login screen, the content type is set to username.  The password field's content type is currently set to password - let's see what happens if we run this on our device.

If I tap the Create New Account button, and tap on the username field, giving it focus and setting it as the first responder, the quick type bar suggests a username, which it determines from common usernames it finds in iCloud Keychain.  However, I don't get a prompt for a strong password.  Let's see what can be done to remedy that. 

Let's set the password field's content type to one of the new options in iOS 12 - New Password - and run it again.  Choose a username, and once the password field gains focus, iOS 12 automatically suggests a strong password.  If you choose this password it will automatically get saved in iCloud Keychain, and will be made available next time you log in.

 The "username" and "new password" content types are the keys for Strong Password detection by iOS 12.  If your new account screen is setup with these fields, and their properties are set accordingly, iOS will automatically attempt to suggest a strong, new password.   By the way, if you're following along with the screencast, don't forget you need to run this on a device, just like in the Autofill Password by Domain example.  




### Talking Head - Intro to SMS code fetch

In today's account generation world, creating a username and password is just part of the story.  Two-factor authentication is a trusted method to make sure that you definitely are the person logging in, and many websites perform this authenticaion by sending an SMS message containing a code that you have to validate against in the app.  The downside of this, though, is the dance back and forth between Messages and the app you're trying to put the code in to make sure you get it exactly right which can quickly get annoying.  Luckily, Apple has come to the rescue with another input type you can assign to your UITextField that lets iOS 12 recognize it as a passcode field, and when an SMS comes in, the QuickType bar surfaces with a copy of that code, ready for you to tap.  Let's take a look.  


### Code example - getting SMS codes

The other view controller that's new in this project is the PasscodeViewController.  This has a single UITextField and a button to authenticate the passcode that comes in over SMS.  Let's try to get our one time code over SMS by running this on the device.

I'll login using the credentials I just made thanks to strong password autofill, and send myself a code from another device.  Nothing happens.  Let's see why.  Looking at the content type of the one time code box, it's currently set to unspecified.  Let's set it to One Time Code.  

This is the tip to iOS that this field will accept a one time code that gets sent to the user over SMS.  That, amazingly, is all you need!  Let's run this on the device and take a look.

When I start the app, and login -  the one time code screen appears.  When I give the one time code field focus, the quick type bar pops up, showing me the code I sent a moment ago!  This would also work if a new code came in, for example, 5678


### Conclusion

As you can see, Apple put a lot of work into the internals of iOS 12's password autofill features so you wouldn't have to change a lot of code in your app.  Many of the new features come down to setting the correct input field properties on the UITextFields in your app, and iOS 12 takes care of the rest.  

For more about the new features in iOS 12, be sure to check out the WWDC 2018 video entitled "Automatic Strong Passwords and Security Code Autofill", and keep coming back to raywenderlich.com for more screencasts and videos on iOS development.  

Whenever someone mentions strong passwords, I can't help but think about the password "12345" - as Spaceballs: The Movie so eloquently put it, "Incredible! That's the same combination as my luggage!"  See you next time!







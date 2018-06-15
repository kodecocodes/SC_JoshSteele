# Autofill
## Domain Based


Hey everyone, it's Josh, and in this screencast, we'll be diving into the wonderful world of password autofill. We're all used to working with password autofill in browsers, but up until iOS 11, we weren't able to provide this very necessary feature into our own apps.

Thankfully, this is quite easy to do. iOS actually has two different types of autofill. The first mode provides users a link to their saved passwords from the device via iCloud Keychain. By doing this, your app will automatically show a QuickType bar with a lock button, which takes you to a list of possible logins to choose from. The second way Password AutoFill can work is by prompting the user with a username in the QuickType bar without having to select the lock button. We can configure our app to perform password autofill based by domain which is what we'll do in this screencast. 

To perform this domain based autofill, there a few requirments. First, you can't test this on the simulator. You must test this on a physical device. Next, you need to have a paid Apple developer account. If you want to follow along with this screencast, you'll also need a free Heroku account. You also should also know your way around the command line. Finally, you should have a developer Team ID. This ID isn't found in your project settings - instead you can find it on developer.apple.com under your account's membership page. 

Before we start, I want to give a big thank you to Andy Pereira who wrote the chapter in iOS 11 by Tutorials, which is the basis of this screencast, and to Brian Moakley for helping out in the screencast creation. Make sure to give Andy and Brian a follow on Twitter. Okay, let's dive into autofilling passwords.

### Demo

Here I have Xcode up and running as well as an app in the simulator that features a very simple login. I have it all setup to do simple validation and autofill. As you can see, when I make the username field the first responder, the QuickType bar shows a lock. When I tap on the lock, I choose the password that I want to use. 

Now, I want the QuickType bar to suggest a username for me. To do this, I need to associate my own domain for my app. 

In the starter project, I've included my own server files, which I'll setup on Heroku.  I've unzipped that project and have navigated to that directory already. First, I'll install Vapor by way of homebrew. If you don't have homebrew installed, head over to brew.sh and follow the instructions.

To get vapor up and running, I'll use the following commands.  Be aware that the command output you see here may be a little different from your setup, since I already have some items up to date.  First, I'll use `brew tap` to get the necessary code setup for vapor.

`brew tap vapor/homebrew-tap`

Then just to make sure things are ready to go, I'll run `brew update`

`brew update`

And finally, `brew install vapor` to install vapor to my system

`brew install vapor`

If you get an error that Vapor cannot be built, and that you need to install the GCC compiler, run the "brew install gcc" command in Terminal. You may also see brew complaining about xcrun. If that happens, you need to set the Command Line Tools via Xcode preferences. Go to Xcode/Preferences/Locations and set Command Line Tools by selecting the appropriate version of Xcode from the drop-down menu. 

Next to install the Heroku command line tools, use `brew install heroku`. 

`brew install heroku`

When finished, login to heroku with heroku login.

`'heroku login`

Use the login credentials you created when joining Heroku.  

Now to create a git repo for the project. Run the following commands

`git init`
`git add .`
`git commit -m "Initial commit"`

At this point, I'm ready to build and deploy to Heroku - be warned these steps may take several minutes to run. To do this, I first run `vapor build`.

`vapor build`

Then I run `vapor heroku init`

`vapor heroku init`

I'm presented with a few questions. First, would I like to provide a custom app name and I for that I put yes.

Next, I provide an app name. I call this razewareautofill. Make sure your app name doesn't contain capital letters or special characters.

`razewareautofilldemo`

All of the remaining questions should be answered "no" until you get to "Would you like to push to heroku now?".  For that one, answer yes

This may take take 5-10 minutes, but once it is done, I'm ready to test password autofill.

In the main AppManager Xcode project, I'm going to provide my team id. I also make sure that Automatically manage signing is checked. Next, you want to choose a unique bundle identifier for the app.

`com.razeware.AppManagerDemo`

With that done, I switch over to capabilites, and enable associated domains. I click the plus sign and give my entry as webcredentials:razewareautofilly.herokuapp.com

`webcredentials:razewareautofill.herokuapp.com`

Back in the terminal I open the server project with `vapor xcode`. 

`vapor xcode`

When prompted, I enter `y` to open the Xcode project. Inside the `Public/.well-known/apple-app-site-association` file, replace the tokens in the file with the Team ID, which you gathered from the developer website, and the app’s Bundle ID noted earlier

`3P9488PVA3.com.razeware.AppManagerDemo`

### Camera

apple-app-site-association is a file, which lives on your domain, that Apple will look for if you enable the Associated Domains capability in your app.

Apple recommends you put the file in a directory named `.well-known`, but it can live at the root of your domain as well. Password AutoFill will check that your Team ID combined with the Bundle ID are found under the apps node of the file. This ensures a secure link between your app and your website without having to do any security on your end.

### Demo

Back in terminal, I commit my changes and then deploy them to Heroku.  

`git add .`
`git commit -m "Added webcredentials`"
`vapor heroku push`

Note that this again may take several minutes to run.  

OK, let's run a test. On my device, open safari and navigate to my heroku domain, `https://razewareautofilldemo.herokuapp.com`. I login and when prompted, I save my password.  If you don't see a prompt, make sure `Settings -> Safari -> Autofill -> Names and passwords` is enabled.  Last but not least, I switch back to my AppManager Xcode project and build and run on my device. Tapping on the username field, I see the suggessted username and password in the QuickType bar. Pretty cool stuff.

### Camera

This demo required a lot of configuring, but notice that I didn't do any actual coding in the app itself. Everything I did was configuring the actual server to test against. It’s clear that Apple is doing everything possible to make it easy for developers to enable this feature, so that it’s even easier for your users to log in! Of course, making your user's happy is a critical component of app development.

To learn more about autofilling in iOS apps check out WWDC 2017 video, Introducing Password Autofill for Apps. As always keep coming back to raywenderlich.com for more screencasts and videos on iOS development.

Speaking of passwords, I once knew a guy who told me he liked to use the word incorrect as his password. That way, if he forgot it, the computer would remind him. See you next time!


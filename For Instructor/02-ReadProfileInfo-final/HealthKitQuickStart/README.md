# Screencast Metadata

## Screencast Title

HealthKit Quick Start

## Screencast Description

HealthKit provides a nice set of API to interact with the heath data store on your iPhone - reading various types of data, writing health data you collect from your user, and even running statistics on that data to present summary information on screen,

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.0.3
* **Platform:** iOS 11
* **Editor**: Xcode 9.2


#  HealthKit Quick Start Screencast

**This screencast was based, in part, on the HealthKit Tutorial With Swift by Ted Bendixson - if you like what you've seen here, please be sure to check out the tutorial, and follow him on twitter @bendixso**

## Sample Project Idea
A raywenderlich.com Virtual WaterCooler app that tracks how often you get up from your desk, walk around, and refill your water bottle throughout the day.  Users can enter the amount of water consumed, and the app reads how many steps you have gone and flights climbed from the HealthKit data store.  Other user profile information (height, weight, etc) is read in from HealthKit and shown in a profile page.

## Main Topics
* Privacy Settings
* Reading static data (e.g. user profile data)
* Querying data statistics (e.g. getting sum of all water consumed today)
* Writing a new sample (e.g. water consumed)


## Needs
* Graphics for the tab bar.  One for water, one a profile image, and one my day (a calendar would work)

## Notes to myself
### Things to hit in the script
* What can you do with HealthKit
* Some things are emulatable on the simulator, but for a full experience, this should be deployed to a device!
* Show diagram how multiple apps communicate with read and/or write the main data store, and how that data can get exposed to other apps with permissions


### Project Segments
* HealthKit Read/Write settings panel
* Read user stats, write water
* Reading user information (age, etc)
* For display in profile page
* Writing information to the store (water consumption)
* For display in tracking page, display in Health app, other water apps
* Reading steps and motion activity
* For display in tracking page
* Needs to have observer to respond to changes


# Script

## Introduction (Talking Head 1)

Hi everyone, this is Josh.  In this screencast, I’m going to introduce some of the basic concepts of HealthKit.  HealthKit was first released with iOS 8, allowing users to enter health data manually through the Health App, as well as through HealthKit supported third-party apps, such as Runkeeper.  A few notes before we begin – if you want to put HealthKit into your app you have to have a paid developer account.  Also, while your best experience with HealthKit is on an actual device you can do most of what you need to on the simulator.   In this example, I'm going to make a Watercooler app that allows the staff here keep track of their water intake, as well as their steps throughout the day - gotta stay active, and get our 8 glasses of water a day!  Let's get our project set up to work with HealthKit. 

## Example 1

In our starter project, go the Target area of the project file, and select the capabilities tab.  In that list, you will see HealthKit - toggle the switch for it to "On".  Xcode will  update your appID, your entitlements file, and link the HealthKit framework.

We also need to place some entries into the project's Info.plist file because we're working with user's private data - and therefore need their permission.  In the Info.plist file, add a key entitled

`Privacy - Health Share Usage Description`

and assign it a value of

`We would like to use your steps, flights climbed, and other health data to populate the app`.

Do the same for:

`Privacy - Health Update Usage Description`

but with the value

`We would like to share your water consumption, energy and BMI with other apps`

The last thing we need to do before getting started is to request permission to read and write the types we want.  I've already got some of them in place here, but let's add the type we need to read and write water consumption by asking the `HKObjectType` to return a quantity type for the identifier `.dietaryWater`

`let water = HKObjectType.quantityType(forIdentifier: .dietaryWater)`

and then add those types to the arrays for read and write permissions

```
activeEnergy,
water]
```

```
flights,
water]
```
Now since the types are defined, we need to ask the user for permission to read or write those types.  This is done by calling the requestAuthorization method on an instance of HKHealthStore, passing in the types to share and read.  The result of the authorization request is passed to the completion block that was passed into the `authorizeHealthKit` method

```
HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
read: healthKitTypesToRead) { (success, error) in
completion(success, error)
}
```
If we run this in the simulator, the app asks for permission right away.  To make things easy, we can select "Choose All" and touch continue, and we're presented with the main screen of the app.

## Talking Head 2

Now since we've obtained permission from HealthKit to read and write data, let's start populating the fields in our app.  When you setup the Health App, you enter a set of information about yourself - gender, date of birth, blood type, and so on. Let’s use HealthKit to read that data from the store and show it in a profile page.


## Example 2

<Reading Profile information>


## Talking Head 3

In addition to reading data from the HealthKit data store, you can also write data - such as water intake in this example app - that can be then read by other HealthKit apps, assuming they have the proper permission to read that data type.  Let’s take a look at how we can take the user entered data, assign it a proper unit, and persist it in the data store.


## Example 3

<Writing Water Data to the store>


## Talking Head 4

Now, data is stored in the data store in discrete chunks.  Periods of steps are summed up and stored for a given time period.  What if you want to sum up all of those discrete chunks and give a total for a larger time period?  Luckily the HealthKit API let you do just that.  Let’s look at how we can summarize our step count for the day and display it in the My Day pane.


## Example 4

<Reading steps data from the store>



## Closing

OK, that's everything I'd like to cover in this screencast.

At this point, you should understand how to setup a project that uses HealthKit, read and write data, and even get summary statistics on data like total steps throughout the day.

There's a lot more to HealthKit, including different data types, getting data from other sources such as bluetooth devices, and using HealthKit on your Apple Watch, just to name a few.

Thanks for watching!

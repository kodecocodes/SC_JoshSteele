# Screencast Metadata

## Screencast Title

HealthKit Quick Start

## Screencast Description

HealthKit provides a nice set of API to interact with the heath data store on your iPhone - reading various types of data, writing health data you collect from your user, and even running statistics on that data to present summary information on screen,

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.0.3
* **Platform:** iOS 11
* **Editor**: Xcode 9.2

# Script

For the script, please see the For Instructor/README.md file

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




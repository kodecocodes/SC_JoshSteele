# Screencast Metadata

## Screencast Title

HealthKit Quick Start

## Screencast Description

HealthKit provides a nice set of API to interact with the heath data store on your iPhone - reading various types of data, writing health data you collect from your user, and even running statistics on that data to present summary information on screen.

## Language, Editor and Platform versions used in this screencast:

* **Language:** Swift 4.0.3
* **Platform:** iOS 11
* **Editor**: Xcode 9.2



# Script

## Introduction (Talking Head 1)

Hi everyone, this is Josh.  In this screencast, I’m going to introduce some of the basic concepts of HealthKit.  HealthKit was first released with iOS 8, allowing users to enter health data manually through the Health App, as well as through HealthKit supported third-party apps, such as Runkeeper.  A few notes before we begin.  First, this screencast was based, in part, on the HealthKit Tutorial With Swift by Ted Bendixson - if you like what you've seen here, please be sure to check out the tutorial, and follow him on twitter.  Second, if you want to put HealthKit into your app you have to have a paid developer account.  Also, while your best experience with HealthKit is on an actual device you can do most of what you need to on the simulator.   In this example, I'm going to put the finishing touches on a Watercooler app that allows the staff here to keep track of their water intake, as well as their steps throughout the day - gotta stay active and hydrated!  Let's get our project set up to work with HealthKit.

## Example 1

In our starter project, go the Target area of the project file, and select the capabilities tab.  In that list, you will see HealthKit - toggle the switch for it to "On".  Xcode will update your appID, your entitlements file, and link the HealthKit framework.

We also need to place some entries into the project's Info.plist file because we're working with user's private data - and therefore need their permission to read and write that data.  In the Info.plist file, add a key entitled

`Privacy - Health Share Usage Description`

and assign it a value of

`We would like to use your steps, flights climbed, and other health data to populate the app`.

Do the same for:

`Privacy - Health Update Usage Description`

but with the value

`We would like to share your water consumption, energy and BMI with other apps`

The last thing we need to do before getting started is to request permission to read and write the types we want.  I've already got some of them in place here, but let's add the type we need to read and write water consumption by asking the `HKObjectType` to return a quantity type for the identifier `.dietaryWater`

`let water = HKObjectType.quantityType(forIdentifier: .dietaryWater)`

and then add that type to the arrays for read and write permissions

```
activeEnergy,
water]
```

```
flights,
water]
```
Now since the types are defined, we can ask for permission.  This is done by calling the `requestAuthorization` method on an instance of `HKHealthStore`, passing in the types to share and read.

```
HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
  completion(success, error)
}
```
The `authorizeHealthKit` method is invoked when the `MasterViewController` loads up, so the request takes place immediately before we try to access the data store, which you can see when we run this in the simulator.  To make things easy, we can select "Choose All" and touch continue, and we're presented with the main screen of the app.

## Talking Head 2

Now since we've obtained permission from HealthKit to read and write data, let's start populating the fields in our app.  When you setup the Health App, you enter a set of information about yourself - gender, date of birth, blood type, and so on.  These read only attributes have predefined API in the HealthKit framework to make retreiving them a breeze. Let’s use HealthKit to read the user's gender data from the store and show it in a profile page.


## Example 2

The app as it is already pulls the data for the birthday and bloodtype, but I also want to show the gender, or biological sex, of the user.  I can declare a `biologicalSex` constant, setting it to the result of the `healthKitStore`'s `biologicalSex()` method.

`let biologicalSex =       try healthKitStore.biologicalSex()`

What you get back is actually a `HKBiologicalSexObject`, which is a wrapper around the `HKBiologicalSex` enum.  So let's unwrap that into a constant called `unwrappedBiologicalSex`

`let unwrappedBiologicalSex = biologicalSex.biologicalSex`

Now since I'm adding the biological sex to the set of data I'm returning from this method, I need to change the return type in the function signature.  Let's add `biologicalSex: HKBiologicalSex` as the last member of the tuple

```
class func getAgeSexAndBloodType() throws -> (age: Int, bloodType: HKBloodType, biologicalSex: HKBiologicalSex,) {
```

We also need to add the `unwrappedBiologicalSex` constant to the returned tuple at the end of the method.

`return (ageComponents.year!, unwrappedBloodType, unwrappedBiologicalSex)`

Finally, over in the `ProfileViewController` set the user profile's biological sex  in the `loadAndDisplayAgeSexAndBloodType()` method with the newly added tuple member.

`userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex`

If we load this in the simulator, and go to the profile page, it now shows the user's gender.

## Talking Head 3

In addition to reading data from the HealthKit data store, you can also write data - such as water intake in this example app - that can be then read by other HealthKit apps, assuming they have the proper permission to read that data type.  Let’s take a look at how we can take the user entered data, assign it a proper unit, and persist it in the data store.  I've got a helper method in the `ProfileDataStore` class that handles the writing of data to the store for a given value, unit, quantity type, and date.  Let's use those values to create the sample we will save to the data store.


## Example 3

FIrst, build a `HKQuantity` object, using the given unit, and value.  This tells HealthKit how much of a given unit we'll be adding.

`let quantity = HKQuantity(unit: unit, doubleValue: value)`

Next, create a  `HKQuantitySample`.  This uses our passed in type (one derived from `.dietaryWater` for example), the quantity we just created, and the start and end dates - which for our case are the same.

```
let sample = HKQuantitySample(type: type,
                              quantity: quantity,
                              start: date,
                              end: date)
```

Now since we have a sample, we can ask an instance of the `HKHealthStore()` to save it.  This action is asynchronous, and we pass in a completion block into the save method to let us respond to either a successful save, or handle an error, which we will check with a guard let statement.

```
HKHealthStore().save(sample) { (success, error) in
  guard let error = error else { print("Successfully saved \(type)"); return }
  print("Error saving \(type) \(error.localizedDescription)")
}
```

Finally, in the `WaterInputTableViewController`'s `saveWaterConsumedToHealthKit` method stub, we can add 2 lines.  First, create the `HKQuantityType` for the `.dietaryWater` idenitifier, wrapping the creation in a guard to make sure that type is still valid.
```
guard let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else {
  fatalError("Dietary Water Type is no longer available in HealthKit")
}

```
Then, to save our sample call the `ProfileDataStore.saveSample` method with the value from the text field, the unit (oz or mL chosen by the user), the type, and the current date.

```
ProfileDataStore.saveSample(value: waterConsumedValue, unit: waterUnitSegmentedControl.getHKUnit(), type: waterType, date: Date())
```

If we load this in the simulator and go to the water tab, we can add water data, but we don't see it displayed on the My Day tab yet - we'll need one more method to help us out.

## Talking Head 4

Data is placed into the data store in discrete chunks.   What if you want to sum up all of those discrete chunks and give a total for a larger time period?  Luckily the HealthKit API lets you do just that.  Let’s look at how we can summarize our data.  Again, I've got a helper method stub in the `ProfileDataStore` class that performs sums of data over a given range - this will be used to populate the water, steps, and flights climbed totals in the My Day pane.  Let's fill in that stub with some code.


## Example 4

First, choose the type of statistics that we want to perform - here, we'll choose `HKStatisticsOptions.cumulativeSum` and save it to the sumOption constant

`let sumOption = HKStatisticsOptions.cumulativeSum`

Next, build a predicate, which helps define the boundaries of our search.  The predicate constant will get assigned to the result of `HKQuery.predicateForSamples`, passing in the start and end date, and an empty options array.

`let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])`

OK, let's build the query.  My `statisticsSumQuery` object will be assigned to a `HKStatisticsQuery` object.  To build that, pass in the `quantityType`,  which we passed into our helper method, and the predicate and HKStatisticsOptions objects we just created above.    The completion block takes in a `HKStatisticsQuery`, the results as a optional `HKStatistics` object , and an optional Error.  In the closure body, we need to make sure the result's sumQuantity is not nil, and if that is the case, grab the sumQuantity, convert it to the proper double value based on the unit, and send it back through the completion handler in the `queryQuantitySum` method.  Be sure to do this back on the main queue in case the completion handler is updating the UI.  If the sumQuantity is nil, pass in a nil result and non-nil Error back to the calling method's completion handler.

```
let statisticsSumQuery = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: sumOption) { (query, result, error) in
  if let sumQuantity = result?.sumQuantity() {
    DispatchQueue.main.async {
      let total = sumQuantity.doubleValue(for: unit)
      completion(total, nil)
    }
  }
  else
  {
    print("no sum quantity")
    completion(nil, error)
  }
}
```

Finally, the query needs to be executed before it does anything, so ask an instance of the HKHealthStore to execute the query for us - the results will get handled by the completion block we defined above.

`HKHealthStore().execute(statisticsSumQuery)`

If we run this in the simulator, the total number of steps, water consumed, and flights climbed for the day now shows up in the My Day tab.


## Closing

OK, that's everything I'd like to cover in this screencast.

At this point, you should understand how to setup a project that uses HealthKit, read and write data, and even get summary statistics on data like total steps throughout the day.

There's a lot more to HealthKit, including different data types, getting data from other sources such as bluetooth devices, and using HealthKit on your Apple Watch, just to name a few.

OK, I've got to go contact the water cooler delivery person - I've gone through our entire supply getting this screencast made!  Thanks for watching!


/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import HealthKit

class ProfileDataStore {
  
  class func getAgeSexAndBloodType() throws -> (age: Int,
    bloodType: HKBloodType, biologicalSex: HKBiologicalSex) {
      
      let healthKitStore = HKHealthStore()
      
      do {
        
        //This method throws an error if these data are not available.
        let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
        let bloodType =           try healthKitStore.bloodType()
        //1. Get the sex type
        let biologicalSex =       try healthKitStore.biologicalSex()
        
        //Use Calendar to calculate age.
        let today = Date()
        let calendar = Calendar.current

        let birthDay = calendar.date(from: birthdayComponents)
        let ageComponents = calendar.dateComponents([.year], from: birthDay!, to: today)
        
        //Unwrap the wrappers to get the underlying enum values.
        let unwrappedBloodType = bloodType.bloodType
        //2. Unwrap the type
        let unwrappedBiologicalSex = biologicalSex.biologicalSex
        
        //3. Add the sex to the tuple to return
        return (ageComponents.year!, unwrappedBloodType, unwrappedBiologicalSex)
      }
  }
  
  class func saveSample(value:Double, unit:HKUnit, type: HKQuantityType, date:Date)
  {
    //1. Make a HKQuantity
    let quantity = HKQuantity(unit: unit, doubleValue: value)

    //2. Make a HKQuantitySample
    let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)

    //3. Save to the store
    HKHealthStore().save(sample) { (success, error) in
      guard let error = error else { print("Successfully saved \(type)"); return }
      print("Error saving \(type) \(error.localizedDescription)")
    }
  }
  
  class func queryQuantitySum(for quantityType:HKQuantityType, unit:HKUnit,
                              completion: @escaping (Double?, Error?) -> Void) {
    
    guard let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date())) else {
      fatalError("Failed to strip time from Date object")
    }
    let endDate = Date()
    
//    //1. Declare a statistics option and predicate
//    let sumOption = HKStatisticsOptions.cumulativeSum
//    
//    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
//    //2. Build the HKStatisticsQuery
//    let statisticsSumQuery = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: sumOption, completionHandler: { (query, result, error) in
//      
//      if let sumQuantity = result?.sumQuantity() {
//        DispatchQueue.main.async {
//          let total = sumQuantity.doubleValue(for: unit)
//          completion(total, nil)
//        }
//      }
//      else
//      {
//        print("no sum quantity")
//        completion(nil, error)
//      }
//      
//      
//    })
//    
//    //3. Execute the query
//    HKHealthStore().execute(statisticsSumQuery)
  }
  

  class func getMostRecentSample(for sampleType: HKSampleType,
    completion: @escaping (HKQuantitySample?, Error?) -> ()) {
    
      //1. Use HKQuery to load the most recent samples.
      let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                            end: Date(),
                                                            options: .strictEndDate)
    
      let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                            ascending: false)
    
      let limit = 1
    
      let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                      predicate: mostRecentPredicate,
                                      limit: limit,
                                      sortDescriptors: [sortDescriptor]) { (query, samples, error) in
        DispatchQueue.main.async {
          guard let samples = samples,
            let mostRecentSample = samples.first as? HKQuantitySample else {
              completion(nil, error)
              return
          }
          
          completion(mostRecentSample, nil)
        }
      }
    
      HKHealthStore().execute(sampleQuery)
  }
}

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
    bloodType: HKBloodType) {
      
      let healthKitStore = HKHealthStore()
      
      do {
        
        //This method throws an error if these data are not available.
        let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
        let bloodType =           try healthKitStore.bloodType()
        //1. Get the sex type
        
        //Use Calendar to calculate age.
        let today = Date()
        let calendar = Calendar.current

        let birthDay = calendar.date(from: birthdayComponents)
        let ageComponents = calendar.dateComponents([.year], from: birthDay!, to: today)
        
        //Unwrap the wrappers to get the underlying enum values.
        let unwrappedBloodType = bloodType.bloodType
        //2. Unwrap the type
        
        //3. Add the sex to the tuple to return
        return (ageComponents.year!, unwrappedBloodType)
      }
  }
  
  class func saveSample(value: Double, unit: HKUnit, type: HKQuantityType, date: Date)
  {
    //1. Make a HKQuantity

    //2. Make a HKQuantitySample

    //3. Save to the store

  }
  
  class func queryQuantitySum(for quantityType: HKQuantityType, unit: HKUnit,
                              completion: @escaping (Double?, Error?) -> Void) {
    
    guard let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date())) else {
      fatalError("Failed to strip time from Date object")
    }
    let endDate = Date()
    
    //1. Declare a statistics option and predicate
    
    
    //2. Build the HKStatisticsQuery
    
    
    //3. Execute the query
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

///// Copyright (c) 2017 Razeware LLC
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

import UIKit
import HealthKit

class MyDayTableViewController: UITableViewController {
  
  @IBOutlet weak var waterConsumedLabel: UILabel!
  @IBOutlet weak var stepsTakenLabel: UILabel!
  @IBOutlet weak var flightsClimbedLabel: UILabel!
  
  override func viewDidLoad() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateMyDayInfo), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    updateMyDayInfo()
  }
  
  @objc private func updateMyDayInfo() {
    
    loadAndDisplayStepsTaken()
    loadAndDisplayFlightsClimbed()
    loadAndDisplayDailyWaterConsumed()
  }
  
  private func displayAlert(for error: Error) {
    
    let alert = UIAlertController(title: nil,
                                  message: error.localizedDescription,
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
  
  private func loadAndDisplayStepsTaken() {
    
    guard let stepsTakenType = HKSampleType.quantityType(forIdentifier: .stepCount) else {
      print("Steps Count Type is no longer available in HealthKit")
      return
    }
    
    ProfileDataStore.queryQuantitySum(for: stepsTakenType, unit: HKUnit.count()) { (sampleTotal, error) in
      
      guard let sample = sampleTotal else {
        
        if let error = error {
          self.displayAlert(for: error)
        }
        DispatchQueue.main.async{self.stepsTakenLabel.text = "N/A"}
        return
      }
      
      DispatchQueue.main.async{self.stepsTakenLabel.text = "\(Int(sample))"}
    }
  }
  
  private func loadAndDisplayFlightsClimbed() {
    
    guard let flightsClimbedType = HKSampleType.quantityType(forIdentifier: .flightsClimbed) else {
      print("Flights Climbed Type is no longer available in HealthKit")
      return
    }
    
    ProfileDataStore.queryQuantitySum(for: flightsClimbedType, unit: HKUnit.count()) { (sampleTotal, error) in
      guard let sample = sampleTotal else {
        if let error = error {
          self.displayAlert(for: error)
        }
        DispatchQueue.main.async{self.flightsClimbedLabel.text = "N/A"}
        return
      }
      
      DispatchQueue.main.async{self.flightsClimbedLabel.text = "\(Int(sample))"}
    }
  }
  
  private func loadAndDisplayDailyWaterConsumed() {
    
    guard let waterConsumedType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else {
      print("Dietary Water Type is no longer available in HealthKit")
      return
    }
    
    ProfileDataStore.queryQuantitySum(for: waterConsumedType, unit: HKUnit.fluidOunceUS()) { (sampleTotal, error) in
      
      guard let sample = sampleTotal else {
        if let error = error {
          self.displayAlert(for: error)
        }
        DispatchQueue.main.async{self.waterConsumedLabel.text = "N/A"}
        return
      }
      
      let waterInOunces = sample
      let formatted = String(format: "%.2f", waterInOunces)
      DispatchQueue.main.async{self.waterConsumedLabel.text = formatted}
    }
  }
}

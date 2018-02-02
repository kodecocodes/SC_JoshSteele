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

class WaterInputTableViewController: UITableViewController {
  
  private enum WaterInputSection: Int {
    case label
    case inputWater
    case saveWater
  }
  
  private enum WaterInputDataError: Error {
    
    case missingWaterConsumed
    case invalidValue
    
    var localizedDescription: String {
      switch self {
      case .missingWaterConsumed:
        return "Unable to save water consumed - no value entered."
      case .invalidValue:
        return "Unable to save water consumed - invalid value entered."
      }
    }
  }
  
  @IBOutlet weak var waterConsumedInputField: UITextField!
  @IBOutlet weak var waterUnitSegmentedControl: UISegmentedControl!
  
  private func displayAlert(for error: WaterInputDataError) {
    
    print("error is \(error)")
    let alert = UIAlertController(title: nil,
                                  message: error.localizedDescription,
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
  
  private func saveWaterConsumedToHealthKit() {
    
    guard let waterConsumed = waterConsumedInputField.text else {
      displayAlert(for: WaterInputDataError.missingWaterConsumed)
      return
    }
    
    guard let waterConsumedValue = Double(waterConsumed) else
    {
      displayAlert(for: WaterInputDataError.invalidValue)
      return
    }
    
    guard let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else {
      fatalError("Dietary Water Type is no longer available in HealthKit")
    }
    
    ProfileDataStore.saveSample(value: waterConsumedValue, unit: waterUnitSegmentedControl.getHKUnit(), type: waterType, date: Date())
  }
  
  //MARK:  UITableView Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let section = WaterInputSection(rawValue: indexPath.section-1) else {
      fatalError("A WaterInputSection should map to the index path's section")
    }
    
    switch section {
    case .saveWater:
      saveWaterConsumedToHealthKit()
      waterConsumedInputField.text = ""
      tableView.deselectRow(at: indexPath, animated: true)
    default: break
    }
  }
}

extension WaterInputTableViewController:UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension UISegmentedControl
{
  func getHKUnit() -> HKUnit
  {
    switch selectedSegmentIndex {
    case 0:
      return HKUnit.fluidOunceUS()
    default:
      return HKUnit.literUnit(with: .milli)
    }
  }
}

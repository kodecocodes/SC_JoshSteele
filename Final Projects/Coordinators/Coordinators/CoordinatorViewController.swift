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

protocol AddWaterViewControllerDelegate : class
{
  func addWaterInfo()
  func waterSaveSuccessful(waterConsumed: Double, control: UISegmentedControl)
  func waterSaveFailed(message: String)
}

extension UIViewController
{
  func presentVC(_ viewController: UIViewController)
  {
    transition(to: viewController)
  }
  
  func transition(to child: UIViewController, completion: ((Bool) -> Void)? = nil)
  {
    let duration = 0.3
    addChildViewController(child)
    
    let newView = child.view!
    newView.translatesAutoresizingMaskIntoConstraints = true
    newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    newView.frame = view.bounds

    view.addSubview(newView)
    UIView.animate(withDuration: duration, delay: 0, options: [.transitionCrossDissolve], animations: { }, completion: { done in
      child.didMove(toParentViewController: self)
      completion?(done)
    })
  }
}

class CoordinatorViewController: UIViewController {
  
  var landing:LandingPageViewController!
  var waterController:AddWaterViewController!
  var enterWorkout:EnterWorkoutTimeViewController!
  var review:ReviewViewController!
  var approval:ApprovalViewController!
  var error:ErrorViewController!
  var latestWorkoutCalories: Double!
  var latestWaterConsumed: Double!
  var latestWaterUnit: HKUnit!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createViewControllers()
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let landingPage = LandingPageViewController()
    landingPage.delegate = self
    presentVC(landingPage)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func createViewControllers()
  {
    landing = LandingPageViewController()
    landing.delegate = self
    waterController = AddWaterViewController()
    waterController.delegate = self
    enterWorkout = EnterWorkoutTimeViewController()
    enterWorkout.delegate = self
    review = ReviewViewController()
    review.delegate = self
    approval = ApprovalViewController()
    approval.delegate = self
    error = ErrorViewController()
    error.delegate = self
  }
  
  private func displayAlert(for message: String) {
    
    let alert = UIAlertController(title: nil,
                                  message: message,
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
  
}

extension CoordinatorViewController : LandingPageViewControllerDelegate
{
  func beginButtonTouched() {
    presentVC(waterController)
  }
}

extension CoordinatorViewController : AddWaterViewControllerDelegate
{
  func addWaterInfo()
  {
    displayAlert(for: "Here, you can enter your water in either oz or mL.  Remember to stay hydrated while you exercise!")
  }
  
  func waterSaveSuccessful(waterConsumed: Double, control: UISegmentedControl)
  {
    latestWaterConsumed = waterConsumed
    latestWaterUnit = control.getHKUnit()
    presentVC(enterWorkout)
  }
  
  func waterSaveFailed(message: String)
  {
    displayAlert(for: message)
  }
}

extension CoordinatorViewController : EnterWorkoutTimeViewControllerDelegate
{
  func enterWorkoutInfo()
  {
    displayAlert(for: "Here, you can enter how many calories you burned during your workout.  Try to close those rings!")
  }
  
  func enterWorkoutSaveSuccessful(calories: Double)
  {
    latestWorkoutCalories = calories
    review.waterValue = latestWaterConsumed
    review.caloriesValue = latestWorkoutCalories
    review.waterUnit = latestWaterUnit.unitString
    presentVC(review)
  }
  
  func enterWorkoutSaveFailed(message: String)
  {
    displayAlert(for: message)
  }
}

extension CoordinatorViewController : ReviewViewControllerDelegate
{
  func reviewInfo()
  {
    displayAlert(for: "Here, you can review your entries before you save the data to HealthKit!")
  }
  
  func reviewSubmitSuccessful()
  {
    guard let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else {
      fatalError("Dietary Water Type is no longer available in HealthKit")
    }
    ProfileDataStore.saveSample(value: latestWaterConsumed, unit: latestWaterUnit, type: waterType, date: Date())
    ProfileDataStore.saveWorkout(energyBurned: latestWorkoutCalories)
    
    presentVC(approval)
  }
  
  func reviewSubmitFailed()
  {
    //otherwise go to error page
    presentVC(error)
  }

}

extension CoordinatorViewController : ApprovalViewControllerDelegate
{
  func approvalInfo()
  {
    displayAlert(for: "Great job!  We've stored this workout in HealthKit!")
  }
  
  func approvalReturnToHome()
  {
    presentVC(landing)
  }
}

extension CoordinatorViewController : ErrorViewControllerDelegate
{
  func errorInfo() {
    displayAlert(for: "Oops!  Something went wrong.  Back to the review screen!")
  }
  
  func returnToReviewPage()
  {
    print("Return button touched")
    presentVC(landing)
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

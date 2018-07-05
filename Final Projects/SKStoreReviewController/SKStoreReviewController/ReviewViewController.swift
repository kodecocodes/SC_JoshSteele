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

//1. Import StoreKit
import StoreKit

class ReviewViewController: UIViewController {
  
  let userDefaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //3. Keep track of the times we've visited this screen to limit the number of review requests
    let currentFinishCount = userDefaults.integer(forKey: "numberOfEntries")
    userDefaults.set(currentFinishCount+1, forKey: "numberOfEntries")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func submitButtonTouched(_ sender: Any)
  {
    //4. If the number of entries has exceed a certain threshold, ask for a review.  For something fitness related, this number might be 100, so that 3 times a year, you can request a review.  Otherwise, iOS will determine when the review prompt gets generated
    if userDefaults.integer(forKey: "numberOfEntries") > 2
    {
      
      //2. Request a review.  This will always happen in development, never in TestFlight, and only sometimes in release!
      SKStoreReviewController.requestReview()
      
      //5. Reset the counter.
      userDefaults.set(0, forKey: "numberOfEntries")
    }
  }
}


import UIKit

class DetailWordVC: UIViewController {

    @IBOutlet weak var engLabel: UILabel!
    @IBOutlet weak var turkLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var words: Words?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let words = words {
            engLabel.text = words.ingilizce
            turkLabel.text = words.turkce
        }
    }
    

}


import UIKit

class BookInfoViewController: UIViewController {
    
    // MARK: Properities
    @IBOutlet weak var bookTitleView: UILabel!
    @IBOutlet weak var bookInfoView: UILabel!
    @IBOutlet weak var bookTextView: UITextView!
    @IBOutlet weak var locadingView: UIActivityIndicatorView!
    @IBAction func onDownload(sender: UIBarButtonItem) {
        if let checkURL = NSURL(string: "http://www.google.com") {
            
            if UIApplication.sharedApplication().openURL(checkURL) {
                print("url successfully opened")
            }
        } else {
            print("invalid url")
        }
    }
    
    var book: PtBook!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTitleView.text = book?.getTitle()
        bookInfoView.text = book?.getInfo()
        bookTextView.text = "Loading..."
        loadBookText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadBookText() {
        if book == nil {
            return
        }
        locadingView.startAnimating()
        let client = PtClient(params: "getBookInfo", String(book.id))
        client.get { (result: String?) -> () in
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                self?.bookTextView.text = result
                self?.locadingView.stopAnimating()
            })
        }
    }

}


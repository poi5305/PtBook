import UIKit

class BookTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var bookInfoView: UILabel!
    @IBOutlet weak var bookNameView: UILabel!
    
    // MARK: Data structure
    var book: PtBook!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateBook(newBook: PtBook) {
        book = newBook
        bookNameView.text = book.getTitle();
        bookInfoView.text = book.getInfo();
    }

}

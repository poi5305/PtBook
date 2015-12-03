import Foundation

struct PtBook {
    
    var id: Int!
    var name: String!
    var type: String!
    var posts: Int!
    var pages: Int!
    var currentPages: Int!
    var looks: Int!
    var likes: Int!
    var info: String!
    var source: String!
    
    func getTitle() -> String {
        return type + " " +  name
    }
    
    func getInfo() -> String {
        return "[文章/人氣/喜歡] [" + String(posts)
            + "/" + String(looks) + "/" + String(likes) + "]"
    }

    static func parseBooks(data: NSData?) -> [PtBook] {
        var books = [PtBook]()
        if data == nil {
            return books
        }
        do {
            let jsonObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!,
                options: .AllowFragments)
            if let items = jsonObj as? NSArray as? [[String : AnyObject]] {
                for item: [String : AnyObject] in items {
                    if let book = PtBook.parseBook(item) {
                        books.append(book)
                    }
                }
            }
        } catch _ {
            print("string to json obj fail")
            return books
        }
        return books
    }
    
    static func parseBook(data: [String: AnyObject]) -> PtBook? {
        let id: Int? = data["id"] as? Int;
        let name: String? = data["name"] as? String
        let type: String? = data["class"] as? String
        let posts: Int? = data["posts"] as? Int
        let pages: Int? = data["pages"] as? Int
        let currentPages: Int? = data["current_pages"] as? Int
        let looks: Int? = data["looks"] as? Int
        let likes: Int? = data["likes"] as? Int
        let info: String? = data["info"] as? String
        let source: String? = data["sources"] as? String
        
        return PtBook(id: id, name: name, type: type, posts: posts, pages: pages,
            currentPages: currentPages, looks: looks, likes: likes, info: info,
            source: source)
    }
    
}
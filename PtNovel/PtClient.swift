import Foundation

class PtClient {
    
    let timeout = 10.0
    let session: NSURLSession!
    var task: NSURLSessionDataTask?
    var url = "http://10.116.137.22/ptnovel/client"
    
    init(params: String...) {
        for param in params {
            url += "/" + param
        }
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = timeout
        session = NSURLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }
    
    func get(done: (result: String?) -> ()) {
        get { (result: NSData?) in
            if result == nil {
                done(result: nil)
                return;
            }
            let result: String? = String(data: result!, encoding: NSUTF16StringEncoding)
            done(result: result)
        };
    }
    
    func get(done: (result: NSData?) -> ()) {
        print(url)
        if let nsurl = NSURL(string: url) {
            task = session.dataTaskWithURL(nsurl) {
                [weak self] (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                done(result: data)
                self?.session.finishTasksAndInvalidate()
            }
            task?.resume()
        } else {
            // url fail
            done(result: nil)
        }
    }
    
    func getUrl() -> String {
        print(url)
        return url
    }
    
}
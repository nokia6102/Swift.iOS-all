import UIKit

class ViewController: UIViewController,UIWebViewDelegate
{
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let url = URL(string: "http://www.ipeen.com.tw")!
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
        
        webView.delegate = self
    }


    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        let html = webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")
        print("載入內容：\n\(String(describing: html))")
    }
    
}


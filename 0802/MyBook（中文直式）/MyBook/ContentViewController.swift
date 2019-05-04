import UIKit

class ContentViewController: UIViewController
{
    //呈現的頁面內容
    @IBOutlet weak var imgContent: UIImageView!
    //顯示頁碼
    @IBOutlet weak var lblPage: UILabel!
    //記錄目前頁碼（供PageViewController傳遞頁碼使用）
    var currentPage = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //顯示目前頁碼
        lblPage.text = "\(currentPage)"
        
        //準備檔名
        let fileName = String(format: "page%i.jpg", currentPage)
        //顯示圖片
        imgContent.image = UIImage(named: fileName)
    }
    //失效的手勢（因為所有系統手勢已經被PageViewController捕捉了，只能使用自訂手勢增加其他手勢感應）
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer)
    {
        print("點擊手勢！！！！！")
    }
    
}

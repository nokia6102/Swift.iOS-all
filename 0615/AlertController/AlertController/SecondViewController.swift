import UIKit

class SecondViewController: UIViewController
{
    //記錄上一頁傳來的登入帳號
    var loginName = ""
    weak var firstVC:ViewController!    //記錄上一頁的執行實體
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        print("第二頁收到的登入帳號：\(loginName)")
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //初始化訊息框控制器
        let alertController = UIAlertController(title: "App訊息", message: "Hello!\(loginName)\n第二頁已經載入完成！", preferredStyle: .alert)
        //準備一個訊息框的按鈕
        let okAction = UIAlertAction(title: "返回", style: .destructive) { (action) in
            //移除本頁
            self.dismiss(animated: true, completion: nil)
        }
        //在訊息框控制器中加入一個按鈕
        alertController.addAction(okAction)
        //顯示訊息框
        show(alertController, sender: nil)
    }
    
}

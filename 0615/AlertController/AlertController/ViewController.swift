import UIKit

class ViewController: UIViewController
{
    //記錄登錄狀態
    var loginSuccess = false
    //記錄登入帳號
    var uid = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //初始化訊息框控制器
        let alertController = UIAlertController(title: "App訊息", message: "App已經啟動完成！", preferredStyle: .alert)
        //準備一個訊息框的按鈕
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        //在訊息框控制器中加入一個按鈕
        alertController.addAction(okAction)
        //顯示訊息框
        show(alertController, sender: nil)
    }
    
    //由換頁線呼叫的事件
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //從換頁線上，取得下一頁的執行體
        let secondVC = segue.destination as! SecondViewController   //向下轉型為精確的類別
        //在下一頁中記錄登入帳號
        secondVC.loginName = uid
        secondVC.firstVC = self
    }
    
    //登入按鈕
    @IBAction func btnLogin(_ sender: UIButton)
    {
        //Step1.初始化訊息框控制器
        let alert = UIAlertController(title: "登入", message: "請輸入帳號密碼", preferredStyle: .alert)
        
        //Step2_1.產生第一個文字輸入框
        alert.addTextField { (textField) in
            textField.placeholder = "帳號"
        }
        
        //Step2_2.產生第二個文字輸入框
        alert.addTextField { (textField) in
            textField.placeholder = "密碼"
            textField.isSecureTextEntry = true
        }
        
        //Step3_1.準備一個訊息框的"取消"按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        //Step3_2.準備一個訊息框的"登入"按鈕
        let loginAction = UIAlertAction(title: "登入", style: .default) { (action) in
            //接收輸入框訊息
            self.uid = alert.textFields![0].text!  //讀取輸入的帳號
            let pwd = alert.textFields![1].text!  //讀取輸入的帳號
        
            print("帳號：\(self.uid),密碼：\(pwd)")
            
            //去資料庫確認帳號、密碼是否存在
            //----to do----
            //假設帳號、密碼確認成功
            if self.uid == "perkin" && pwd == "1234"
            {
                //變更登入狀態為已登入
                self.loginSuccess = true
                //呼叫轉頁線換頁
                self.performSegue(withIdentifier: "NextPage", sender: nil)
            }
            
        }
        //Step3_3.加入兩個按鈕
        alert.addAction(cancelAction)
        alert.addAction(loginAction)
        
        //Step4.顯示訊息框
        show(alert, sender: nil)
    }
    
    
}


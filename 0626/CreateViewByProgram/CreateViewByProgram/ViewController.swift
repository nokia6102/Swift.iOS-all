import UIKit

class ViewController: UIViewController
{
    //準備讓UIButton呼叫的函式
    func onClick(_ sender:UIButton)
    {
        print("按鈕被按")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //宣告並初始化UIButton
        let button = UIButton(type: .system)
        //設定按鈕的文字
        button.setTitle("按我", for: .normal)
        //設定按鈕出現的位置
        button.frame = CGRect(x: 20, y: 20, width: 100, height: 40)
        //連結按鈕的觸發事件
        button.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        //將按鈕加到畫面上
        self.view.addSubview(button)
    }

}


import UIKit

class SecondViewController: UIViewController
{
    //接收上一頁傳來的資料
    var str:String? //= nil
    //顯示上一頁傳來的資料
    @IBOutlet weak var lblMessage: UILabel!
    //紀錄上一頁的執行實體
    weak var firstVC:ViewController!
    
    //1.controller的view載入完成（只做一次）
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("view2載入完成")
        if let str = str
        {
            print("上一頁傳來：\(str)")
            self.lblMessage.text = str + "!" + self.firstVC.txtName.text!
        }
    }
    //2.controller的view即將被加入view hierarchy
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        print("view2即將被加入")
    }
    //3.controller的view已被加入view的階層架構中
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("view2已被加入")
    }
    //4.controller的view已經完成介面佈置（限制條件的定位）
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        print("view2已經完成介面佈置")
//        self.lblMessage.text = str + "!" + self.firstVC.txtName.text!
    }
    //5.controller的view即將從view的階層架構中移除(換下一頁時才會呼叫)
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        print("view2即將從view的階層架構中移除")
    }
    //6.view已經從view的階層架構中移除(換下一頁時才會呼叫)
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        print("view2已經從view的階層架構中移除")
    }
    
    //記憶體不足時的釋放程序
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit
    {
        print("view2被釋放")
    }
    
    //MARK: Target-Action
    @IBAction func btnBackPressed(_ sender: UIButton!)
    {
        //移除畫面的執行實體
        self.dismiss(animated: true, completion: nil)
    }
    //向右滑動手勢
    @IBAction func handleSwipeGesture(_ sender: UISwipeGestureRecognizer)
    {
        //<方法一>移除畫面的執行實體
//        self.dismiss(animated: true, completion: nil)
        
        //<方法二>按一下『返回』按鈕
        btnBackPressed(nil)
    }
    

}

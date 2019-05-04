import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var txtName: UITextField!
    
    //MARK: View Life Cycle
    //1.controller的view載入完成（只做一次）
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("view1載入完成")
    }
    //2.controller的view即將被加入view hierarchy
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        print("view1即將被加入")
    }
    //3.controller的view已被加入view的階層架構中
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("view1已被加入")
    }
    //4.controller的view已經完成介面佈置（限制條件的定位）
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        print("view1已經完成介面佈置")
    }
    //5.controller的view即將從view的階層架構中移除(換下一頁時才會呼叫)
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        print("view1即將從view的階層架構中移除")
    }
    //6.view已經從view的階層架構中移除(換下一頁時才會呼叫)
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        print("view1已經從view的階層架構中移除")
    }
    
    //記憶體不足時的釋放程序
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit
    {
        print("view1被釋放")
    }
    //當由轉換線進行換頁時，會呼叫此方法
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "segue1"
        {
            //從轉換線取得下一頁的執行實體（此時是UIViewController的視角），並進行SecondViewController的型別轉換
            let secondVC = segue.destination as! SecondViewController
            //進行傳遞資訊到下一頁（填入下一頁的屬性值）<值型別傳遞>
            secondVC.str = "hello"
            //把自己這一頁的引用傳給下一頁<引用型別傳遞>
//            secondVC.firstVC = self
        }
        else if segue.identifier == "segue2"
        {
            print("轉換到其他頁")
        }
    }
    
    //MARK: Target-Action
    @IBAction func onClick(_ sender:UIButton)
    {
        //以storyboard ID初始化下一頁的畫面（如果找不到ID，會產生例外狀況：程式當掉！使用選擇性綁定也無效！）
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SecondViewController")
        //顯示下一頁
//        show(vc, sender: nil)
        present(vc, animated: true, completion: nil)
        
    }

}

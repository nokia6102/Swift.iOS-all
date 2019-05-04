import UIKit

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    //<方法一>按下鍵盤的return鍵，觸發Did End on Exit事件
    @IBAction func onExit(_ sender: UITextField)
    {
        print("return鍵被按下")
        //請彈出鍵盤的物件，交出第一回應權
        sender.resignFirstResponder()
    }
    
    
    
}


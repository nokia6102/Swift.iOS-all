import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var lblSecond: UILabel!
    var timeLeft = 0 //倒數的剩餘秒數
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    //MARK: Target Action
    //Date Picker選定的事件
    @IBAction func valueChanged(_ sender: UIDatePicker)
    {
        //讀取要倒數的秒數
        timeLeft = Int(sender.countDownDuration) / 60 * 60
        lblSecond.text = "\(timeLeft)"
    }
    //開始倒數按鈕
    @IBAction func btnStartCountDown(_ sender: UIButton)
    {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.timeLeft -= 1
            if self.timeLeft >= 0
            {
                self.lblSecond.text = "\(self.timeLeft)"
            }
            else
            {
                //to-do：timer要停止！
            }
            print("Timer執行中....")
        }
    }
    

}


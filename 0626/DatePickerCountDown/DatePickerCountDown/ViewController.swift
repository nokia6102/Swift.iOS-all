import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var lblSecond: UILabel!
    var timeLeft = 0 //倒數的剩餘秒數
    weak var timer:Timer!   //宣告計時器
    @IBOutlet weak var btnStartCountDown: UIButton!     //宣告按鈕的屬性名稱
    
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
        if timer != nil
        {
            //更改按鈕文字
            btnStartCountDown.setTitle("開始倒數", for: .normal)
            //停止計時器
            timer.invalidate()
            print("Timer已停止！")
        }
        else
        {
            //更改按鈕文字
            btnStartCountDown.setTitle("停止倒數", for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                self.timeLeft -= 1
                print("Timer執行中....")
                if self.timeLeft >= 0
                {
                    self.lblSecond.text = "\(self.timeLeft)"
                }
                else
                {
                    //停止計時器（此處的timer為Closure的參數）
                    timer.invalidate()
                    print("Timer已停止！")
                }
            }
        }
    }
    

}


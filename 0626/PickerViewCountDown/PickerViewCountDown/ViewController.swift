import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate
{
    weak var timer:Timer!       //計時器
    var selectedTimeLeft = 0    //使用者選定的倒數秒數
    var timeLeft = 0            //倒數剩餘秒數
    @IBOutlet weak var counterPickerView: UIPickerView!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var btnStartCountDown: UIButton!
    var arrSelectedHour = [String]()        //小時陣列
    var arrSelectedMinute = [String]()      //分鐘陣列
    var arrSelectedSecond = [String]()      //秒數陣列
    //記錄滾輪上選定的時、分、秒
    var selectedHour = 0
    var selectedMinute = 0
    var selectedSecond = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //產生小時陣列的元素
        for i in 0...23
        {
            arrSelectedHour.append("\(i)時")
        }
        
        for j in 0...59
        {
            arrSelectedMinute.append("\(j)分")
            arrSelectedSecond.append("\(j)秒")
        }
        print("小時陣列：\(arrSelectedHour)")
        print("分鐘陣列：\(arrSelectedMinute)")
        print("秒數陣列：\(arrSelectedSecond)")
        //設定pickerView的資料來源和代理事件實作在此類別
        counterPickerView.dataSource = self
        counterPickerView.delegate = self
        
    }

    //MARK: Target Action
    //開始倒數按鈕
    @IBAction func startCountDown(_ sender: UIButton)
    {
        if timer != nil
        {
            //停止計時器
            timer.invalidate()
            print("Timer已停止！")
            //把原先選定的倒數秒數，顯示回原來的Label上
            lblSecond.text = "\(selectedTimeLeft)"
            //讓滾輪上的倒數時間，與剩餘時間ㄧ致
            timeLeft = selectedTimeLeft
            //更改按鈕文字
            btnStartCountDown.setTitle("開始倒數", for: .normal)
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
                    //把原先選定的倒數秒數，顯示回原來的Label上
                    self.lblSecond.text = "\(self.selectedTimeLeft)"
                    //讓滾輪上的倒數時間，與剩餘時間ㄧ致
                    self.timeLeft = self.selectedTimeLeft
                    //把按鈕文字改回"開始倒數"
                    self.btnStartCountDown.setTitle("開始倒數", for: .normal)
                }
            }
         }
    }
    
    //MARK: UIPickerViewDataSource
    //設定有幾個滾輪
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 3
    }
    //每個滾輪有幾列
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        //分別指定三個滾輪的個數
        switch component
        {
            case 0:
                return arrSelectedHour.count
            case 1:
                return arrSelectedMinute.count
            case 2:
                return arrSelectedSecond.count
            default:
                return 0
        }
    }
    
    //MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        //分別指定三個滾輪的文字
        switch component
        {
            case 0:
                return arrSelectedHour[row]
            case 1:
                return arrSelectedMinute[row]
            case 2:
                return arrSelectedSecond[row]
            default:
                return ""
        }
    }
    //滾輪被滾動之後的選定狀態
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //分別判定三個滾輪的選定狀態
        switch component
        {
            //直接以陣列索引值來記錄選定的時、分、秒
            case 0:
                selectedHour = row
            case 1:
                selectedMinute = row
            case 2:
                selectedSecond = row
            default:
                break   //函式無回傳值，可直接break
        }
        //計算使用者選定的倒數秒數
        selectedTimeLeft = selectedHour*60*60+selectedMinute*60+selectedSecond
        //記錄要倒數秒數
        timeLeft = selectedTimeLeft
        //顯示倒數秒數
        lblSecond.text = "\(timeLeft)"
    }
    
}


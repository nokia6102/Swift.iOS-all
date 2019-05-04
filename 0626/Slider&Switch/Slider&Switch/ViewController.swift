import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var slider: UISlider!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //第一次加入Target Action
        slider.addTarget(self, action: #selector(valuedChanged(_:)), for: .valueChanged)
        //移除Target Action
        slider.removeTarget(self, action: #selector(valuedChanged(_:)), for: .valueChanged)
        //再加入另一個Target Action
        slider.addTarget(self, action: #selector(valuedChanged2(_:)), for: .valueChanged)
    }

    func valuedChanged(_ sender: UISlider)
    {
        print("Slider值：\(sender.value)")
    }

    func valuedChanged2(_ sender: UISlider)
    {
        print("Slider值2：\(sender.value)")
    }
    //開關的value change感應事件
    @IBAction func switchPressed(_ sender: UISwitch)
    {
        if sender.isOn
        {
            print("開關被打開")
        }
        else
        {
            print("開關被關閉")
        }
    }
    
    
    
}


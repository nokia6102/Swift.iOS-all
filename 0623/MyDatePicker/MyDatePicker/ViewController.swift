import UIKit

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    @IBAction func valueChanged(_ sender: UIDatePicker)
    {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy/M/d H:m"
        let string = formater.string(from: sender.date)
        print("選定的日期：\(string)")
    }
}


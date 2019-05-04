import UIKit

class SecondViewController: UIViewController
{
    //記錄上一頁的執行實體
    weak var FirstVC:ViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 3.5) {
            //把第二頁的底面顏色，設成跟第一頁的色塊同色
            self.view.backgroundColor = self.FirstVC.colorVC.backgroundColor
        }
        
    }
    

    @IBAction func btnBack(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }

}

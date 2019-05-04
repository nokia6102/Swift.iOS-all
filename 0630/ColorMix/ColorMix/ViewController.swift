import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var colorVC: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        let secondVC = segue.destination as! SecondViewController
        secondVC.FirstVC = self
    }
    //當拖動紅、綠、藍滑桿時
    @IBAction func ColorValueChanged(_ sender: UISlider)
    {
        //直接設定顏色區塊的背景色
        colorVC.backgroundColor = UIColor(red: CGFloat(redSlider.value / 255), green: CGFloat(greenSlider.value / 255), blue: CGFloat(blueSlider.value / 255), alpha: 1)
    }
    
    
}


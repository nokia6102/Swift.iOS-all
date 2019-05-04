import UIKit
import QuartzCore

class ViewController: UIViewController
{
    @IBOutlet weak var aSlider: UISlider!
    var layer1:CALayer!
    var layer2:CALayer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //========圖層1========
        //產生圖片
        var image = UIImage(named: "circle.png")
        //初始化圖層
        layer1 = CALayer()
        //設定圖層大小
        layer1.frame = CGRect(x: 50, y: 100, width: 200, height: 200)
        //在圖層上繪製出圖片
        layer1.contents = image?.cgImage
        //顯示圖層
        self.view.layer.addSublayer(layer1)
        
        //========圖層2========
        //產生圖片
        image = UIImage(named: "sample.jpg")
        //計算圖片的長寬比例
        let ratio = image!.size.width / image!.size.height
        //初始化圖層
        layer2 = CALayer()
        //設定圖層大小(高度以等比例縮放)
        layer2.frame = CGRect(x: 50, y: 400, width: 200, height: 200 / ratio)
        //在圖層上繪製出圖片
        layer2.contents = image?.cgImage
        //顯示圖層
        self.view.layer.addSublayer(layer2)

    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider)
    {
        //從滑桿值取得要旋轉的『角度』
        let deg = sender.value
        //將『角度』換成『弧度』
        let rad = deg / 180 * Float.pi
        //設定『旋轉矩陣』
        let rotation = CGAffineTransform(rotationAngle: CGFloat(rad))
        //進行圖層的『矩陣轉換』
        layer1.setAffineTransform(rotation)
        //同步旋轉另一個slider
        aSlider.layer.setAffineTransform(rotation)
    }
    
    @IBAction func btnCornerRadius(_ sender: UIButton)
    {
        if !layer2.masksToBounds //沒有裁切時
        {
            //設定圖層的四個圓角
            layer2.cornerRadius = 20
            //裁掉圓角以外的區域
            layer2.masksToBounds = true
        }
        else
        {
            //不要裁切
            layer2.masksToBounds = false
        }
    }
    
    
}


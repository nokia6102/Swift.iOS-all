import UIKit
import QuartzCore

class ViewController: UIViewController
{
    @IBOutlet weak var aSlider: UISlider!
    var layer1:CALayer!
    var layer2:CALayer!
    var shadowLayer:ShadowLayer!        //自製的陰影層
    
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
        
        //先讓陰影的角度歸零（因為此屬性值預設為3）
        layer2.shadowRadius = 0
        //顯示圖層
        self.view.layer.addSublayer(layer2)

    }
    //滑桿的value changed事件
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
    //圓角按鈕
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
    //陰影按鈕
    @IBAction func btnShadow(_ sender: UIButton)
    {
//        print("layer2.shadowRadius==\(layer2.shadowRadius)")
        if layer2.shadowRadius == 0
        {
            //設定陰影的顏色
            layer2.shadowColor = UIColor.black.cgColor
            //設定陰影向右下角偏移10點
            layer2.shadowOffset = CGSize(width: 10, height: 10)
            //設定陰影的透明度
            layer2.shadowOpacity = 0.8
            //設定陰影的圓角
            layer2.shadowRadius = 5.0
        }
        else
        {
            layer2.shadowRadius = 0.0
            //還原陰影顏色為透明色
            layer2.shadowColor = UIColor.clear.cgColor
        }
        
    }
    //圓角＋陰影按鈕（從圓角按鈕的程式碼出發，再額外增加自製的陰影層）
    @IBAction func btnCornerAndShadow(_ sender: UIButton)
    {
        if !layer2.masksToBounds //沒有裁切時
        {
            //設定圖層的四個圓角
            layer2.cornerRadius = 20
            //裁掉圓角以外的區域
            layer2.masksToBounds = true
            //========以下製作自製的陰影圖層========
            //初始化自製陰影層
            shadowLayer = ShadowLayer()
            //把陰影的大小設成跟上方圖層一致
            shadowLayer.frame = layer2.frame
            //設定陰影圖層的陰影顏色
            shadowLayer.shadowColor = UIColor.blue.cgColor
            //設定陰影圖層的背景色（圖層本身的顏色）
            shadowLayer.backgroundColor = UIColor.red.cgColor
            //陰影圖層的陰影向右下角偏移5點
            shadowLayer.shadowOffset = CGSize(width: 5, height: 5)
            //陰影圖層的陰影透明度
            shadowLayer.shadowOpacity = 0.8
            //把陰影圖層的圓角設成跟上層圖片一致
            shadowLayer.cornerRadius = layer2.cornerRadius
            //把自製的陰影圖層加到原來的圖層下方
            view.layer.insertSublayer(shadowLayer, below: layer2)
        }
        else
        {
            //不要裁切
            layer2.masksToBounds = false
            
            if shadowLayer != nil
            {
                //移除陰影圖層
                shadowLayer.removeFromSuperlayer()
                shadowLayer = nil
            }
            
        }
    }
    
    deinit
    {
        //假設在第二頁時，此處必須自行釋放強引用的物件
        layer1 = nil
        layer2 = nil
    }
    
}


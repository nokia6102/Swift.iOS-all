import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var btnAnimation: UIButton!
    
    /*
     UIView動畫可以改變的屬性
     frame
     bounds
     center
     transform
     alpha
     backgroundColor
     contentStretch
    */
    //記錄設備目前的寬和高
    var DeviceWidth:CGFloat!
    var DeviceHeight:CGFloat!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //檢查執行App的裝置類型
        switch self.traitCollection.userInterfaceIdiom
        {
            case .pad:
                print("此裝置為iPad")
            case .phone:
                print("此裝置為iPhone")
            case .tv:
                print("此裝置為Apple TV")
            case .carPlay:
                print("此裝置為車用裝置")
            case .unspecified:
                print("此裝置未知")
        }
        //記錄設備目前的寬和高
        DeviceWidth = UIScreen.main.bounds.size.width
        DeviceHeight = UIScreen.main.bounds.size.height
        print("viewDidLoad（寬高）：（\(DeviceWidth!),\(DeviceHeight!)）")
//        //取得目前設備的方向（注意：此處orientation沒有值，因為還沒完成畫面佈置，所以switch只會跑default段）
//        let orientation = UIDevice.current.orientation
//        
//        switch orientation
//        {
//            case .portrait,.portraitUpsideDown:
//                imgBackground.image = UIImage(named: "picPortrait.jpg")
//            case .landscapeLeft,.landscapeRight:
//                imgBackground.image = UIImage(named: "picLandscape.jpg")
//            default:
//                imgBackground.image = UIImage(named: "picPortrait.jpg")
//        }
    }
    //已經完成畫面配置
    override func viewDidLayoutSubviews()
    {
        print("已經完成畫面配置")
        //取得目前設備的方向
        let orientation = UIDevice.current.orientation
        
        switch orientation
        {
            case .portrait,.portraitUpsideDown:
                imgBackground.image = UIImage(named: "picPortrait.jpg") //以檔名載入圖片
                imgBook.image = UIImage(named: "PImage")                //以卡匣名稱載入圖片
            case .landscapeLeft,.landscapeRight:
                imgBackground.image = UIImage(named: "picLandscape.jpg")
                imgBook.image = UIImage(named: "LImage")
            default:
                imgBackground.image = UIImage(named: "picPortrait.jpg")
                imgBook.image = UIImage(named: "PImage")
        }
        //底圖填滿螢幕
        imgBackground.frame = CGRect(x: 0, y: 0, width: DeviceWidth, height: DeviceHeight)
        //請self.view將imgBook往上提（避免被imgBackground蓋住）
        self.view.bringSubview(toFront: imgBook)
        //請self.view將btnAnimation往上提（避免被imgBackground蓋住）
        self.view.bringSubview(toFront: btnAnimation)
    }

    //支援所有方向（以唯讀計算屬性實作）
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        //回傳所有方向
        return .all
        
        //上下顛倒不支援
//        return .allButUpsideDown
    }
    
    //當裝置的長寬狀態有所改變時（狀態指regular、compact改變時） PS.iPad旋轉時，寬高都是regular，所以不會觸發此事件
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator)
    {
        switch newCollection.horizontalSizeClass
        {
            case .compact:
                print("Compact Width")
            case .regular:
                print("Regular Width")
            case .unspecified:
                print("Width未知")
        }
        
        switch newCollection.verticalSizeClass
        {
            case .compact:
                print("Compact Height")
            case .regular:
                print("Regular Height")
            case .unspecified:
                print("Height未知")
        }
        
        //執行伴隨著旋轉的動畫
        coordinator.animate(alongsideTransition: nil) { (context) in
            //按一下執行動畫的按鈕
            self.doAnimation(nil)
        }
        
    }
    
    //當設備的寬與高改變時（發生旋轉時）
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("當設備的寬與高改變時（發生旋轉時）")
        switch UIDevice.current.orientation
        {
            case .faceDown:
                print("裝置面朝下")
            case .faceUp:
                print("裝置面朝下")
            case .landscapeLeft:
                print("裝置橫向向左")
            case .landscapeRight:
                print("裝置橫向向右")
            case .portrait:
                print("裝置直立")
            case .portraitUpsideDown:
                print("裝置上下顛倒")
            case .unknown:
                print("無法判定")
        }
        //記錄旋轉後的寬與高
        DeviceWidth = size.width
        DeviceHeight = size.height
        print("旋轉後～寬：\(DeviceWidth!) 高：\(DeviceHeight!)")
    }

    //執行動畫按鈕事件
    @IBAction func doAnimation(_ sender: UIButton!)
    {
        UIView.animate(withDuration: 0.2, animations: {
            //<第一段>移動水平位置到螢幕最右側（注意：Objective-C只能針對上層的frame結構進行調整）
            self.imgBook.frame.origin.x += self.DeviceWidth - self.imgBook.frame.size.width
            self.imgBook.alpha = 0.2
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                //<第二段>移動垂直位置到螢幕最下方（注意：Objective-C只能針對上層的frame結構進行調整）
                self.imgBook.frame.origin.y += self.DeviceHeight - self.imgBook.frame.size.height
                self.imgBook.alpha = 1
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.2, animations: {
                    //<第三段>移動水平位置到螢幕最左側（Y軸依然維持在最下方）
                    self.imgBook.frame.origin.x = 0
                    self.imgBook.alpha = 0.2
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.2, animations: {
                        //<第四段>移動垂直位置到螢幕最上方
                        self.imgBook.frame.origin.y = 0
                        self.imgBook.alpha = 1
                    })
                })
                
            })
        }
    }
    
}


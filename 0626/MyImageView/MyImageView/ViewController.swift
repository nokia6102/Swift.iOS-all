import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //檔名可不區分大小寫
        imageView.image = UIImage(named: "sample.jpg")
        imageView.contentMode = .scaleAspectFill
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        //取得螢幕大小（注意：旋轉時，寬高會交換，所以都必須重新取得一次螢幕大小）
        let screenRect = UIScreen.main.bounds
        //設定圖片的大小和位置
        imageView.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        
        print("Layout重新配置")
    }
    
    //定義本畫面可以支援的方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .all
    }

}


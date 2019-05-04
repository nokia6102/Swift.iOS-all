import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    //宣告連播圖片陣列
    var images = [UIImage]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        for i in 1...10
        {
            let fileName = String(format: "%02d.jpg", i)
            images.append(UIImage(named: fileName)!)
        }
        //設定播放陣列給imageView
        imageView.animationImages = images
        //設定縮放模式
        imageView.contentMode = .scaleAspectFill
        //指定播放時間
        imageView.animationDuration = 10
        //指定播放次數（0為無限次播放）
        imageView.animationRepeatCount = 2
        //開始播放
        imageView.startAnimating()
    }


}


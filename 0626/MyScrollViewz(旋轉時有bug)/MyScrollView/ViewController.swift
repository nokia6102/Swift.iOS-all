import UIKit

class ViewController: UIViewController,UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    //準備一張imageView
    let imageView = UIImageView(image: UIImage(named: "sample.jpg"))
    //記錄設備的寬與高
    var deviceWidth:CGFloat = 0
    var deviceHeight:CGFloat = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //取得設備的寬與高
        deviceWidth = UIScreen.main.bounds.size.width
        deviceHeight = UIScreen.main.bounds.size.height
        print("螢幕寬：\(deviceWidth) 高：\(deviceHeight)")
        //指派scrollView的代理人
        scrollView.delegate = self
        //此處縮放模式建議設定成『等比例縮放後符合原image大小的模式』
        imageView.contentMode = .scaleAspectFit
        //將imageView加到scrollView的容器中
        scrollView.addSubview(imageView)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //指定imageView的大小參考到scrollView的本身大小
        imageView.frame = scrollView.bounds
        //將scrollView的容器大小，設定跟imageView一樣大
        scrollView.contentSize = imageView.frame.size
        print("縮放比：\(scrollView.zoomScale)")
        //設定回彈位置
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        print("content size = \(scrollView.contentSize)")
        //取得設備的寬與高
        deviceWidth = UIScreen.main.bounds.size.width
        deviceHeight = UIScreen.main.bounds.size.height
        print("螢幕寬：\(deviceWidth) 高：\(deviceHeight)")
        //調整放大倍率
        if deviceWidth <= imageView.frame.size.width    //圖比螢幕大
        {
            scrollView.zoomScale = deviceWidth / imageView.frame.size.width
        }
        else        //螢幕比圖大
        {
            scrollView.zoomScale = imageView.frame.size.width / deviceWidth
        }
        print("縮放比：\(scrollView.zoomScale)")
    }
    //支援所有方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .all
    }
    //發生旋轉時
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        //先恢復縮放比例為1
        scrollView.zoomScale = 1
    }

    //MARK: UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        //指定scrollView內允許縮放的標的為imageView
        return imageView
    }
    //當scroll view發生捲動時
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        print("畫面偏移量:\(scrollView.contentOffset)")
    }
    
}


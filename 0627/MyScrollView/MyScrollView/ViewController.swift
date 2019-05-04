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
        //將scrollView的容器大小，設定跟imageView一樣大
        scrollView.contentSize = imageView.frame.size
//        //設定回彈位置(預設值為UIEdgeInsetsZero，top、left、bottom、right都為0)
//        scrollView.contentInset = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 0)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        print("content size = \(scrollView.contentSize)")
        //取得設備的寬與高
        deviceWidth = UIScreen.main.bounds.size.width
        deviceHeight = UIScreen.main.bounds.size.height
        print("螢幕寬：\(deviceWidth) 高：\(deviceHeight)")
        print("縮放比：\(scrollView.zoomScale)")
        //先恢復縮放比例為1
        scrollView.zoomScale = 1
        //指定imageView的大小參考到scrollView的本身大小
        imageView.frame = scrollView.bounds
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


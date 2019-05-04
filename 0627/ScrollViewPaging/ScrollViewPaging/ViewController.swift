import UIKit

class ViewController: UIViewController,UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageViews = [UIImageView]()
    var counter = 0 //測試scrollViewDidScroll事件被呼叫幾次使用
    var timerPageCount = 0  //由timer變動的目前頁碼
    weak var timer:Timer!   //宣告自動翻頁的計時器
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //準備要加入scrollView的圖片
        imageViews.append(UIImageView(image: UIImage(named: "a.jpg")))
        imageViews.append(UIImageView(image: UIImage(named: "b.jpg")))
        imageViews.append(UIImageView(image: UIImage(named: "c.jpg")))
        for i in 1...10
        {
            let fileName = String(format: "%02d.jpg", i)
            imageViews.append(UIImageView(image: UIImage(named: fileName)))
        }
        //將頁面指示器往上提（避免被scrollView蓋住）
//        self.view.bringSubview(toFront: pageControl)
        
        //依據圖片陣列的個數來設定頁面指示器的頁數
        pageControl.numberOfPages = imageViews.count
        pageControl.currentPage = 0     //指定停留的起始頁
        //指定scrollView代理人在本類別
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //取得scrollView的大小
        let rectScrollView = scrollView.bounds
        //準備一個記錄ImageView大小的總和的屬性
        var totalImageViewSize = CGSize()  //CGSize.zero
        //記錄目前迴圈中處理的圖片之左側圖片
        var leftImageView:UIImageView?
        //迴圈列出準備加入scrollView的圖片
        for imageView in imageViews
        {
            //調整每張圖片的縮放模式
            imageView.contentMode = .scaleToFill
            //如果是第一張圖片（左側沒有其他圖片）
            if leftImageView == nil
            {
                //將ScrollView的大小直接設定給第一張圖片（不需要錯位）
                imageView.frame = rectScrollView
            }
            else    //第二張圖片，需錯開上一張圖片的位置
            {
                imageView.frame = leftImageView!.frame.offsetBy(dx: leftImageView!.frame.size.width, dy: 0)
            }
            //記錄上一張圖片（左側的圖片）
            leftImageView = imageView
            //加總每一張圖片的寬度（高度維持scrollView的高度）
            totalImageViewSize = CGSize(width: totalImageViewSize.width+imageView.frame.size.width, height: rectScrollView.size.height)
            //將每一張圖片加入scollView中（注意：每一張圖片的位置已經被錯開了！）
            scrollView.addSubview(imageView)
        }
        //設定scrollView的可捲動範圍為每一張圖片加總後的寬度
        scrollView.contentSize = totalImageViewSize
        //初始化計時器
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true, block: { (timer) in
            //如果timer計算的頁碼，是"最後一頁的前一頁"
            if self.timerPageCount < self.pageControl.numberOfPages - 1
            {
                self.timerPageCount += 1    //timer的頁碼加一
            }
            else    //如果timer計算的頁碼已經到最後一頁
            {
                //回到第一頁
                self.timerPageCount = 0
            }
            
            //找到下一頁imageView的偏移位置
            let imageFrame = CGRect(x: self.scrollView.bounds.size.width*CGFloat(self.timerPageCount), y: 0, width: self.scrollView.bounds.size.width, height: self.scrollView.bounds.size.height)
            //捲動到下一頁
            self.scrollView.scrollRectToVisible(imageFrame, animated: true)
        })
    }
    
    //MARK: UIScrollViewDelegate
    //scrollView的翻頁事件
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        counter += 1
        print("Scroll View被捲動 \(counter)")
        print("Scroll View的content offset:\(scrollView.contentOffset)")
        
        var currentPage = 0
        //計算是否翻動超過半頁
        let diff = (scrollView.contentOffset.x - scrollView.bounds.width/2) / scrollView.bounds.width
        
        if diff >= 0.5  //翻動超過第一頁的一半以上
        {
            currentPage = Int(diff) + 1
        }
        else if (diff < 0.5 && diff >= -0.5)            //翻動沒有超過第一頁的一半
        {
            currentPage = 0
        }
        //更換頁面指示器的頁碼
        pageControl.currentPage = currentPage
        //記錄由timer操作的目前頁碼（避免自己主動翻頁時，影響到timer往下翻的頁碼）
        timerPageCount = pageControl.currentPage
        
    }
    

}


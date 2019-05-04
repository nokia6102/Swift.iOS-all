import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate
{
    //記錄內容頁面的類別實體
    var contentViewController:ContentViewController!
    //頁碼計數器（每換一頁就加1或減1）
    var pageCounter = 0
    //總頁數（總頁數不包含封面頁，因為封面頁為0）
    var totalPages = 0
    //資料庫連線（從AppDelegate取得）
    var db:OpaquePointer? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //從AppDelegate取得資料庫連線
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            db = appDelegate.getDB()
        }
        //取得電子書的總頁數（總資料筆數)
        getTotalRowsFromDB()
        //指定頁面控制器的代理人
        self.delegate = self
        self.dataSource = self
        //初始化內容頁面
        contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        //傳遞頁碼到內容頁面
        contentViewController.currentPage = pageCounter
        //讓頁面控制器目前管理的頁面
        self.setViewControllers([contentViewController], direction: .forward, animated: false, completion: nil)
    }
    
    // MARK: 自定函式
    //取得電子書的總頁數（總資料筆數)
    func getTotalRowsFromDB()
    {
        //準備查詢指令
        let sql = "select count(*) from poem"
        //將查詢指令轉成c語言的字串
        let cSql = sql.cString(using: .utf8)
        //宣告查詢結果的變數（連線資料集）
        var statement:OpaquePointer? = nil
        //執行查詢指令（-1代表不限定sql指令的長度，最後一個參數為預留參數，目前沒有作用）
        sqlite3_prepare(db, cSql!, -1, &statement, nil)
        //往下讀一筆，如果讀到資料時
        if sqlite3_step(statement) == SQLITE_ROW
        {
            //取得總頁數
            totalPages = Int(sqlite3_column_int(statement, 0))
        }
        //關閉連線資料集
        sqlite3_finalize(statement)
    }

    //MARK: UIPageViewControllerDataSource
    //（由使用者執行翻頁動作）往後翻頁
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        //不是最後一頁，才能往後翻頁
        if pageCounter < totalPages
        {
            pageCounter += 1
        }
        else    //如果是最後一頁，就回到封面頁
        {
            pageCounter = 0
        }
        //產生下一頁的頁面
        contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        //傳遞下一頁的頁碼
        contentViewController.currentPage = pageCounter
        //回傳下一頁的頁面
        return contentViewController
    }
    //（由使用者執行翻頁動作）往前翻頁
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        //不是在封面頁時，才能往前翻頁
        if pageCounter > 0
        {
            pageCounter -= 1
        }
        else    //如果在封面頁，就翻到最後一頁
        {
            pageCounter = totalPages
        }
        //產生上一頁的頁面
        contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        //傳遞上一頁的頁碼
        contentViewController.currentPage = pageCounter
        //回傳上一頁的頁面
        return contentViewController
    }
    
    //MARK: UIPageViewControllerDelegate
    //更改翻頁的旋轉軸心
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation
    {
        return .min //此為預設值，翻轉軸心在左側
    }
    
}

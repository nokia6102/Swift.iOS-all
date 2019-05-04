import UIKit

class ContentViewController: UIViewController
{
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var txtArticle: UITextView!
    @IBOutlet weak var lblPage: UILabel!
    //記錄目前頁碼（供PageViewController傳遞頁碼使用）
    var currentPage = 0
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
        
        if currentPage > 0  //不是封面頁
        {
            //讀取資料庫資料(直接顯示單筆資料)
            getDataFromDB()
        }
        else    //封面頁
        {
            imgCover.image = UIImage(named: "cover.jpg")
            lblTitle.isHidden = true
            lblAuthor.isHidden = true
            txtArticle.isHidden = true
            lblPage.isHidden = true
        }
    }
    // MARK: 自定函式
    //讀取資料庫資料(直接顯示單筆資料)
    func getDataFromDB()
    {
        //準備查詢指令(取得當頁資料)
        let sql = String(format: "select page,type,title,author,article from poem where page = %i", currentPage)
        //將查詢指令轉成c語言的字串
        let cSql = sql.cString(using: .utf8)
        //宣告查詢結果的變數（連線資料集）
        var statement:OpaquePointer? = nil
        //執行查詢指令（-1代表不限定sql指令的長度，最後一個參數為預留參數，目前沒有作用）
        sqlite3_prepare(db, cSql!, -1, &statement, nil)
        //往下讀一筆，如果讀到資料時
        if sqlite3_step(statement) == SQLITE_ROW
        {
            //取得第一個欄位，直接顯示頁碼在界面上
            lblPage.text = "\(sqlite3_column_int(statement, 0))"
            
            //取得第二個欄位（C語言字串）
            let cType = sqlite3_column_text(statement, 1)
            //轉換第二個欄位（swift字串）
            let type = String(cString: cType!)
            //製作圖檔名稱
            let fileName = type + ".png"
            //顯示圖檔
            imgType.image = UIImage(named: fileName)
            
            //取得第三個欄位(注意：此處要先轉Int，否則從陣列取出時，optional會包兩層！會造成pkvGender.selectRow當掉)
            let cTitle = sqlite3_column_text(statement, 2)
            //轉換第三個欄位（swift字串，直接顯示詩的題名）
            lblTitle.text = String(cString: cTitle!)
            
            //取得第四個欄位
            let cAuthor = sqlite3_column_text(statement, 3)
            //轉換第四個欄位（swift字串，直接顯示詩的作者）
            lblAuthor.text = String(cString: cAuthor!)
            
            //取得第五個欄位（C語言字串）
            let cArticle = sqlite3_column_text(statement, 4)
            //轉換第五個欄位（swift字串，直接顯示詩文內容）
//            txtArticle.text = String(cString: cArticle!)
            //初始化段落樣式
            let paragraphStyle = NSMutableParagraphStyle()
            //設定段落樣式的行距
            paragraphStyle.lineSpacing = 10
            //設定段落樣式的置中
            paragraphStyle.alignment = .center
            //建立樣式屬性的字典(字型大小、段落樣式)
            let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 20),NSParagraphStyleAttributeName: paragraphStyle] //將詩文內容以對應的樣式屬性顯示
            txtArticle.attributedText = NSAttributedString(string: String(cString: cArticle!) , attributes: attributes)
        }
        //關閉連線資料集
        sqlite3_finalize(statement)
    }

}

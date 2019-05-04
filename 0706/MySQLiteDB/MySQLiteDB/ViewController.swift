import UIKit

class ViewController: UIViewController
{
    var db:OpaquePointer? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //從AppDelegate取得資料庫連線
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            db = appDelegate.getDB()
        }
        
    }
    //查詢按鈕
    @IBAction func btnQuery(_ sender: UIButton)
    {
        //準備查詢指令
        let sql = "select stu_no,name from student order by stu_no"
        //將查詢指令轉成c語言的字串
        let cSql = sql.cString(using: .utf8)
        //宣告查詢結果的變數
        var statement:OpaquePointer? = nil
        //執行查詢指令（-1代表不限定sql指令的長度，最後一個參數為預留參數，目前沒有作用）
        sqlite3_prepare(db, cSql!, -1, &statement, nil)
        //往下讀一筆，如果讀到資料時
        while sqlite3_step(statement) == SQLITE_ROW
        {
            //取得第一個欄位（C語言字串）
            let stu_no = sqlite3_column_text(statement, 0)
            //轉換第一個欄位（swift字串）
            let no = String(cString: stu_no!)
            print("\(no)")
            
            //取得第二個欄位（C語言字串）
            let stu_name = sqlite3_column_text(statement, 1)
            //轉換第二個欄位（swift字串）
            let name = String(cString: stu_name!)
            print("\(name)")
            
        }
        
    }
    


}


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
    //宣告資料庫連線變數
    private var db:OpaquePointer? = nil
    //回傳資料庫連線給其他類別
    func getDB() -> OpaquePointer?
    {
        return db
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        //取得檔案管理員
        let fileManager = FileManager.default
        //取得資料庫來源路徑
        let sourceDB = Bundle.main.path(forResource: "MyDB", ofType: "db")
        //取得資料庫的目的地路徑
        let destinationDB = NSHomeDirectory() + "/Documents/MyDB.db"
        print("目的地路徑：\(destinationDB)")
        //檢查目的地的資料庫是否已經存在
        if !fileManager.fileExists(atPath: destinationDB)   //如果不存在
        {
            if let _ = try? fileManager.copyItem(atPath: sourceDB!, toPath: destinationDB)
            {
                print("資料庫檔案已成功複製！")
            }
        }
        //呼叫Sqlite函式庫，開啟目的地資料庫
        if sqlite3_open(destinationDB, &db) == SQLITE_OK
        {
            print("資料庫開啟成功！")
        }
        else
        {
            print("資料庫開啟失敗！")
            db = nil
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication)
    {

    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {

    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {

    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {

    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        //關閉資料庫
        sqlite3_close(db)
    }


}


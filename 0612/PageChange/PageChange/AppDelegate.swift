import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?

    //1.載入App（只做一次）
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        print("載入App")
        return true
    }
    //3.App即將進入背景
    func applicationWillResignActive(_ application: UIApplication)
    {
        print("App即將進入背景")
    }
    //4.App進入背景
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        print("App進入背景")
    }
    //5.App即將從背景回到前景
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        print("App即將從背景回到前景")
    }
    //2.啟動App
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        print("啟動App")
    }
    //6.App終止
    func applicationWillTerminate(_ application: UIApplication)
    {
        print("App終止")
    }

}


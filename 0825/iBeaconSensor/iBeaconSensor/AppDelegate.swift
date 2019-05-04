import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
    var locationManager = CLLocationManager()           //定位管理員
    var notificationCenter:UNUserNotificationCenter!    //推播中心
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        //設定要監聽的iBeacon裝置
        let uuid = UUID(uuidString: "70DCA321-1BF2-4BE2-B384-E4595E162EEB")
        let region = CLBeaconRegion(proximityUUID: uuid!, major: 20000, minor: 500, identifier: "")
        //設定進出region的時候要收到通知
        region.notifyOnEntry = true
        region.notifyOnExit = true
        region.notifyEntryStateOnDisplay = true
        //要求持續定位授權（需配合info.plist的Privacy - Location Always Usage Description）
        locationManager.requestAlwaysAuthorization()
        //開始掃描iBeacon的region，觸發<1號代理方法>
        locationManager.startRangingBeacons(in: region)
        //開始監聽iBeacon的region，觸發<2號代理方法>和<3號代理方法>
        locationManager.startMonitoring(for: region)
        
        //初始化推播中心
        notificationCenter = UNUserNotificationCenter.current()
        //要求授權推播功能
        notificationCenter.requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            if !granted
            {
                print("使用者未授權推播")
            }
        }
        
        return true
    }

}


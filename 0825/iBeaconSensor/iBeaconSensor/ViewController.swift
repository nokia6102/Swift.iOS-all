import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController,CLLocationManagerDelegate,UNUserNotificationCenterDelegate
{
    @IBOutlet weak var lblBeacon: UILabel!
    @IBOutlet weak var lblBeaconData: UILabel!
    @IBOutlet weak var lblRegionStatus: UILabel!
    var locationManager:CLLocationManager!
    var notificationCenter:UNUserNotificationCenter!
    
    //MARK: View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //取得應用程式代理
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //從應用程式代理取得定位管理員
        locationManager = appDelegate.locationManager
        locationManager.delegate = self
        //從應用程式代理取得推播中心
        notificationCenter = appDelegate.notificationCenter
        notificationCenter.delegate = self
    }
    
    //MARK: CLLocationManagerDelegate
    //<1號代理方法>已經得知附近的iBeacon時
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion)
    {
        //如果有拿到iBeacon的資訊
        if beacons.count > 0
        {
            //取得已知的iBeacon物件，並且讀取其大小分類的值，以及精確度和遠近
            let beacon = beacons.first
            let major = beacon!.major.intValue
            let minor = beacon!.minor.intValue
            let accuracy = beacon!.accuracy
            let rssi = beacon!.rssi
            //取得iBeacon的相對距離（距離的列舉）
            switch beacon!.proximity
            {
                case .unknown:
                    lblBeacon.text = "\(major)~\(minor) 距離未知"
                    self.view.backgroundColor = UIColor.gray
                case .immediate:
                    lblBeacon.text = "\(major)~\(minor) 就在旁邊"
                    self.view.backgroundColor = UIColor.green
                case .near:
                    lblBeacon.text = "\(major)~\(minor) 就在附近"
                    self.view.backgroundColor = UIColor.cyan
                case .far:
                    lblBeacon.text = "\(major)~\(minor) 距離很遠"
                    self.view.backgroundColor = UIColor.red
            }
            lblBeaconData.text = "iBeacon裝置：\(accuracy)-\(rssi)"
        }
    }
    
    //<2號代理方法>已經進入iBeacon範圍
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        lblRegionStatus.text = "進入 \(region.identifier) 區域"
        //初始化推播通知的訊息
        let content = UNMutableNotificationContent()
        content.title = "iBeacon訊息"
        content.body = "進入 \(region.identifier) 區域"
        content.badge = 1   //標示通知的數量
        content.sound = UNNotificationSound.default()
        //製作推播需求物件（trigger為nil表示立即發送）
        let request = UNNotificationRequest(identifier: "enterRegion", content: content, trigger: nil)
        //加到推播中心的排程
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    //<3號代理方法>已經離開iBeacon範圍
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        lblRegionStatus.text = "離開 \(region.identifier) 區域"
        //初始化推播通知的訊息
        let content = UNMutableNotificationContent()
        content.title = "iBeacon訊息"
        content.body = "離開 \(region.identifier) 區域"
        content.badge = 1   //標示通知的數量
        content.sound = UNNotificationSound.default()
        //製作推播需求物件（trigger為nil表示立即發送）
        let request = UNNotificationRequest(identifier: "exitRegion", content: content, trigger: nil)
        //加到推播中心的排程
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    //MARK: UNUserNotificationCenterDelegate
    //即將要推播出去的時候
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //執行閉包讓前景也可以推播
        completionHandler([.alert,.sound])
    }

}


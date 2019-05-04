import UIKit
import CoreLocation
import UserNotifications

class MyTableViewController: UITableViewController, CLLocationManagerDelegate,UNUserNotificationCenterDelegate
{
    var notificationCenter:UNUserNotificationCenter!
    
    //提供TableView要偵測的iBeacon設備
    var iBeaconDevices = [
        ["uuid":"70DCA321-1BF2-4BE2-B384-E4595E162EEB","major":"20000","minor":"500","identifier":"com.studio-pj.beacon","status":"確認中..."],
        ["uuid":"70DCA321-1BF2-4BE2-B384-E4595E162EEB","major":"20000","minor":"510","identifier":"com.studio-pj.beacon","status":"確認中..."]]
    
    var locationManager:CLLocationManager!   //注意：定位物件必須為全域變數
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //從AppDelegate取得位置管理員，並且指定在此實作相關的代理方法
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        locationManager = appDelegate.locationManager as CLLocationManager
        locationManager.delegate = self
        //初始化推播通知中心
        notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        //設定要監聽的iBeacon範圍
        let uuid = UUID(uuidString: "70DCA321-1BF2-4BE2-B384-E4595E162EEB")
        let region = CLBeaconRegion(proximityUUID: uuid!, identifier: "com.studio-pj.beacon")
        //設定進出region時，要收到哪些通知
        region.notifyOnEntry = true
        region.notifyOnExit = true
        region.notifyEntryStateOnDisplay = true
        //用來得知附近iBeacon的資訊，觸發<1號代理方法>
        locationManager.startRangingBeacons(in: region)
        //用來接收進入區域或離開區域的通知，觸發<2號代理方法>和<3號代理方法>
        locationManager.startMonitoring(for: region)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return iBeaconDevices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyTableViewCell
        //設定儲存格內容
        let dic = iBeaconDevices[indexPath.row]
        let uuid = dic["uuid"]!
        let major = dic["major"]!
        let minor = dic["minor"]!
        let identifier = dic["identifier"]!
        let status = dic["status"]!
        cell.lblUUID.text = uuid
        cell.lblMajor.text = major
        cell.lblMinor.text = minor
        cell.lblIdentifier.text = identifier
        cell.lblStatus.text = status
        return cell
    }

    //MARK: CLLocationManagerDelegate
    //<1號代理方法>已得知附近的iBeacon資訊
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion)
    {
        print("\(beacons.count)")
        //搜尋每一個beacon裝置
        for aBeacon in beacons
        {
            let uuid = aBeacon.proximityUUID.uuidString
            let major = aBeacon.major.intValue
            let minor = aBeacon.minor.intValue
            //比對beacon資料陣列以更新狀態
            for (arrayIndex,device) in iBeaconDevices.enumerated()
            {
                let deviceMajor = device["major"]!
                let deviceMinor = device["minor"]!
                if device["uuid"] == uuid && Int(device["major"]!)! == major && Int(device["minor"]!)! == minor
                {
                    print("beacon:\(uuid),range:\(deviceMajor)~\(deviceMinor)")
                    var arrayStatus = device["status"]!
                    switch aBeacon.proximity
                    {
                        case CLProximity.unknown:
                            print("距離未知,array:\(arrayStatus)")
                            iBeaconDevices[arrayIndex]["status"] = "距離未知"
                            arrayStatus = "距離未知"
                        case CLProximity.immediate:
                            print("就在旁邊,array:\(arrayStatus)")
                            iBeaconDevices[arrayIndex]["status"] = "就在旁邊"
                            arrayStatus = "就在旁邊"
                        case CLProximity.near:
                            print("就在附近,array:\(arrayStatus)")
                            iBeaconDevices[arrayIndex]["status"] = "就在附近"
                            arrayStatus = "就在附近"
                        case CLProximity.far:
                            print("距離遠,array:\(arrayStatus)")
                            iBeaconDevices[arrayIndex]["status"] = "距離遠"
                            arrayStatus = "距離遠"
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    //<2號代理方法>已進入iBeacon範圍
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        print("進入 \(region.identifier) 區域")
        //初始化推播通知的訊息
        let content = UNMutableNotificationContent()
        content.title = "iBeacon訊息"
        content.body = "進入 \(region.identifier) 區域！"
        //                    content.badge = 1
        content.sound = UNNotificationSound.default()
        //立即送出通知（trigger為nil）
        let request = UNNotificationRequest(identifier: "enterRegion", content: content, trigger: nil)
        //Schedule the notification
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    //<3號代理方法>已離開iBeacon範圍
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        print("離開 \(region.identifier) 區域")
        //初始化推播通知的訊息
        let content = UNMutableNotificationContent()
        content.title = "iBeacon訊息"
        content.body = "離開 \(region.identifier) 區域！"
        //        content.badge = 1
        content.sound = UNNotificationSound.default()
        //立即送出通知（trigger為nil）
        let request = UNNotificationRequest(identifier: "exitRegion", content: content, trigger: nil)
        //Schedule the notification
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    //MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //判斷是哪一個推播
        if notification.request.identifier == "enterRegion" || notification.request.identifier == "exitRegion"
        {
            //讓前景也可以推播
            completionHandler([.alert, .sound])
        }
    }
}

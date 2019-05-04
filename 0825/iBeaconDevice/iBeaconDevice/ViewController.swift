import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController,CBPeripheralManagerDelegate
{
    var peripheralManager:CBPeripheralManager!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //初始化藍芽裝置管理員，並指定在Global Queue呼叫代理事件
        let globalQueue = DispatchQueue.global(qos: .default)
        //-->觸發藍芽狀態改變時的代理事件
        peripheralManager = CBPeripheralManager(delegate: self, queue: globalQueue)
    }
    
    //MARK: CBPeripheralManagerDelegate
    //藍芽狀態改變時
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager)
    {
        switch peripheral.state
        {
            case .poweredOn:
                print("藍芽啟動中...")
            case .poweredOff:
                print("藍芽未開啟！")
                return      //離開函式
            default:
                return      //離開函式
        }
        print("準備啟動iBeacon")
        
//        peripheral.delegate = self  //<--可能是多餘的程式
        //準備iBeacon的UUID
        let uuid = UUID(uuidString: "70DCA321-1BF2-4BE2-B384-E4595E162EEB")
        //定義要模擬的iBeacon(major為大分類，minor為小分類，UUID+major+minor為唯一的iBeacon識別裝置)
        let region = CLBeaconRegion(proximityUUID: uuid!, major: 20000, minor: 500, identifier: "")
        //取得iBeacon裝置要廣播的字典物件
        var dic = region.peripheralData(withMeasuredPower: nil) as Dictionary
        dic.updateValue("這是模擬的iBeacon裝置500" as AnyObject, forKey: CBAdvertisementDataLocalNameKey as NSObject)
        //開始廣播訊號
        peripheral.startAdvertising(dic as! [String:AnyObject])
    }

}


import UIKit
import CoreBluetooth

class ViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate
{
    //藍芽服務代碼（從終端機產生UUID，指令為：uuidgen）
    let strService = "AB35D4E9-9475-47D3-B60A-21EA05C4C057"
    //訊息通知功能（發送訊息）
    let strCharacteristic1 = "7E716D74-EFB8-44E3-AF51-AB2C65CBC7AB"
    //讓Central控制器寫入資料的功能
    let strCharacteristic2 = "E65D72DD-AD1E-4579-BE1C-5A7C8F4424AB"
    
    @IBOutlet weak var txtInfo: UITextView!
    @IBOutlet weak var lblReceive: UILabel!
    //宣告藍芽Central管理員
    var centralManager:CBCentralManager!
    //記錄已發現的藍芽週邊裝置
    var foundedPeripheral:CBPeripheral!
    //記錄已發現的藍芽服務
    var foundedService:CBService!
    //記錄已發現的寫入功能（本例為第二個功能）
    var ctWritable:CBCharacteristic!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //初始化藍芽Central管理員，觸發<1號代理方法>
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    //開關事件
    @IBAction func swfPowerPressed(_ sender: UISwitch)
    {
    
    }
    
    //MARK: CBCentralManagerDelegate
    //<1號代理方法>當Central控制器的藍芽狀態改變時
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        switch central.state
        {
            case .poweredOn:
                txtInfo.text = "藍芽啟動中"
            case .poweredOff:
                txtInfo.text = "藍芽未開啟"
                return
            default:
                return
        }
        //開始掃描藍芽週邊裝置，觸發<2號代理方法>
        central.scanForPeripherals(withServices: [CBUUID(string: strService)], options: nil)
        
    }
    
    //<2號代理方法>發現週邊裝置
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        txtInfo.text = "發現藍芽裝置：\(peripheral.name!)，信號強度：\(RSSI.intValue)"
        //記錄已發現的藍芽週邊裝置
        foundedPeripheral = peripheral
        //指定週邊裝置的代理人
        peripheral.delegate = self
        //連線到已發現的週邊裝置，觸發<3號代理方法>
        central.connect(foundedPeripheral, options: nil)
    }
    
    //<3號代理方法>已連線到藍芽週邊裝置
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        //指定要存取的服務代碼
        let uuid = CBUUID(string: strService)
        //搜尋週邊裝置中，是否有特定的服務代碼，觸發<4號代理方法>
        peripheral.discoverServices([uuid])
    }
    
    //MARK: CBPeripheralDelegate
    //<4號代理方法>發現藍芽週邊裝置的服務
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        for service in peripheral.services!
        {
            if service.uuid.uuidString == strService
            {
                txtInfo.text = "已找到\(service.uuid.uuidString)服務"
                self.view.backgroundColor = UIColor.yellow
                //找出特定服務之下的附屬功能，觸發<5號代理方法>
                peripheral.discoverCharacteristics(nil, for: service)
                //記錄已發現的藍芽服務
                foundedService = service
                //停止掃描週邊裝置
                centralManager.stopScan()
            }
        }
    }
    
    //<5號代理方法>找到特定藍芽服務中的功能時
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        //列出藍芽裝置中特定服務的所有功能
        for characteristic in service.characteristics!
        {
            txtInfo.text = txtInfo.text + "已找到\(characteristic.uuid.uuidString)\n"
            //如果是第一個通知功能
            if characteristic.uuid.uuidString == strCharacteristic1
            {
                //訂閱這個通知功能，如果有收到週邊裝置送過來的資料，則觸發<6號代理方法>
                peripheral.setNotifyValue(true, for: characteristic)
            }
            
            //如果是第二個通知功能
            //--to do--
        }
    }
    
    //<6號代理方法>當收到訂閱之週邊裝置傳來的資料時
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        //從通知功能取得每秒發送過來的Data，反解碼成文字
        let str = String(data: characteristic.value!, encoding: .utf8)
        
        //顯示從週邊裝置接收到的文字
        DispatchQueue.main.async { 
            self.lblReceive.text = str
        }
    }
    
}


import UIKit
import CoreBluetooth    //引入核心藍芽框架

class ViewController: UIViewController,CBPeripheralManagerDelegate
{
    //藍芽服務代碼（從終端機產生UUID，指令為：uuidgen）
    let strService = "AB35D4E9-9475-47D3-B60A-21EA05C4C057"
    //訊息通知功能（發送訊息）
    let strCharacteristic1 = "7E716D74-EFB8-44E3-AF51-AB2C65CBC7AB"
    //讓Central控制器寫入資料的功能
    let strCharacteristic2 = "E65D72DD-AD1E-4579-BE1C-5A7C8F4424AB"
    
    @IBOutlet weak var txtInfo: UITextView!
    @IBOutlet weak var lblSend: UILabel!
    @IBOutlet weak var swfPower: UISwitch!
    //宣告藍芽週邊裝置管理員
    var peripheralManager:CBPeripheralManager!
    //初始化儲存藍芽裝置功能的陣列
    var arrCharacteristics = [CBMutableCharacteristic]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //初始化藍芽裝置管理員，觸發<1號代理方法>
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    //MARK: CBPeripheralManagerDelegate
    //<1號代理方法>藍芽狀態更新
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager)
    {
        switch peripheral.state
        {
            case .poweredOn:
                txtInfo.text = "藍芽啟動中"
            case .poweredOff:
                txtInfo.text = "藍芽未開啟"
                return
            default:
                return
        }
        //指定藍芽服務代碼
        let service = CBMutableService(type: CBUUID(string: strService), primary: true)
        
        //初始化第一個通知功能
        var characteristic = CBMutableCharacteristic(type: CBUUID(string: strCharacteristic1), properties: .notify, value: nil, permissions: .readable)
        //將第一個通知功能加入陣列
        arrCharacteristics.append(characteristic)
        
        //初始化第二個寫入功能
        characteristic = CBMutableCharacteristic(type: CBUUID(string: strCharacteristic2), properties: .write, value: nil, permissions: .writeable)
        //將第二個寫入功能加入陣列
        arrCharacteristics.append(characteristic)
        //將準備好的兩個功能加入到藍芽服務中
        service.characteristics = arrCharacteristics
        //將服務加入到藍芽裝置，觸發<2號代理方法>
        peripheralManager.add(service)
    }
    
    //<2號代理方法>服務加入藍芽裝置
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?)
    {
        if error != nil
        {
            txtInfo.text = "\(error!.localizedDescription)"
            return
        }
        txtInfo.text = "服務已經加入藍芽裝置"
        //取得iOS裝置名稱（當作這台藍芽裝置的名稱）
        let deviceName = UIDevice.current.name
        //開始廣播這個裝置的服務（以兩種方式廣播1.服務的UUID 2.藍芽設備的名稱）
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[service.uuid],CBAdvertisementDataLocalNameKey:deviceName])
        
        let q = DispatchQueue.global(qos: .default)
        q.async { 
            var i = 0
            
            while true
            {
                //累加數字
                i += 1
                //製作要送出去的Data
                let strData = "\(i)".data(using: .utf8)!
                //傳送更新到第一個通知功能
                self.peripheralManager.updateValue(strData, for: self.arrCharacteristics[0], onSubscribedCentrals: nil)
                //傳送出去的數字，同步顯示在介面上
                DispatchQueue.main.async(execute: { 
                    self.lblSend.text = "\(i)"
                })
                //讓Global Queue暫停一秒
                Thread.sleep(forTimeInterval: 1)
            }
        }
    }
    //<3號代理方法>當從Central控制器接收到寫入的資料時（假設第二個寫入功能送過來的是"ON"或"OFF"）
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest])
    {
        //取得Central控制器送過來的資訊
        let aRequest = requests.first
        //將傳來的資訊還原成文字（可能是"ON"或"OFF"，或其他文字）
        let strReceived = String(data: aRequest!.value!, encoding: .utf8)!
        
        if strReceived == "ON"
        {
            //開關打開
            swfPower.isOn = true
            //調整背景顏色為綠色
            self.view.backgroundColor = UIColor.green
        }
        else if strReceived == "OFF"
        {
            //開關關閉
            swfPower.isOn = false
            //調整背景顏色為亮藍色
            self.view.backgroundColor = UIColor.cyan
        }
        //<方法一>單一回應Central已經收到資料（若不回應，介面的變動會延遲8-20秒才會有開關的動作）
        peripheralManager.respond(to: aRequest!, withResult: .success)
        
        //<方法一>回應Central已經收到全部資料
//        for request in requests
//        {
//            peripheralManager.respond(to: request, withResult: .success)
//        }
        
    }
    

}


import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate
{
    @IBOutlet weak var pickerView: UIPickerView!
    //準備兩個空的字串陣列（要給PikerView的兩個滾輪使用）
    var list1 = [String]()      //此處書上原為let，必須改為var，否則無法加入陣列元素
    var list2 = [String]()
    let list3 = ["球類","田徑","壘球"]    //<補充>不可變動陣列用let宣告，以陣列的解譯語法直接給陣列元素
    //記錄滾輪上選定的文字
    var selectedKind = "未選定"
    var selectedItem = "未選定"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //指派pickerView的資料來源和代理人
        pickerView.dataSource = self
        pickerView.delegate = self
        //準備第一個陣列元素
        list1.append("球類")
        list1.append("田徑")
        list1.append("飛行")
        list1.append("體操")
        //準備第二個陣列元素
        list2.append("棒球")
        list2.append("壘球")
        list2.append("跳傘")
    }
    
    //MARK: UIPickerViewDataSource
    //Picker View有幾個滾輪
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        //兩個滾輪（list1一個滾輪，list2一個滾輪）
        return 2
    }
    //Picker View每一個滾輪有幾列
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        //回傳第一個滾輪有幾列
        if component == 0
        {
            return list1.count
        }
        else    //回傳第二個滾輪有幾列
        {
            return list2.count
        }
    }
    
    //MARK: UIPickerViewDelegate
    //<方法一>回傳每一個滾輪、每一列的文字
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
//    {
//        if component == 0
//        {
//            return list1[row]
//        }
//        else
//        {
//            return list2[row]
//        }
//    }
    
    //<方法二>回傳每一個滾輪、每一列的畫面
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width/2, height: pickerView.frame.size.height))
        if component == 0
        {
            myLabel.text = list1[row]
        }
        else
        {
            myLabel.text = list2[row]
        }
        
        myLabel.font = UIFont.systemFont(ofSize: 25)
        myLabel.backgroundColor = UIColor.gray
        
        return myLabel
    }
    
    //選定了滾輪上特定的位置
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if component == 0
        {
            print("使用者運動分類選擇：\(list1[row])")
            selectedKind = list1[row]
            //自動選到第二個滾輪的特定位置
            pickerView.selectRow(2, inComponent: 1, animated: true)
        }
        else
        {
            print("使用者運動項目選擇：\(list2[row])")
            selectedItem = list2[row]
            //自動選到第一個滾輪的特定位置
            pickerView.selectRow(3, inComponent: 0, animated: true)
        }
        //準備訊息視窗
        let alert = UIAlertController(title: "使用者選擇", message: "分類：\(selectedKind)\n項目：\(selectedItem)", preferredStyle: .alert)
        //準備訊息視窗上的按鈕
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        //把按鈕加到訊息視窗
        alert.addAction(okAction)
        //顯示訊息視窗
        self.present(alert, animated: true, completion: nil)
    }
    
    

}


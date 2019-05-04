import UIKit

class MyTableViewController: UITableViewController
{
    //記錄單一資料行
    var dicRow = [String:Any?]()
    //記錄查詢到的資料表（離線資料集）
    var arrTable = [[String:Any?]]()
    //目前資料行的索引值
    var currentRow = 0
//    //準備Picker View的資料來源
//    let arrClass = ["智能裝置設計","手機程式設計","網頁程式設計"]     //班別
//    let arrGender = ["女","男"]                                 //性別
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //=======讓儲存個可以自動調整大小（需配合AutoLayout）=======
        /*
        限制條件～
        1.增加imgPicture的上方、左方的Pin，以及寬和高（固定在儲存格的左上方）
        2.『學號的標題』對齊imgPicture的上方，左方距離imgPicture~10點，同時指定寬和高
        3.『姓名的標題』對齊『學號的標題』的前方，上方距離『學號的標題』20點，同時指定寬和高
        4.『性別的標題』對齊『姓名的標題』的前方，上方距離『姓名的標題』20點，同時指定寬和高
        5.『地址的標題』對齊『性別的標題』的前方，上方距離『性別的標題』20點，同時指定寬和高
        6.『學號的文字』對齊『學號的標題』的上方，左方距離『學號的標題』5點，同時指定寬和高
        7.『姓名的文字』、『性別的文字』同6.對齊方法，同時指定寬和高
        8.『地址的文字』對齊『地址的標題』的上方，左方距離『地址的標題』5點，右方距離『儲存格』5點，下方距離『儲存格』5點（不能指定寬和高，寬和高必須靠限制條件撐出不定大小）
        */
        //指定預估的儲存格高度
        self.tableView.estimatedRowHeight = 149
        //每一列的高度設為自動高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //====================================================
        //在導覽列右側增加一個編輯按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(btnEditAction))
        //在導覽列左側增加一個新增按鈕
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "新增", style: .plain, target: self, action: #selector(btnAddAction))
        //設定導覽標題
        self.navigationItem.title = "學生資料"
        //準備離線資料集
        arrTable = [
            ["no":"101","name":"王先生","gender":1,"picture":UIImage(named: "default.jpg"),"phone":"922333444","address":"宜蘭縣礁溪鄉健康路77號","email":"xdfd@yy.cc","class":"手機程式設計"],
            ["no":"102","name":"蔡小英","gender":0,"picture":UIImage(named: "default.jpg"),"phone":"922333444","address":"宜蘭縣礁溪鄉健康路77號","email":"xdfd@yy.cc","class":"網頁程式設計"],
            ["no":"103","name":"李大同","gender":1,"picture":UIImage(named: "default.jpg"),"phone":"922333444","address":"宜蘭縣礁溪鄉健康路77號宜蘭縣礁溪鄉健康路77號宜蘭縣礁溪鄉健康路77號","email":"xdfd@yy.cc","class":"智能裝置設計"],
            ["no":"104","name":"康大富","gender":0,"picture":UIImage(named: "default.jpg"),"phone":"922333444","address":"宜蘭縣礁溪鄉健康路77號","email":"xdfd@yy.cc","class":"網頁程式設計"],
            ["no":"105","name":"李登輝","gender":1,"picture":UIImage(named: "default.jpg"),"phone":"922333444","address":"宜蘭縣礁溪鄉健康路77號","email":"xdfd@yy.cc","class":"智能裝置設計"],
        ]
        
    }

    // MARK: 自定函式
    //由編輯按鈕呼叫
    func btnEditAction()
    {
        if tableView.isEditing  //如果表格在編輯中
        {
            tableView.isEditing = false
            navigationItem.rightBarButtonItem?.title = "編輯"
        }
        else
        {
            //讓表格進入編輯模式（注意：此行會阻擋滑動刪除的功能！但是儲存格交換一定要這行！）
            tableView.isEditing = true
            navigationItem.rightBarButtonItem?.title = "完成"
        }
    }
    //由新增按鈕呼叫
    func btnAddAction()
    {
        //從storyboard上取得畫面的執行實體
        let addVC = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        //顯示新增畫面
        show(addVC, sender: nil)
//        present(addVC, animated: true, completion: nil)   //此行指令不會出現導覽列
    }
    
    // MARK: Table view data source
    // 表格有幾個區段
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    // 表格每個區段有幾行資料
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrTable.count
    }

    //準備每一個儲存格的樣式
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //取得自訂儲存格（必須轉型）
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyTableViewCell
        cell.lblNo.text = arrTable[indexPath.row]["no"] as? String
        cell.lblName.text = arrTable[indexPath.row]["name"] as? String
        cell.lblAddress.text = arrTable[indexPath.row]["address"] as? String
        if arrTable[indexPath.row]["gender"] as! Int == 0
        {
            cell.lblGender.text = "女"
        }
        else
        {
            cell.lblGender.text = "男"
        }
        cell.imgPicture.image = arrTable[indexPath.row]["picture"] as? UIImage
        return cell
    }
    
    // MARK: Table View Delegate
    //使用者選定了特定儲存格時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("使用者選定：\(arrTable[indexPath.row])")
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //送出編輯狀態的事件（包括新增或刪除）
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            //Step1.先刪除對應陣列的元素
            arrTable.remove(at: indexPath.row)
            //Step2.實際刪除資料庫中的該筆資料
            //-----to do-----
            //Step3.刪除表格中的特定儲存格
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            print("刪除後陣列：\(arrTable)")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "不要了"
    }
    
    //=======以下處理儲存格的移動，兩個事件必須相互配合，儲存格才能移動=======
    //實際移動儲存格的事件
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        //----Step1.交換對應的陣列元素----
        //記憶目前觸碰之處所在的陣列元素
        let tmp = arrTable[sourceIndexPath.row]
        //移除目前觸碰之處所在的陣列元素
        arrTable.remove(at: sourceIndexPath.row)
        //重新將移除的陣列元素，安插到新的移動位置
        arrTable.insert(tmp, at: destinationIndexPath.row)
        
        print("移動後陣列：\(arrTable)")
    }
    
    //允許特定儲存格移動
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        //沒有判斷indexPath，所以所有的儲存格都可以移動
        return true
    }
    //=============================================================


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

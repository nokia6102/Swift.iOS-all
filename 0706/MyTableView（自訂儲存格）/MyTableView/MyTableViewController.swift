import UIKit

class MyTableViewController: UITableViewController
{
    //表格的資料來源陣列
    var arrList = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrList.append("爬山")
        arrList.append("滑雪")
        arrList.append("打球")
        arrList.append("游泳")
        arrList.append("玩遊戲")
        arrList.append("散步")
        
        //讓表格進入編輯模式（注意：此行會阻擋滑動刪除的功能！但是儲存格交換一定要這行！）
        tableView.isEditing = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: Table view data source
    //表格有幾個區段
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    //表格每一個區段有幾筆資料
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrList.count
    }
    
    //準備每一列的儲存格
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        //取出儲存格後，需轉型為自訂的MyTableViewCell類別
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
        /*
        cell.textLabel?.text = arrList[indexPath.row]
        //此行必須配合Cell的style屬性設為"Right Detail"
        cell.detailTextLabel?.text = "\(indexPath.row)"
        //變更儲存格的附屬樣式（程式碼優先於Storyboard的設定）
        cell.accessoryType = .detailButton
        */
        cell.label.text = arrList[indexPath.row]    //將顯示的資料存入自訂儲存格的屬性

        return cell
    }
    
    // MARK: Table View Delegate
    //使用者選定了特定儲存格時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("使用者選定：\(arrList[indexPath.row])")
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    //送出編輯狀態的事件（包括新增或刪除）
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            //Step1.先刪除對應陣列的元素
            arrList.remove(at: indexPath.row)
            //Step2.實際刪除資料庫中的該筆資料
            //-----to do-----
            //Step3.刪除表格中的特定儲存格
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            print("刪除後陣列：\(arrList)")
        }
        else if editingStyle == .insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            //當陣列資料靠程式碼變更時，呼叫此方法，可以重整TableView的資料
            tableView.reloadData()
        }    
    }

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "不要了"
    }

    /*
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath)
    {
     
    }
    */
    //=======以下處理儲存格的移動，兩個事件必須相互配合，儲存格才能移動=======
    //實際移動儲存格的事件
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        //記憶目前觸碰之處所在的陣列元素
        let tmp = arrList[sourceIndexPath.row]
        //移除目前觸碰之處所在的陣列元素
        arrList.remove(at: sourceIndexPath.row)
        //重新將移除的陣列元素，安插到新的移動位置
        arrList.insert(tmp, at: destinationIndexPath.row)
        
        print("移動後陣列：\(arrList)")
    }

    //允許特定儲存格移動
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        //沒有判斷indexPath，所以所有的儲存格都可以移動
        return true
    }
    //=============================================================
    //設定特定儲存格不可刪除
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
//    {
//        return .none
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

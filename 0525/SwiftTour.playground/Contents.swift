import UIKit

var str = "Hello, playground"

str = "test"

print(str)
//=======Simple Values(簡單值)=======
//使用let宣告常數，使用var宣告變數
var myVariable = 42     //使用型別推測
myVariable = 50
let myConstant = 42
//常數一開始可以不設值
let aConstant:Double
aConstant = 59.99   //常數一但在第一次設值之後，就不可以更動其值

let implicitInteger = 70    //推測成Int型別（32位元系統上，實際上是使用Int32，如果是64位元系統，實際上是使用Int64）
let implicitDouble = 70.0   //推測成Double型別
let explicitDouble:Double = 70  //明確指定型別為Double，不使用型別推測機制

//練習1：宣告一個常數，明確指定其型別為Float，初值設為4
let testContant:Float = 4.0

//Swift不會幫你自動轉型
let label = "The width is "
let width = 94
let widthLabel = label + String(width)

//練習2：試著移除最後一行的字串轉換，看看會有什麼錯誤

//使用\()語法可以值加入字串當中
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruit."

//練習3：計算某人的BMI值（《體重kg》除以《身高公尺》的平方）
let name = "Perkin"
let bodyWeight = 60.5
let bodyHeight = 1.68
String(format: "%.2f", bodyWeight/(bodyHeight*bodyHeight))
let bmiMessage = "\(name),你的BMI值是：\(String(format: "%.2f", bodyWeight/(bodyHeight*bodyHeight)))"

//使用中括號[]來宣告陣列或字典，最後的逗號可以保留
var shoppingList = ["catfish", "water", "tulips", "blue paint"]
shoppingList[1]
//更改陣列元素的值
shoppingList[1] = "bottle of water"
shoppingList
//-------------補充-------------
//在陣列的最後加上一筆資料
shoppingList.append("banna")
shoppingList
//在陣列的特定位置加上一筆資料
shoppingList.insert("new", at: 2)
shoppingList
//-----------------------------

//字典內的元素為key:value的配對
var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
]
//在字典內增加一筆新的查詢值（因為關鍵詞"Jayne"不存在原字典中）
occupations["Jayne"] = "Public Relations"

occupations

//當關鍵詞存在時，則修改字典內的值
occupations["Kaylee"] = "Engineer"

occupations

//---------<補充>陣列內存放字典---------
//宣告存放字典的陣列
var myData = [[String:String]]()

//準備第一本字典
let firstData = ["name":"Perkin","address":"新竹市光復路一段120號","age":"35"]

//將第一本字典加入陣列
myData.append(firstData)
myData

//第二本字典
let secondData = ["name":"Mary","address":"台北市林森北路一段300號","age":"25"]
myData.append(secondData)
myData
//--------------------------------

//使用初始化語法建立空陣列或空字典
var emptyArray = [String]()                 //原範例為let
var emptyDictionary = [String: Float]()     //原範例為let

//------------<補充>------------
//將資料加入空陣列
emptyArray = ["fdjfls","dfdfs"]
emptyArray.append("testdfdfd")

//將資料加入空字典
emptyDictionary = ["a":5,"b":3.5]
emptyDictionary["c"] = 6.9
//-----------------------------
shoppingList
shoppingList = []   //前方等號後的語法同此～[String]()
shoppingList

occupations = [:]   //前方等號後的語法同此～[String:String]()

//=======Control Flow(流程控制)=======
//使用if和switch來做狀況判斷，使用for-in、for、while、repeat-while來執行迴圈
let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
//用for-in迴圈列出陣列
for score in individualScores
{
    if score > 50   //狀況判斷的小括號可以省略，但body的大括號不能省略！
    {
        teamScore += 3      //teamScore = teamScore + 3
    }
    else
    {
        teamScore += 1
    }
}
print(teamScore)

//使用問號（?）來標記選擇性變數
var optionalString:String? = "Hello"
//使用驚嘆號（！）將選擇性變數拆封（unwrap）使用
print(optionalString!)  //選擇性變數拆封時，必須確保有內含物（不是nil的狀態）
//檢查選擇性變數是否為nil
print(optionalString == nil)


var optionalName: String? = "John Appleseed"    //練習4：清空成nil的方式1~宣告後不設定初值，即為nil
optionalName = nil                              //練習4：清空成nil的方式2
var greeting = "Hello!"
//使用選擇性綁定（optional binding）語法來判斷選擇值是否存在
if let name = optionalName  //如果綁定成功，表示選擇值存在，才會進入if區段執行
{
    greeting = "Hello, \(name)" //選擇性綁定語法測試成功，變數自動拆封
}
else        //練習4：加上else區段
{
    greeting = "Hi"
}

//使用??運算符號為選擇值提供預設值
var nickName: String? = nil                 //原範例為let
nickName = "測試"
let fullName: String = "John Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)"     //nickName != nil ? nickName!:fullName

//Swift的switch語法可以檢測任意型別，不限於只能檢測整數
let vegetable = "red pepper"
//-----<補充>字串的檢測-----
vegetable.hasPrefix("red")  //檢測以～開頭的字串
vegetable.hasSuffix("a")    //檢測以～結尾的字串
vegetable.contains("pp")    //檢測是否包含～字串
//-----------------------

switch vegetable
{
    case "celery":
        print("Add some raisins and make ants on a log.")
    case "cucumber", "watercress":
        print("That would make a good tea sandwich.")
    case let x where x.hasSuffix("pepper"):
        print("Is it a spicy \(x)?")
    default:        //當上面的case無法涵蓋所有檢測狀況時，必須提供default分支     //練習5：取消default，觀察錯誤訊息
        print("Everything tastes good in soup.")
}

//可以利用for-in迴圈來列出字典的key-value配對值
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],      //質數
    "Fibonacci": [1, 1, 2, 3, 5, 8],    //費式數列
    "Square": [1, 4, 9, 16, 25],        //平方
]
var largest = 0
//外迴圈列出字典的key-value配對
for (kind, numbers) in interestingNumbers
{
    //內迴圈列出該筆查詢值的陣列元素
    for number in numbers       //列出每一筆查詢值的陣列
    {
        if number > largest
        {
            largest = number
        }
    }
}
print(largest)

//練習6：在上面程式段中，加入另一個變數來追蹤最大的數字會出現在哪一類
largest = 0     //歸零
var largestKind = ""        //新增最大類別的追蹤
//外迴圈列出字典的key-value配對
for (kind, numbers) in interestingNumbers
{
    //內迴圈列出該筆查詢值的陣列元素
    for number in numbers       //列出每一筆查詢值的陣列
    {
        if number > largest
        {
            largest = number
            largestKind = kind      //新增紀錄最大數的類別所在
        }
    }
}
print("最大數：\(largest)在\(largestKind)")

//while迴圈，先檢測條件，再決定是否執行迴圈
var n = 2
while n < 100       //其實是可以多次檢測條件的if迴圈
{
    n *= 2
}
print(n)

//repeat-while迴圈是先執行一次，再檢測條件
var m = 2
repeat
{
    m *= 2
} while m < 100
print(m)

//可以使用..<來做成迴圈的區間索引範圍（..<不含上標，...包含上標）
var total = 0
for i in 0..<4
{
    total += i
}
print(total)

//使用倒轉區間來執行迴圈
total = 0
for i in (0..<4).reversed()
{
    total += i
}
print(total)

//迴圈正轉，但每次加2（不含上標）
total = 0
for i in stride(from: 0, to: 10, by: 2)
{
    total += i
}
print(total)

//迴圈正轉，但每次加2（包含上標）
total = 0
for i in stride(from: 0, through: 10, by: 2)
{
    total += i
}
print(total)

//迴圈反轉，但每次減2（不含上標）
total = 0
for i in stride(from: 10, to: 0, by: -2)
{
    total += i
}
print(total)

//迴圈反轉，但每次減2（包含上標）
total = 0
for i in stride(from: 10, through: 0, by: -2)
{
    total += i
}
print(total)



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

//=============函式和閉包（Functions and Closures）=============
//使用func宣告函式，函式名稱之後的小括號內可以一系列參數，使用->來標示函示的回傳型別
//定義函式
func greet(person: String, day: String) -> String
{
    return "Hello \(person), today is \(day)."
}
//執行函式
var message = greet(person: "Bob", day: "Tuesday")
message

//練習7：移除day參數，增加一個參數來包含今日午間特餐，然後顯示問候語
func greet(person: String, lunch: String) -> String
{
    return "Hello \(person), today' lunch special is \(lunch)."
}
greet(person: "Perkin", lunch: "排骨飯")

//預設情況下，函式使用他們參數名稱來作為實際引數的標籤。在參數名稱前可以自定實際的引數標籤，或使用_來避免使用引數標籤
func greet(_ person: String, on day: String) -> String
{
    return "Hello \(person), today is \(day)."
}
greet("John", on: "Wednesday")

//------<補充>元組（Tuples-The Basics）------
//元組可以將數個值，組合成一個複合值，而且值彼此之間可以是任意型別，且不相關
let http404Error = (404, "Not Found")
//為元組的元素命名
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
print("The status message is \(statusMessage)")
//當你不關其中某些元組的元素時，可以使用_不為它命名
let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")
//當你不需要為元組的元素命名時，也可以使用索引值來取出元組中元素的值（索引值是從0起算）
print("The status code is \(http404Error.0)")
print("The status message is \(http404Error.1)")
//也可以在宣告元組的實體時，就直接命名每一個元素
var http200Status = (statusCode: 200, description: "OK")        //原範例為let
print("The status code is \(http200Status.statusCode)")
print("The status message is \(http200Status.description)")

//元組的型別為單一元素型別的組合，不需考慮參數名稱
http200Status = http404Error
http200Status
//---------------------------------------------------------
//元組可以用在函式的回傳值
func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int)
{
    var min1 = scores[0]    //min1、max1、sum1在原範例沒有1
    var max1 = scores[0]
    var sum1 = 0
    
    for score in scores
    {
        if score > max1
        {
            max1 = score
        }
        else if score < min1
        {
            min1 = score
        }
        sum1 += score
    }
    
    return (min1, max1, sum1)
}
let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
statistics.min
statistics.max
print(statistics.sum)
print(statistics.2)

//韓式的單一參數，可以接受多個引數，但該引數將自動形成陣列（同一函式中，多引數的參數只限用一次！）
func sumOf(numbers: Int...) -> Int
{
    var sum = 0
    for number in numbers
    {
        sum += number
    }
    return sum
}
sumOf()
sumOf(numbers: 42, 597, 12)

//練習8：寫一個函式包含一個多引數的參數，並且回傳其平均值
func AverageOf(numbers: Int...) -> Float
{
    var sum = 0
    for number in numbers
    {
        sum += number
    }
    return Float(sum) / Float(numbers.count)
}
let result = AverageOf(numbers: 4,5,7)
String(format: "%.2f", result)

//定義巢狀函式
func returnFifteen() -> Int
{
    var y = 10
    //定義巢狀函式
    func add()      //函式可以是巢狀的（被包裹在另外一個函式之中），用於包裝較長或較複雜的邏輯運作
    {
        y += 5      //巢狀函式可以存取其宣告範圍的外部變數
    }
    //執行巢狀函式
    add()
    return y
}
//執行外部函式
returnFifteen()

//函式是一級型別（等同於一種型別），所以函式可以當作函式的回傳值
func makeIncrementer() -> ((Int) -> Int)
{
    //巢狀函式定義複雜邏輯
    func addOne(number: Int) -> Int
    {
        return 1 + number
    }
    return addOne
}
//執行外部函式，另外拿到一個內部的巢狀函式
var increment = makeIncrementer()
//執行函式
increment(7)

//函式也可以接收別的函式當作引數傳入
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool
{
    //將第一個引數的陣列列出，並且逐一代入第二個引數的函式中執行
    for item in list
    {
        if condition(item)  //把每次的陣列元素當作引數，傳入condition函式中執行
        {
            return true
        }
    }
    return false
}
//定義一個函式來準備要傳『第二個引數』的邏輯
func lessThanTen(number: Int) -> Bool
{
    return number < 10
}
//準備『第一個引數』
var numbers = [20, 19, 7, 12]
//呼叫函式，傳入『第一個引數』和『第二個引數』 PS.第二個參數是命名函式
hasAnyMatches(list: numbers, condition: lessThanTen)
//<補充1>以閉包的方式呼叫（展開成尾隨閉包）    PS.第二個參數是匿名閉包
hasAnyMatches(list: numbers) { (num) -> Bool in
    return num < 10
}
//<補充2>以閉包的方式呼叫(不建議使用，因為格式容易打錯)
hasAnyMatches(list: numbers, condition: {(num)->Bool in return num < 10})

//閉包是沒有名稱的匿名函式，所以必須將參數、回傳值和實作包在{}裡面，但是以in來區隔實作
numbers.map { (number) -> String in
    return "hello!\(number)"
}

numbers.map({ (number: Int) -> Int in
    let result = 3 * number
    return result
})

//練習9：重寫map方法內的閉包，把陣列內所有的奇數換成零
let newArray =
numbers.map { (num) -> Int in
    if num % 2 != 0 //不會被二整除的數為奇數
    {
        return 0
    }
//    else
//    {
        return num
//    }
}

newArray

//閉包省略了參數的括號和型別的宣告（因為型別已知）（不建議！）
let mappedNumbers = numbers.map({ number in 3 * number })
print(mappedNumbers)

//一般的陣列排序方法使用方式，為閉包中的每一個參數命名
numbers.sorted { (first, second) -> Bool in
    return first < second
}

//簡化寫法，不為參數命名，直接以索引值存取參數，省略in，直接撰寫實作（不建議！）
let sortedNumbers = numbers.sorted { $0 < $1 }
print(sortedNumbers)

//==============物件與類別（Objects and Classes）==============

class Shape            //沒有繼承自任何類別的類別，稱為基礎類別
{
    //幾個面
    var numberOfSides = 0                   //以變數或常數的形式來宣告屬性（property）
    let dimension = "3D"                    //練習10：加一個常數屬性
    func simpleDescription() -> String      //函式宣告在類別中，稱為方法（method）
    {
        return "A shape with \(numberOfSides) sides."
    }
    //練習10:加一個帶有參數的方法
    func shapWithHeight(height:Int) -> String
    {
        return "這是\(dimension)模型，高度：\(height)"
    }
}
//呼叫類別的"預設"初始化方法，來產生類別的實體（instance/object）
var shape = Shape()
shape.dimension
shape.numberOfSides = 7     //更改面數
var shapeDescription = shape.simpleDescription()

//PS.當類別中所有的屬性，都有預設值時（選擇性屬性可以為nil），會自動配置一個"預設"初始化方法

//自訂類別的初始化方法
class NamedShape
{
    var numberOfSides: Int = 0  //幾邊
    var name: String            //名稱
    
    init(name: String)
    {
        self.name = name    //參數名稱與屬性名稱相同時，屬性名稱前方必須加上self.以區隔參數
    }
    
    init()
    {
        name = "未知形狀"
    }
    //反初始化方法，在物件從記憶體移除前會被呼叫
    deinit
    {
        print("NamedShape被釋放！")
    }
    
    func simpleDescription() -> String
    {
        return "A shape with \(numberOfSides) sides."
    }
}
//呼叫自訂的初始化方法
var square:NamedShape! = NamedShape(name: "正方形")
square.name
square.numberOfSides
square.simpleDescription()
square = nil

let unknownShap = NamedShape()
unknownShap.name


class Square: NamedShape
{
    var sideLength: Double      //邊長
    //初始化方法的兩個參數，第一個是初始化本身的屬性，第二個是初始化父類別（supper class）的屬性
    init(sideLength: Double, name: String)
    {
        self.sideLength = sideLength        //Step1.初始化本身的屬性值
        super.init(name: name)              //Step2.呼叫父類別的初始化方法，以設定父類別的屬性初值
        numberOfSides = 4                   //Step3.近一步更改已經有初值的屬性值
    }
    //計算正方形面積
    func area() -> Double
    {
        return sideLength * sideLength
    }
    
    override func simpleDescription() -> String
    {
        return "A square with sides of length \(sideLength)."
    }
    
}

let test = Square(sideLength: 5.2, name: "my test square")
test.area()
test.simpleDescription()

//練習11：建立一個NameShape的子類別，叫做Circle，必須有一個初始化方法包含半徑radius和名稱name，加上一個計算圓面積的方法area，以及覆寫simpleDescription方法
class Circle:NamedShape
{
    var radius:Double
    
    init(radius:Double,name:String)
    {
        self.radius = radius        //Step1
        super.init(name: name)      //Step2（Step3省略）
    }
    //計算圓面積
    func area() -> Double
    {
        return radius * radius * Double.pi
    }
    
    override func simpleDescription() -> String
    {
        return "圓形：\(name)的半徑為\(radius)，面積為\(area())"
    }
}
let aCircle = Circle(radius: 4.9, name: "大餅")
aCircle.simpleDescription()
aCircle.area()

//<補充>指定初始化方法（Designated Initializers）與便利初始化方法（Convenience Initializers）
class Food
{
    var name: String
    init(name: String)
    {
        self.name = name
    }
    
//    init()
//    {
//        self.name = ""
//    }
    
    convenience init()
    {
        self.init(name: "[Unnamed]")
    }
}

//屬性除了簡單的儲存屬性（stored property）以外，還有計算屬性（computed property）可以提供setter（設值）和getter（取值）
class EquilateralTriangle: NamedShape
{
    var sideLength: Double = 0.0    //邊長的"儲存屬性"
    
    init(sideLength: Double, name: String)
    {
        self.sideLength = sideLength    //邊長
        super.init(name: name)
        numberOfSides = 3       //3邊
    }
    
    var perimeter: Double          //總長度的"計算屬性"
    {
        get     //取值
        {
            return 3.0 * sideLength
        }
    
        //如果不提供以下的set段，此"計算屬性"就成為唯讀的"計算屬性"
        set     //設值(使用預設名稱newValue)
        {
            //當總長度被更動時，必須回算出單邊長度
            sideLength = newValue / 3.0
        }
        
//        set(nv)     //設值(不使用預設名稱)
//        {
//            //當總長度被更動時，必須回算出單邊長度
//            sideLength = nv / 3.0
//        }
        
    }
    
    //<補充練習>請使用唯讀"計算屬性"計算三角形的面積
    //使用海龍公式來計算三角形的面積 http://ms1.hcvs.kh.edu.tw/hc3331/pbook/scr/work-4/page14.htm
    //開根號函式sqrt()
    
    override func simpleDescription() -> String
    {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.sideLength)
print(triangle.perimeter)   //取值
//triangle.perimeter = 9.9//設值
print(triangle.sideLength)


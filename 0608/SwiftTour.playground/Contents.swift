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
    var area:Double
    {
        get
        {
            let s = sideLength * 3 / 2
            let K = s*(s-sideLength)*(s-sideLength)*(s-sideLength)
            return sqrt(K)
        }
    }
    
    override func simpleDescription() -> String
    {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.sideLength)
print(triangle.perimeter)   //取值
triangle.perimeter = 9.9    //設值
print(triangle.sideLength)
triangle.area

//如果你不需要計算屬性值，但仍需要在設定新值的前後執行一些代碼時，使用willSet和didSet
class TriangleAndSquare         //『三角形與正方形類別』在確保三角形和正方形的邊長相同
{
    var triangle: EquilateralTriangle       //等邊三角形類別實體的屬性
    {
        willSet
        {
            square.sideLength = newValue.sideLength
        }
//        didSet
//        {
//            
//        }
    }
    var square: Square                      //正方形類別實體的屬性
    {
        willSet
        {
            triangle.sideLength = newValue.sideLength
        }
    }
    init(size: Double, name: String)        //size：指三角形或正方形的邊長
    {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
    deinit      //反初始化方法
    {
        print("三角形與正方形類別被釋放")
    }
}
//初始化『三角形與正方形類別』
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
print(triangleAndSquare.triangle.sideLength)
//變更『三角形與正方形類別』實體的正方形屬性，改設邊長為50
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.triangle.sideLength)    //三角形屬性的邊長也跟著改變（因為會觸發willSet）

//<補充>以下會造成三角形和正方形的邊長不一致
triangleAndSquare.square.sideLength = 30    //因為直接設定屬性下的子屬性，並不會觸發屬性的willSet
triangleAndSquare.triangle.sideLength

//選擇性變數配合類別實體使用
let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength     //Optional Chaining（選擇性串連）

//強制（預先）拆封的選擇性變數
let optionalSquare2: Square! = Square(sideLength: 3.5, name: "optional square2")
let sideLength2 = optionalSquare2.sideLength     //存取其中的屬性時，不必加上?，但是如果變數為nil，程式會當掉！

//<補充>Optional Chaining（選擇性串連）後的屬性值，不論其本質是否為選擇性，最終都變成選擇性！
var optionalTriangleAndSquare:TriangleAndSquare? = TriangleAndSquare(size: 5, name: "新三角形與正方形")
var aSideLength = optionalTriangleAndSquare?.square.sideLength

//<補充>Optional Chaining（選擇性串連）配合Optional Binding（選擇性綁定）使用，可以防止程式當掉！
optionalTriangleAndSquare = nil
if let length = optionalTriangleAndSquare?.square.sideLength    //檢測選擇性串連是否有值可以綁定到let常數
{
    print("邊長：\(length)")
}
else
{
    print("沒有邊長")
}

//=======列舉和結構（Enumerations and Structures）=======
//使用enum關鍵字宣告列舉，它跟類別和其他的命名型別一樣，可以定義方法
//撲克牌的數字列舉
enum Rank: Int      //帶原始值的列舉，才可使用rawValue屬性
{
    case ace=1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    
    func simpleDescription() -> String
    {
        switch self     //檢測列舉所產生的實體（實體指的是列舉中的其中一個case）
        {
            case .ace:
                return "ace"
            case .jack:
                return "jack"
            case .queen:
                return "queen"
            case .king:
                return "king"
            default:
                return String(self.rawValue)
        }
    }
}
let ace = Rank.ace  //以列舉中的其中一個case來產生列舉的實體
let aceRawValue = ace.rawValue

//<補充>呼叫列舉的方法
var aRank = Rank.five
aRank.simpleDescription()
aRank = Rank.queen
aRank.simpleDescription()

//練習12：寫一個函式透過比對它們的原始值，來比對兩個Rank的值
func compare(rank1:Rank,rank2:Rank) -> String
{
    if rank1.rawValue > rank2.rawValue
    {
        return "rank1大於rank2"
    }
    else if rank1.rawValue < rank2.rawValue
    {
        return "rank1小於rank2"
    }
    else    //原始時相等時
    {
        return "rank1和rank2相等"
    }
}

var r1 = Rank.ace
var r2 = Rank.nine
compare(rank1: r1, rank2: r2)

//<補充>不帶原始值的列舉，沒有rawValue屬性
enum CompassPoint
{
    case north
    case south
    case east
    case west
}
let aCP = CompassPoint.north

//如果列舉有帶原始值
enum CompassPoint2:Int
{
    case north
    case south
    case east
    case west
}
let bCP = CompassPoint2.north
bCP.rawValue

//當列舉帶原始值時，會自動拿到一個帶rawValue參數的初始化方法（為一個可失敗的初始化方法，失敗時會回傳nil）
if let cCP = CompassPoint2(rawValue: 3)
{
    cCP.rawValue
}

//如果列舉所帶的原始值為String型別，預設使用和case相同的字串
enum CompassPoint3:String
{
    case north = "N"        //可以另外使用等號來改變預設的字串
    case south = "S"
    case east
    case west
}
let dCP = CompassPoint3.east
dCP.rawValue

//使用列舉init?初始化方法
if let convertedRank = Rank(rawValue: 3)
{
    let threeDescription = convertedRank.simpleDescription()
}

//撲克牌的花色列舉
enum Suit:Int           //原範例沒有原始值Int，此為練習14所添加
{
    case spades, hearts, diamonds, clubs
    func simpleDescription() -> String
    {
        switch self
        {
            case .spades:
                return "♤"      //黑色
            case .hearts:
                return "♡"      //紅色
            case .diamonds:
                return "♢"      //紅色
            case .clubs:
                return "♧"      //黑色
        }
    }
    //練習13增加
    func color() -> String
    {
        switch self
        {
            case .spades,.clubs:
                return "黑色"
            default:
                return "紅色"
        }
    }
    //<補充>列舉也可以有屬性，但僅限『計算屬性』，不能使用『儲存屬性』
    var i:Int
    {
        return 1
    }
    
}
let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()

//練習13：增加一個color方法到Suit列舉，當spades和clubs時，回傳黑色，其他回傳紅色
hearts.color()  //測試color方法
hearts.i        //測試列舉的計算屬性

//列舉也可以使用關聯值（associated value），配合Tuple的形式
enum ServerResponse
{
    case result(String, String)
    case failure(String)
}
//關聯值在產生列舉實體時才給值
let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")

switch success
{
    case let .result(sunrise, sunset):
        print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
    case let .failure(message):
        print("Failure...  \(message)")
}

//以struct關鍵字建立結構。結構提供很多類似類別的行為，包括一般方法和初始化方法。其中最重要的是：結構會在傳遞的時候拷貝其值，而類別則是傳遞引用。
struct Card     //撲克牌結構
{
    //以屬性的方式來定義結構的成員
    var rank: Rank
    var suit: Suit
    //實體方法：不帶static關鍵字，只能由型別實體呼叫
    func simpleDescription() -> String
    {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
    //練習14：列出整副撲克牌的方法
    //型別方法：帶有static關鍵字，只能由型別呼叫
    static func fullDeckOfCards() -> [Card]
    {
        var cards = [Card]()
        //外迴圈跑花色
        for i in Suit.spades.rawValue...Suit.clubs.rawValue
        {
            //內迴圈跑牌數
            for j in Rank.ace.rawValue...Rank.king.rawValue
            {
                //逐一產生單一張撲克牌結構
                let card = Card(rank: Rank(rawValue: j)!, suit: Suit(rawValue: i)!)
                //將每張牌加入陣列
                cards.append(card)
            }
        }
        //回傳52張牌的結構陣列
        return cards
    }
}
var threeOfSpades = Card(rank: .three, suit: .spades)           //原範例為let
let threeOfSpadesDescription = threeOfSpades.simpleDescription()
//結構會在傳遞的時候拷貝其值
let testCard = threeOfSpades        //此處的動作為抄錄，而非引用！
testCard.simpleDescription()

threeOfSpades = Card(rank: .five, suit: .diamonds)  //變更原值
threeOfSpades.simpleDescription()                   //查看原值
testCard.simpleDescription()                        //新值不動

//練習14：替Card結構增加一個方法來建立一整副撲克牌，每張牌需對應rank和suit
Card.fullDeckOfCards()      //呼叫型別方法

//----<補充>以下摘自Classes and Structures章節----
//值型別（Value Type） Vs. 引用型別（Reference Type）
//『結構』和『列舉』是值型別（Value Type），所有Swift標準函式庫的基礎類別（如：Int、Double、Dictionary、Array）都是結構！
//『類別』是引用型別（Reference Type），涉及到記憶體的引用計數（Reference Counting）之釋放
struct Resolution   //解析度結構
{
    //當所有結構成員都有初始值時，會自動產生一個不帶參數的初始化函式
    var width = 0
    var height = 0
}

class VideoMode     //影像模式類別
{
    var resolution = Resolution()   //解析度結構屬性
    var interlaced = false          //交錯掃描
    var frameRate = 0.0             //影像頻率
    var name: String?               //模式名稱
    
    deinit      //補充反初始化方法
    {
        print("VideoMode實體被釋放")
    }
    
}

let someResolution = Resolution()
let someVideoMode = VideoMode()

print("The width of someResolution is \(someResolution.width)")

print("The width of someVideoMode is \(someVideoMode.resolution.width)")

//以點語法指派屬性值
someVideoMode.resolution.width = 1280   //Swift可以直接更動結構的副屬性（即單一的結構成員）
print("The width of someVideoMode is now \(someVideoMode.resolution.width)")

let vga = Resolution(width: 640, height: 480)

let hd = Resolution(width: 1920, height: 1080)
var cinema = hd     //結構值的抄錄，會產生兩個不相干的結構
cinema
cinema.width = 2048
print("cinema is now \(cinema.width) pixels wide")

print("hd is still \(hd.width) pixels wide")

//相同的抄錄行為也適用於列舉
enum CompassPoint4
{
    case north, south, east, west
}
var currentDirection = CompassPoint4.west
let rememberedDirection = currentDirection  //列舉的抄錄
currentDirection = .east
if rememberedDirection == .west
{
    print("The remembered direction is still .west")
}

//『類別』是引用型別（Reference Type）
var tenEighty:VideoMode! = VideoMode()      //此處調整為var和Optional，此時引用計數為1
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

//此處為類別實體『記憶體位置』的引用
var alsoTenEighty:VideoMode! = tenEighty     //此處調整為var和Optional，此時引用計數為2
alsoTenEighty.frameRate = 30.0  //針對第二個類別實體變數變更屬性時

//原先的第一個類別實體也跟著改變
print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")

tenEighty = nil         //引用計數降為1
alsoTenEighty = nil     //引用計數降為0，此時觸發ARC機制，釋放已經配置的記憶體空間

//變數中的類別實體，是否參考到相同記憶體位置，可以使用===（相等）或!==（不相等）這兩種運算符號進行比對
if tenEighty === alsoTenEighty
{
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}

//======協定和擴展（Protocols and Extensions）======
//協定是定義一份工作清單，沒有實作
protocol ExampleProtocol
{
    var simpleDescription: String { get }       //至少是唯讀屬性
    mutating func adjust()  //mutating關鍵字是值型別執行此方法時，可以改變自身實體的屬性
}

//類別、列舉和結構都可以採納協定
//類別採納協定
class SimpleClass: ExampleProtocol    //類別若需繼承，必須放在冒號後第一位，以逗點區隔，其餘的皆為協定
{
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    func adjust()
    {
        simpleDescription += "  Now 100% adjusted."
    }
}
var a = SimpleClass()
a.simpleDescription
a.adjust()
let aDescription = a.simpleDescription

//結構採納協定
struct SimpleStructure: ExampleProtocol
{
    var simpleDescription: String = "A simple structure"
    mutating func adjust()  //方法必須加上mutating關鍵字，才能變動值型別的實體屬性值！
    {
        simpleDescription += " (adjusted)"
    }
}
var b = SimpleStructure()
b.simpleDescription
b.adjust()
let bDescription = b.simpleDescription

//練習15：
enum SimpleEnum:ExampleProtocol
{
    case One,Two,Three
    case OneAdjusted,TwoAdjusted,ThreeAdjusted
    var simpleDescription: String   //以唯讀計算屬性實作協定屬性
    {
        switch self
        {
            case .One:
                return "<一>"
            case .Two:
                return "<二>"
            case .Three:
                return "<三>"
                
            case .OneAdjusted:
                return "<一>+"
            case .TwoAdjusted:
                return "<二>+"
            case .ThreeAdjusted:
                return "<三>+"
        }
    }
    
    mutating func adjust()  //方法必須加上mutating關鍵字，才能變動值型別的實體屬性值！
    {
        switch self
        {
            //為調整的列舉，改成調整過後的列舉
            case .One:
                self = .OneAdjusted
            case .Two:
                self = .TwoAdjusted
            case .Three:
                self = .ThreeAdjusted
            //已經是調整過後的列舉時，則不進行動作
            default:
                break
        }
    }
}
//測試調整前的列舉實體，並執行調整方法
var c = SimpleEnum.Two
c.simpleDescription
c.adjust()          //結果會被調整
c.simpleDescription
//測試調整後的列舉實體，並執行調整方法
c = .ThreeAdjusted
c.simpleDescription
c.adjust()          //結果不會調整
c.simpleDescription

//使用extension來替『既有型別』增加功能，譬如新的方法或計算屬性，還有遵循某些協定。（Objective-C稱為Category）
extension Int: ExampleProtocol
{
    var simpleDescription: String
    {
        return "The number \(self)"
    }
    mutating func adjust()
    {
        self += 42  //把原來的值加上42
    }
}

print(7.simpleDescription)  //此處的7視為常數，無法執行adjust方法

var aInt = 5
aInt.simpleDescription
aInt.adjust()           //調整方法只能由變數執行
aInt.simpleDescription

//練習16：替Double型別擴展一個功能，增加absoluteValue屬性（取絕對值）
extension Double
{
    var absoluteValue:Double
    {
//        if self < 0
//        {
//            return -self
//        }
//        else
//        {
//            return self
//        }
        return abs(self)
    }
}

(-3.14).absoluteValue
let aDouble = -5.99
aDouble.absoluteValue

//協定視為一種型別，與其他的命名型別相同
let protocolValue: ExampleProtocol = a  //宣告一個protocolValue常數為任何採納過ExampleProtocol協定的實體
print(protocolValue.simpleDescription)
//以protocolValue的角度，只能看到協定方法和協定屬性，不能看到原始實體的其他方法或屬性
// print(protocolValue.anotherProperty)  // Uncomment to see the error

//========錯誤處理（Error Handling）========
//採納Error協定來定義錯誤訊息
enum PrinterError: Error    //印表機會產生的錯誤，以列舉來定義，同時採納Error協定
{
    case outOfPaper     //沒紙
    case noToner        //沒有碳粉
    case onFire         //壞掉
}

//以throw關鍵字讓函式在特定時點拋出錯誤
func send(job: Int, toPrinter printerName: String) throws -> String //throws表示函式會拋出錯誤，標示於回傳符號之前
{
    if printerName == "Never Has Toner"
    {
        throw PrinterError.noToner
    }
    //-----練習18增加拋出其他錯誤------
    else if printerName == "On Fire"
    {
        throw PrinterError.onFire
    }
    else if printerName == "Out Of Paper"
    {
        throw PrinterError.outOfPaper
    }
    //-----------------------------
    return "Job sent"
}

do
{
    let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
    print(printerResponse)
}
catch       //捕捉錯誤
{
    print(error)
}

//練習17：呼叫send函式，傳遞"Never Has Toner"字串給第二個參數
do
{
    try send(job: 999, toPrinter: "Never Has Toner")
}
catch
{
    print(error)
    print(error.localizedDescription)
    print("函式呼叫失敗")
}

//用多個catch區段來處理特定的錯誤
do
{
    let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
    print(printerResponse)
}
catch PrinterError.onFire               //捕捉PrinterError的特定錯誤
{
    print("I'll just put this over here, with the rest of the fire.")
}
catch let printerError as PrinterError  //捕捉PrinterError的其他錯誤
{
    print("Printer error: \(printerError).")
}
catch       //捕捉與PrinterError無關的其他error
{
    print(error)
}

//練習18：在do區段讓函式拋出錯誤，讓第一段的catch捕捉到錯誤。還有讓第二段和第三段也可以捕捉到錯誤。
do
{
    let printerResponse = try send(job: 888, toPrinter: "Out Of Paper")
    print(printerResponse)
    //以下若接著處理其他函式呼叫，而產生其他錯誤，才會進入最後的catch
    //----to do----
}
catch PrinterError.onFire               //捕捉PrinterError的特定錯誤
{
    print("I'll just put this over here, with the rest of the fire.")
}
catch let printerError as PrinterError  //捕捉PrinterError的其他錯誤
{
    print("Printer error: \(printerError).")
}
catch       //捕捉與PrinterError無關的其他error
{
    print(error)
}

//使用try?將函式的處理結果轉換成選擇值，如果函式呼叫失敗，會回傳nil
let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")

//以選擇性串連配合選擇性綁定，測試函式是否呼叫成功
if let printerSuccess = try? send(job: 1884, toPrinter: "Never Has Toner")
{
    print("函式呼叫成功")
}
else
{
    print("函式呼叫失敗")
}

//使用defer語法來撰寫程式區段，此段指令會在函式中所有程式碼執行完畢之後被執行，且是在函式回傳之前，或是拋出錯誤之前。此處可以撰寫最後的清理程式。
var fridgeIsOpen = false    //預設冰箱門關閉
let fridgeContent = ["milk", "eggs", "leftovers"]   //冰箱的內容物
//檢測冰箱中是否包含特定食物
func fridgeContains(_ food: String) -> Bool
{
    //打開冰箱門
    fridgeIsOpen = true
    //此defer段不論撰寫於函式任何地方，只會在函式返回時被執行
    defer
    {
        //收尾動作：把冰箱門關起來
        fridgeIsOpen = false
    }
    
    let result = fridgeContent.contains(food)
    return result
}
fridgeContains("banana")
print(fridgeIsOpen)
fridgeIsOpen    //檢查冰箱門是否再度被關上

//=======泛用型別、泛型（Generics）=======
//在函式中使用泛用型別，<Item>中的Item為代換符號（placeholder）
func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item]
{
    var result = [Item]()
    for _ in 0..<numberOfTimes
    {
        result.append(item)
    }
    return result
}

let myNumArray = makeArray(repeating: 77.88, numberOfTimes: 10)
myNumArray[1] + 30
makeArray(repeating: "knock", numberOfTimes: 4)

//<補充>不使用泛型時，相同邏輯、不同型別，必須撰寫兩種函式
func makeArray1(repeating item: Int, numberOfTimes: Int) -> [Int]
{
    var result = [Int]()
    for _ in 0..<numberOfTimes
    {
        result.append(item)
    }
    return result
}
func makeArray2(repeating item: Double, numberOfTimes: Int) -> [Double]
{
    var result = [Double]()
    for _ in 0..<numberOfTimes
    {
        result.append(item)
    }
    return result
}
makeArray1(repeating: 345, numberOfTimes: 4)

makeArray2(repeating: 2.3, numberOfTimes: 4)

//使用任意型別，必須做精確轉型，才能進行運算或後續的應用
func makeArray3(repeating item: Any, numberOfTimes: Int) -> [Any]
{
    var result = [Any]()
    for _ in 0..<numberOfTimes
    {
        result.append(item)
    }
    return result
}

let myArray = makeArray3(repeating: "abc", numberOfTimes: 5)
(myArray[1] as! String) + "def"     //取出的Any型別，必須轉型後才能使用

//泛型可用於類別、結構或列舉內的方法，或是函式之中
enum OptionalValue<Wrapped>
{
    case none
    case some(Wrapped)
}
var possibleInteger: OptionalValue<Int> = .none
possibleInteger = .some(100)

//利用where條件式，限定泛型的條件
func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
    where T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element
    //T的內含元素的型別必須實作過Equatable協定，且『T的內含元素的型別』要和『U的內含元素的型別』一致
{
        for lhsItem in lhs
        {
            for rhsItem in rhs
            {
                if lhsItem == rhsItem
                {
                    return true
                }
            }
        }
        return false
}
anyCommonElements([1, 2, 3], [3])

//練習19：修改上面的函式，將比對到相同的結果組成陣列回傳
func anyCommonElements2<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Array<T.Iterator.Element>
    where T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element
    //T的內含元素的型別必須實作過Equatable協定，且『T的內含元素的型別』要和『U的內含元素的型別』一致
{
    //初始化泛型的空陣列
    var myArray = Array<T.Iterator.Element>()
    
    for lhsItem in lhs
    {
        for rhsItem in rhs
        {
            if lhsItem == rhsItem
            {
                myArray.append(lhsItem)
            }
        }
    }
    return myArray
}
anyCommonElements2(["abc","def","hij","klm"], ["abc","hij","opq"])

//待測試  此處有Bug，無法順利使用==
//func anyCommonElements3<T:Equatable, U:Equatable>(_ lhs: [T], _ rhs: [U]) -> [T]
//{
//    //初始化泛型的空陣列
//    var myArray = [T]()
//    
//    for lhsItem in lhs
//    {
//        for rhsItem in rhs
//        {
//            if lhsItem == rhsItem
//            {
//                myArray.append(lhsItem)
//            }
//        }
//    }
//    return myArray
//}






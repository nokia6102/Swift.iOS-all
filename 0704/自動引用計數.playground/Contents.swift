import UIKit

/*
 Swift使用『自動引用計數』（Automatic Reference Counting - ARC）來追蹤管理"應用程式"的記憶體。
 通常情況下，Swift的記憶體管理機制會一直起著作用，你無須自己來考慮記憶體的管理。
 ARC會在『類別實體』不再被使用時，自動釋放其佔用的記憶體。
 然而，在少數情況下，ARC為了能幫助你管理記憶體，需要更多的關於你的程式碼之間關係的資訊。
 本章描述了這些情況，並且示範怎樣啟用ARC來管理"應用程式"的記憶體。
 
 注意:
 『引用計數』（Reference counting）僅僅應用於『類別實體』。
 『結構』和『列舉』是"值型別"（value types），不是"引用型別"（reference types），並非透過引用的方式儲存和傳遞。
 */

//============『自動引用計數』的作用機制（How ARC Works）============
/*
 當你每次新建立一個『類別實體』時，ARC會分配一塊記憶體來儲存該實體資訊。
 記憶體中會包含『實體』的"型別資訊"，以及這個『實體』所有相關的"儲存屬性"的值。
 當『實體』不再被使用時，ARC釋放『實體』所佔用的記憶體，並讓釋放的記憶體能挪作他用。
 如果ARC釋放了正在被使用中的『實體』，該『實體』的"屬性"和"方法"將不能再被存取。
 實際上，如果你試圖存取這個『實體』，你的應用程式很可能會閃退。
 為了確保使用中的『實體』不會被釋放，ARC會追蹤和計算每一個『實體』正在被多少屬性、常數和變數所引用。
 哪怕『實體』的引用數量只有1個，ARC都不會釋放這個『實體』。
 無論你將『實體』設定給屬性、常數或變數，它們都會建立此『實體』的"強引用"（strong reference）。
 這些屬性、常數或變數會將『實體』牢牢地保持住，只要"強引用"還在，『實體』是不允許被釋放的。
 */

//==============『自動引用計數』實戰（ARC in Action）==============
//人的類別
class Person
{
    //名字『常數儲存屬性』
    let name: String
    //指定初始化方法
    init(name: String)
    {
        self.name = name
        //初始化時印出資訊
        print("\(name)被初始化")
    }
    //反初始化方法
    deinit
    {
        //釋放時印出資訊
        print("\(name)被釋放")
    }
}

//宣告三個型別為Person?的變數，為新的Person實體建立多個引用，變數值會被自動初始化為nil
var reference1: Person?
var reference2: Person?
var reference3: Person?

//建立Person類別的新實體，並且將它設定給三個變數其中的一個：
reference1 = Person(name: "John Appleseed")     //reference1與Person類別的新實體之間建立了一個"強引用"

//如果你將同樣的Person實體也設定給其他兩個變數，該實體又會多出兩個"強引用"：
reference2 = reference1
reference3 = reference1     //現在這個Person實體已經有三個"強引用"了

//如果你把兩個變數設定成nil來斷開兩個"強引用"（包括最先的那個"強引用"），只留下一個"強引用"，Person實體還不會被釋放：
reference1 = nil
reference2 = nil

//ARC會在第三個，也就是最後一個"強引用"被斷開的時候，釋放掉Person實體：
reference3 = nil

//=========在類別實體之間的『循環強引用』（Strong Reference Cycles Between Class Instances）===========
/*
 在某些情況下，有可能會寫出這樣的程式碼：一個類別永遠不會有0個『強引用』。
 這種情況發生在兩個類別實體互相保持住對方的『強引用』，讓彼此都不能被釋放，這就是所謂的『循環強引用』。
 你可以定義類別之間的關係為『弱引用』（weak reference)或『未持有引用』（unowned reference），用來替代『強引用』，以解決『循環強引用』的問題。
 */

//以下展示了一個不經意產生『循環強引用』的範例。範例定義了兩個類別：Person1和Apartment1，用來模擬公寓和公寓中的居民：
//人的類別
class Person1       //加1
{
    //名字『常數儲存屬性』
    let name: String
    //指定初始化方法
    init(name: String) { self.name = name }
    //apartment屬性是選擇性的，因為一個人並不一定擁有公寓
    var apartment: Apartment1?
    //反初始化方法
    deinit { print("\(name)被釋放") }
}

//公寓類別
class Apartment1      //加1
{
    //公寓編號『常數儲存屬性』
    let unit: String
    //指定初始化方法
    init(unit: String) { self.unit = unit }
    //住戶是選擇性的，因為一棟公寓不一定會有住戶（注意：要加1）
    var tenant: Person1?
    deinit { print("公寓：\(unit)被釋放") }
}

//宣告兩個選擇性變數，分別被設定為Apartment和Person的實體：
var john: Person1?
var unit4A: Apartment1?

//產生Person和Apartment的實體來設定這兩個變數：
john = Person1(name: "John Appleseed")
unit4A = Apartment1(unit: "4A")

//<附圖一>
let image1 = UIImage(named: "arc1.png")

//接著，將這兩個實體關聯在一起，這樣人就有公寓住，而公寓也有了房客：
john!.apartment = unit4A
unit4A!.tenant = john

//<附圖二>
let image2 = UIImage(named: "arc2.png")

/*
 注意：
 以上兩行將因此形成『循環強引用』！
 當你斷開john和unit4A變數所持有的『強引用』時，"引用計數"並不會降為0，『實體』也無法被ARC釋放。
 */

//即使兩個變數都設為nil，兩個『實體』都無法被釋放
john = nil      //想釋放john時，unit4A之內有個屬性來抓住john
unit4A = nil    //想釋放unit4A時，john之內有個屬性來抓住unit4A

//<附圖三>
let image3 = UIImage(named: "arc3.png")

//=====解決實體之間的『循環強引用』（Resolving Strong Reference Cycles Between Class Instances）=====
/*
 Swift提供了兩種辦法用來解決你在使用類別的屬性時所遇到的『循環強引用』問題：『弱引用』（weak reference）和『未持有引用』（unowned reference）。
 『弱引用』和『未持有引用』允許相互引用時，一個實體引用另一個實體而不保持『強引用』，這樣實體就能夠相互引用而不產生『循環強引用』。
 『弱引用』和『未持有引用』的選定原則如下：
 1.對於生命周期中會變為nil的實體使用『弱引用』。
 2.對於初始化設值之後再也不會被設值為nil的實體，使用『未持有引用』。
 */

//---------------------弱引用（Weak References）---------------------
/*
 『弱引用』不會牢牢保持住引用的實體，也不會阻止ARC釋放被引用的實體，這種行為阻止了引用變成『循環強引用』。
 宣告屬性或變數時，在前面加上weak關鍵字以表明這是一個『弱引用』。
 在實體的生命周期中，如果某些時候該引用"沒有值"（nil），那麼『弱引用』可以避免『循環引用』。
 如果引用之時總是會有值，則可以改用『未持有引用』。
 在上面Apartment的範例中，在一個公寓的生命周期當中，有時是沒有"住戶"的，因此適合使用『弱引用』來打斷循環引用。
 
 注意:
 『弱引用』必須被宣告為"變數"，以表明其值能在執行時被修改。
 『弱引用』不能被宣告為"常數"！
 
 因為『弱引用』可以"沒有值"（nil），你必須將每一個『弱引用』宣告為"選擇性型別"。
 因為『弱引用』不會保持住引用的實體，即使引用仍然存在的情況下，實體也可以被釋放。
 因此，ARC會在引用的實體被釋放之後，自動將其值設定為nil。
 你可以像檢查其他"選擇值"一樣，去檢查『弱引用』的值是否存在，你永遠不會引用到一個被釋放而不存在的實體（a reference to an invalid instance that no longer exists）。
 */

//下面的範例跟上面Person2和Apartment2的範例一樣，但這一次Apartment的tenant屬性被宣告為『弱引用』：
class Person2       //加2
{
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment2?      //(加2)一個人並不一定擁有公寓(這裏也可以加上weak關鍵字)
    deinit { print("\(name)被釋放") }
}

class Apartment2    //加2
{
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person2?       //(加2)『弱引用』一棟公寓不一定會有住戶
    deinit { print("公寓：\(unit)被釋放") }
}
//然後跟之前一樣，建立兩個變數之間的『強引用』，並關聯兩個實體：(注意：變數和類別通通要加2)
var john2: Person2?         //加2
var unit4A2: Apartment2?    //加2

john2 = Person2(name: "John Appleseed")     //『強引用』
unit4A2 = Apartment2(unit: "4A")            //『強引用』

john2!.apartment = unit4A2      //『強引用』
unit4A2!.tenant = john2         //這裡是『弱引用』

//<附圖四>
let image4 = UIImage(named: "arc4.png")

/*
 Person實體依然保持對Apartment實體的『強引用』，但是Apartment實體只是對Person實體的『弱引用』。這意味著當你斷開john變數所保持的『強引用』之時，就再也沒有指向Person實體的『強引用』了。
 */
//由於再也沒有指向Person實體的『強引用』，該實體會被釋放：
john2 = nil      //此時『強引用』被打斷

//<附圖五>
let image5 = UIImage(named: "arc5.png")

//由於再也沒有指向Apartment實體的『強引用』，所以將該實體設為nil時就會被釋放：
unit4A2 = nil

//<附圖六>最後的釋放結果，兩個記憶體區塊引用計數都降為0，因此都被ARC回收！
let image6 = UIImage(named: "arc6.png")

/*
 注意：
 在使用垃圾回收機制（garbage collection）的系統裡，弱指標（weak pointers）有時用來實作簡單的緩衝機制（caching mechanism），因為沒有『強引用』的對象，只會在記憶體壓力觸發垃圾回收機制之時才被釋放。
 但在ARC中，一旦值的最後一個『強引用』被移除，就會立即被釋放，而使得『弱引用』並不適合上述的用途。
 */

//------------------未持有引用（Unowned References）------------------
/*
 ● 和『弱引用』類似，『未持有引用』不會牢牢保持住引用的實體。
 ● 和『弱引用』不同，『未持有引用』"永遠有值"。
 ● 『未持有引用』總是被定義為"非選擇性型別"（non-optional type）。
 ● 在宣告屬性或變數時，加上關鍵字unowned表示這是一個『未持有引用』。
 由於『未持有引用』是"非選擇性型別"，ARC無法在實體被釋放後將『未持有引用』設為nil，因為"非選擇性型別"的變數不允許被設為nil。
 
 注意:
 如果你試圖在實體被釋放之後，存取該實體的『未持有引用』，會觸發執行時期錯誤。
 使用『未持有引用』時，你必須確保引用始終指向一個未釋放的實體。
 */

/*
 下面的範例定義了兩個類別：Customer和CreditCard，模擬了銀行客戶和客戶的信用卡。這兩個類別中，每一個都將另外一個類別的實體作為自身的屬性。這種關係會潛在地創造『循環強引用』。
 由於信用卡總是關聯著一個客戶，因此將customer屬性定義為『未持有引用』，以避免『循環強引用』。
 */

//客戶類別
class Customer
{
    let name: String        //一位客戶一定有名字，且名字不會變
    var card: CreditCard?   //一位客戶不一定有信用卡
    
    init(name: String)
    {
        self.name = name
    }
    
    deinit { print("\(name)被釋放") }
}

//信用卡類別
class CreditCard
{
    let number: UInt64  //卡號不會變！
    //『未持有引用』：一張信用卡一定要關聯一位客戶（信用卡撤銷時，關聯資料一起撤銷！）
    unowned let customer: Customer
    //以上兩個"常數屬性"只能透過『初始化方法』來設定，這樣可以確保產生CreditCard實體時，總是有一個customer實體與之關聯。
    
    init(number: UInt64, customer: Customer)    //傳入信用卡卡號與客戶
    {
        self.number = number
        self.customer = customer
    }
    
    deinit { print("卡號#\(number)被釋放") }
}

//定義一個叫john3的選擇性Customer變數，用來保存某個特定客戶：
var john3: Customer?    //加上3
//產生特定客戶
john3 = Customer(name: "John Appleseed")
//CreditCard實體產生時，一定要關聯到某一位客戶
john3!.card = CreditCard(number: 1234_5678_9012_3456, customer: john3!)

//<附圖七>
let image7 = UIImage(named: "arc7.png")

//當你斷開john變數持有的『強引用』時，再也沒有指向Customer實體的『強引用』了：
john3 = nil     //注意：在john變數被設為nil後Customer實體和CreditCard實體的都列印出了釋放的資訊

//<附圖八>
let image8 = UIImage(named: "arc8.png")


//--『未持有引用』與『隱性拆封的選擇屬性』（Unowned References and Implicitly Unwrapped Optional Properties）--
/*
 上面『弱引用』和『未持有引用』的範例涵蓋了兩種常見需要打破『循環強引用』的場景：
 
 <場景1>Person和Apartment的範例展示了兩個屬性的值都允許為nil（註：人不一定擁有公寓，公寓也不一定有住戶），並會潛在的產生『循環強引用』。這種場景最適合用『弱引用』來解決。 ＃註：彼此之間的關係很微弱＃
 
 <場景2>Customer和CreditCard的範例展示了一個屬性的值允許為nil（註：客戶不一定有信用卡），而另一個屬性的值不允許為nil（註：信用卡一定要關聯一位客戶），並會潛在的產生『循環強引用』。這種場景最適合透過『未持有引用』來解決。 ＃註：Ａ不一定要擁有Ｂ，可是一旦擁有了Ｂ，Ｂ就是Ａ的了，譬如：人不一定要養貓，但養了貓之後，貓就是那個主人的了＃
 
 <場景3>另外還存在第三種場景，在這種場景中，兩個屬性都必須有值，而且初始化完成後不能為nil。在這種場景中，需要一個類別使用『未持有引用屬性』，而另外一個類別使用『隱性拆封的選擇屬性』。
 
 這會讓兩個屬性在初始化完成後，就能直接被存取（不需要將選擇性的值拆封），同時避免了『循環引用』。
 */

//下面的範例定義了兩個類別，Country和City，每個『類別』將另一個『類別實體』保存為"屬性"。在這個模型中，每個國家必須有首都，而每一個城市必須屬於一個國家。為了實作這種關係，Country類別擁有一個capitalCity屬性，而City類別有一個country屬性：
class Country
{
    let name: String        //『國家名稱』屬性
    var capitalCity: City!  //『首都名稱』屬性～是『隱性拆封的選擇屬性』，因為一個國家必須有首都
    //自己類別的『初始化方法』，傳入『國家名稱』和『首都名稱』
    init(name: String, capitalName: String)
    {
        //將國家名稱直接設定給屬性（只有name沒有初值，所以只要給name屬性，self就會被配置出來）
        self.name = name
        //再去呼叫另一個類別的『初始化方法』來設定『首都名稱』屬性的初值，但這個初值在自己類別的『初始化方法』完成之前，並不會有值（得靠self完全生成後才有）！
        self.capitalCity = City(name: capitalName, country: self) //注意：這個self要等『初始化方法』完成才會有值！
        /*
         此處呼叫了City的『初始化方法』，但只有在Country的實體（即self）完全初始化完成後，才能把self傳給City的『初始化方法』。（在<兩段式初始化程序>中有具體描述）
         為了滿足這種需求，將capitalCity屬性宣告為『隱性拆封的選擇屬性』，使其值不需要拆封就能存取。
         */
    }
    deinit      //<補充>加上釋放函式
    {
        print("國家被釋放！")
    }
}

class City
{
    let name: String
    unowned let country: Country    //『未持有引用屬性』一個城市必須屬於一個國家
    init(name: String, country: Country)
    {
        self.name = name
        self.country = country
    }
    deinit      //<補充>加上釋放函式
    {
        print("城市被釋放")
    }
}
//你可以用單一敘述同時產生Country和City的實體，不會造成『循環強引用』，而且capitalCity的屬性能被直接存取，不需要將其值拆封：
var country:Country! = Country(name: "Canada", capitalName: "Ottawa")    //同時呼叫了Country與City類別的『初始化方法』
print("\(country.name)的首都是\(country.capitalCity.name)")

country = nil   //此行要運作，要改上兩行的宣告為optional，如下：var country:Country!

/*
 註：
 特定國家的初始化程序需要指定一個首都，而這個首都是一座城市，城市必須歸屬在特定國家中。
 */

//=========="閉包"引起的『循環強引用』（Strong Reference Cycles for Closures）==========
/*
 前面我們看到了『循環強引用』在兩個類別實體屬性互相保持對方的『強引用』時產生的，還知道了如何用『弱引用』和『未持有引用』來打破『循環強引用』。
 
 『循環強引用』還會發生在當你將一個閉包設定給"類別實體"的某個『屬性』，並且這個閉包中又使用了"實體"。
 這個閉包中可能存取了"實體"的某個『屬性』，例如self.someProperty，或者閉包中呼叫了"實體"的某個『方法』，例如self.someMethod。這兩種情況都導致閉包"捕獲"了self，而造成『循環強引用』。
 
 『循環強引用』的產生，是因為"閉包"和"類別"相似，都是<引用型別>。
 當你把一個"閉包"設定給某個屬性時，你也把一個引用設定給了這個"閉包"。（因為在類別的閉包屬性裡面，又呼叫了self類別本身）
 實質上，這跟之前的問題是一樣的～兩個『強引用』讓彼此一直有效。但是，和兩個類別實體不同，這次一個是"類別實體"，另一個是"閉包"。
 
 Swift提供了一種優雅的方法來解決這個問題，稱之為『閉包捕獲列表』（closuer capture list）。
 */

//下面的範例為你展示了當一個"閉包"引用了self之後，如何產生『循環強引用』。範例中定義了一個叫HTMLElement的類別，用一種簡單的模型表示HTML中一個單獨的元素：
class HTMLElement
{
    let name: String        //HTML標籤名稱（如：h1,p,br）
    let text: String?       //HTML標籤文字（但HTML標籤也可能沒有文字）
    //注意：此『延遲屬性』是一個"閉包"，『延遲屬性』只有在第一次被使用時，才會被產生出來
    lazy var asHTML: () -> String =
        {
            //閉包中存取了實體的屬性（這裡會造成『循環強引用』！）
            if let text = self.text
            {
                //如果有文字，將HTML標籤與文字組合成完整的HTML，如：<p>這是文字</p>
                return "<\(self.name)>\(text)</\(self.name)>"
            }
            else
            {
                //如果沒有文字，直接呈現單一的HTML結束標籤，如：<p/>
                return "<\(self.name)/>"
            }
        }
    /*
     注意:
     asHTML宣告為lazy屬性，因為只有當元素確實需要處理為HTML輸出的字串時，才需要使用asHTML。
     也就是說，在預設的閉包中可以使用self，因為只有當初始化完成以及self確實存在後，才能存取lazy屬性。
     */
    
    init(name: String, text: String? = nil)
    {
        self.name = name
        self.text = text
    }
    
    deinit
    {
        print("\(name)被釋放")
    }
}

//使用範例1：<h1>
let heading = HTMLElement(name: "h1")   //初始化時，不使用第二個參數
let defaultText = "這是預設文字"
heading.asHTML()        //<補充>測試原先類別內定義的閉包

//重新定義一個閉包給asHTML屬性（會覆蓋原先的閉包） 註：此行若省略，則執行原先定義的閉包
heading.asHTML = {      //重新定義的閉包當沒有提供文字時，不會使用nil，一律改成『這是預設文字』字樣
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())

//使用範例2：<p>
var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())

/*
 注意：
 上面的paragraph變數定義為"選擇性HTMLElement"，因此我們可以設定nil給它來演示『循環強引用』。
 上面的HTMLElement類別產生了"類別實體"和asHTML預設值的"閉包"之間的『循環強引用』。
 */

//<附圖九>
let image9 = UIImage(named: "arc9.png")

/*
 注意：
 雖然閉包多次使用了self，它只捕獲HTMLElement實體的一個『強引用』。
 */

//這時，就算把paragraph設成nil，HTMLElement實體也不會釋放！
paragraph = nil

//========解決閉包引起的『循環強引用』（Resolving Strong Reference Cycles for Closures）========
/*
 在定義閉包時，同時定義『捕獲列表』作為閉包的一部分，可以解決閉包和類別實體之間的『循環強引用』。
 『捕獲列表』定義了閉包內捕獲一個或者多個引用型別的規則。
 跟解決兩個類別實體之間的『循環強引用』一樣，宣告每個捕獲的引用為『弱引用』或『未持有引用』，而不是『強引用』。
 至於要使用『弱引用』還是『未持有引用』，則取決於程式碼之間的相互關係。
 
 注意：
 Swift有如下要求：只要在閉包內使用self的成員，就要用self.someProperty或者self.someMethod（不能只使用someProperty或someMethod）。這提醒你可能會不小心就捕獲了self。
 */

//---------------定義『捕獲列表』（Defining a Capture List）---------------
/*
 『捕獲列表』中的每一個項目都由一對元素所構成，"第一個元素"是weak或unowned關鍵字，"另一個元素"則是類別實體的引用（例如self）或者初始化過的變數（如delegate = self.delegate!）。這些配對項目放在一對"中括號"之內，使用逗號來隔開。
 
 『捕獲列表』放置在閉包"參數列表"和"回傳型別"之前，格式如下：
 lazy var someClosure: (Int, String) -> String = {
 [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
 // closure body goes here
 }
 
 如果閉包沒有指定"參數列表"或"回傳型別"，可以藉由上下文來推斷的話，那麼可以將『捕獲列表』放在閉包開始的地方，接著是關鍵字in：
 lazy var someClosure: Void -> String = {
 [unowned self, weak delegate = self.delegate!] in
 // closure body goes here
 }
 
 */

//--------------閉包的『弱引用』與『未持有引用』（Weak and Unowned References）--------------
/*
 ● 當閉包和捕獲的實體總是互相引用，而且也總是同時被銷毀時，將閉包內的捕獲定義為『未持有引用』。
 
 ● 相反的，當捕獲引用有時可能會是nil時，將閉包內的捕獲定義為『弱引用』。『弱引用』總是"選擇性型別"，而且當引用的實體被銷毀後，『弱引用』的值會自動設成nil。這樣讓我們可以在閉包內檢查它們是否存在。
 
 注意:
 如果捕獲的引用絕對不會設成nil，應該用『未持有引用』，而不是『弱引用』。
 */

//前面的HTMLElement範例中，『未持有引用』是正確解決『循環強引用』的方法。這樣編寫HTMLElement類別來避免『循環強引用』：
class HTMLElement1      //加上1
{
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        //在in前方加入『捕獲列表』，使用『未持有引用』來引用self（註：『捕獲列表』放在閉包"參數列表"和"回傳型別"之前）
        [unowned self] in
        if let text = self.text
        {
            return "<\(self.name)>\(text)</\(self.name)>"
        }
        else
        {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil)
    {
        self.name = name
        self.text = text
    }
    
    deinit
    {
        print("\(name)被釋放")
    }
    
}
//產生HTMLElement實體
var paragraph1: HTMLElement1? = HTMLElement1(name: "p", text: "hello, world")
print(paragraph1!.asHTML())

//<附圖十>
let image10 = UIImage(named: "arc10.png")

//重測以下程式，可以看到釋放訊息了：
paragraph1 = nil

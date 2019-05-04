import UIKit
//============以GCD函式來使用多執行緒============
/*
 透過C語言的Grand Central Dispatch（GCD）函式來撰寫多執行緒程式，可以將程式碼區段（Closure/Block）放到指定的『派遣佇列』（dispatch queue）中，讓作業系統依照佇列的特性，來決定是否要建立執行緒，以及如何執行這些程式碼區段。
 
 『派遣佇列』分為三種：Main佇列、Global佇列、Private佇列
 */

/*
 ● Main佇列～
 每個應用程式只有一個Main佇列，也就是預設佇列。Main佇列只會在"同一個執行緒"中，按照先進先出（FIFO）的方式依序執行。
 此外，Main佇列還需要在使用者觸發UI元件上的各種事件時，呼叫對應的處理函式，因此Main佇列只能透過async()非同步函式，將程式碼區段放到佇列中。
 */

//『非同步』可以跟其他程式同步執行，『同步』要等其他程式執行完成才能執行。

//以下範例將『程式碼區段1』和『程式碼區段2』放到Main佇列中，但都位於同一個執行緒，所以會先執行『程式碼區段1』，再執行『程式碼區段2』。

//取得Main佇列
let mainQueue = DispatchQueue.main
//把要執行的『程式碼區段1』以"非同步"的方式放置到Main佇列中
mainQueue.async {
    print("程式碼區段1")
}

//把要執行的『程式碼區段2』以"非同步"的方式放置到Main佇列中
mainQueue.async {
    print("程式碼區段2")
}

/*
 注意：
 在Main佇列使用async()函式，可能會導致使用者在操作UI元件時，出現反應延遲的現象。
 async()非同步函式會將一個『程式碼區段』放到佇列中，並且在呼叫之後就立刻返回（return）。
 另一個sync()同步函式則需等到裡面的『程式碼區段』執行完畢後才會返回，因此sync()函式不能用在Main佇列。
*/

//如果像下列程式一樣，以"同步執行"的方式將『程式碼區段』放置到Main佇列中，會阻斷主執行緒的執行，導致應用程式鎖死(deadlock)。所有透過GCD提送給Main佇列的『程式碼區段』都必須以非同步(asynchronously)的方式提送。
//mainQueue.sync {
//    print("程式碼區段3")
//}



/*
 ● Globle佇列（Concurrent佇列）～
 Globle佇列又稱Concurrent佇列，每個App都有四種不同優先權的Globle佇列，分別為高優先權、中（預設）優先權、低優先權、背景優先權。
 (PS.Swift3以後只有預設優先權和背景優先權)
 其中的"背景優先權"，是指這個佇列的程式碼所需要的CPU資源比較低，所以比較適合在背景執行，並不是指"背景優先權"只能在背景執行。
 利用async()非同步函式或sync()同步函式，可以將『程式碼區段』放到Globle佇列中。
 注意：
 1.Globle佇列可以容納"多個執行緒"，透過呼叫async()非同步函式，就會讓iOS產生一個新的執行緒來執行『程式碼區段』。
 2.如果利用sync()同步函式來將『程式碼區段』放到Globle佇列中，iOS則會視實際的運行狀況來決定是否要產生新的執行緒。
 */

//以下範例將三個程式碼區段放到Globle佇列中，『程式碼區段1』使用sync()同步函式，『程式碼區段2』和『程式碼區段3』則使用async()非同步函式，所以會先等待『程式碼區段1』執行完畢之後，才會"同時"去執行『程式碼區段2』和『程式碼區段3』。

//取得Globle佇列，並且指定為『中（預設）優先權』
let globalQueue = DispatchQueue.global(qos: .default)
globalQueue.sync {      //同步
    print("程式碼區段1")
}

globalQueue.async {     //非同步
    print("程式碼區段2")
}

globalQueue.async {     //非同步
    print("程式碼區段3")
}

/*
 ● Private佇列（Serial佇列）～
 Private佇列又稱Serial佇列，是自己建立的佇列，建立Private佇列時需要指定一個唯一的識別碼。
 同一個Private佇列中只會有一個執行緒，所以Private佇列中的『程式碼區段』是以FIFO的方式依序執行。
 如果將『程式碼區段』放置在不同的Private佇列中，則這些『程式碼區段』就有機會被"同時"執行。
 利用DispatchQueue類別的初始化函式（帶label參數），可以建立Private佇列。
 利用async()非同步函式或sync()同步函式，可以把『程式碼區段』放到"同一個Private佇列"中執行，但不論使用哪一個函式，"同一個Private佇列"都只能以FIFO的方式依序執行。
*/

//建立兩個Private佇列
let queue1 = DispatchQueue(label: "q1")
let queue2 = DispatchQueue(label: "q2")
//『程式碼區段1』和『程式碼區段2』將以FIFO的方式被執行
queue1.async {
    print("程式碼區段1")
}

queue1.async {
    print("程式碼區段2")
}
//但在同一時間，『程式碼區段3』會同時被執行
queue2.async {
    print("程式碼區段3")
}

/*
 以下兩種情境是GCD最典型的用法：
 1.如果你想要使用GCD進行非UI相關的任務，在不是Main佇列的佇列上使用dispatch_sync函式或dispatch_async函式。
 2.如果你想要進行UI相關的任務，則必須確保你操作UI的程式碼區段是位於Main佇列。
*/

//============讓執行緒暫停============
//以下指令可以讓『主執行緒』暫停一秒
Thread.sleep(forTimeInterval: 1.0)

//以下指令可以讓先前由Globle佇列所產生的『中優先權執行緒』暫停二秒
globalQueue.async {
    Thread.sleep(forTimeInterval: 2.0)
    print("暫停後的程式碼區段")
}



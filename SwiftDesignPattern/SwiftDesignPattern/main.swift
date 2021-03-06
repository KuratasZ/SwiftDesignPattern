//
//  main.swift
//  SwiftDesignPattern
//
//  Created by zhangwei on 2018/10/26.
//  Copyright © 2018年 Mr.Z. All rights reserved.
//

import Foundation

func protypeTest(){
    let a = TestClassSub()
    let b = a.copy()
    b.data = 1
    print(b.data)
    print(a.data)
    var c = TestStruct()
    var d = c
    //用于打印结构内存地址的函数
    withUnsafePointer(to: &c) {print($0)}
    withUnsafePointer(to: &d) {print($0)}
    print(c,d)
}


func factoryTest(){
    let p = ConcreteFactory.creatFor(subclass: ConcreteProduct.self)
    p?.use()
}


func absFactoryTest(){
    if let listFactory = AbstractFactory.creatFactory(subclass: ListFactory.self) {
        
        let people = listFactory.createLink(caption: "人民日报", url: "http://www.people.com.cn/");
        let gmw = listFactory.createLink(caption: "光明日报", url: "http://www.gmw.cn/");
        let us_yahoo = listFactory.createLink(caption: "Yahoo!", url: "http://www.yahoo.com/");
        let jp_yahoo = listFactory.createLink(caption: "Yahoo!Japan", url: "http://www.yahoo.co.jp/");
        let excite = listFactory.createLink(caption: "Excite", url: "http://www.excite.com/");
        let google = listFactory.createLink(caption: "Google", url: "http://www.google.com/");
        
        
        let traynews = listFactory.createTray(caption: "日报");
        traynews.add(people)
        traynews.add(people);
        traynews.add(gmw);
        
        let trayyahoo = listFactory.createTray(caption: "Yahoo!");
        trayyahoo.add(us_yahoo);
        trayyahoo.add(jp_yahoo);
        
        let traysearch = listFactory.createTray(caption: "检索引擎");
        traysearch.add(trayyahoo);
        traysearch.add(excite);
        traysearch.add(google);
        
        let page = listFactory.createPage(title: "LinkPage", author: "杨文轩");
        page.add(traynews);
        page.add(traysearch);
        page.output();
        
    }
}

func builderTest(){
    let p = Director(BlackBuilder()).construct()
    p.show()
}

func singletonTest(){
    let a = SingletonObject.sharedInstance
    var s = 0
    for i in 0..<100 {
        DispatchQueue.global().async {
            a.data += 1
            a.data -= 1
            DispatchQueue.main.sync {
                print(a.data)
            }
        }
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                print(a.data)
            }
        }
        if i % 2 == 0 {
            DispatchQueue(label: "test").async {
                a.data += 1
                s += 1
                DispatchQueue.main.sync {
                    print(">>>>>>\(a.data) \(s)<<<<<<<")
                }
            }
        }
    }
}


func adapterTest(){
    let a = Adapter(adaptee: Adaptee())
    a.request()
}



func runloopTest(){
    // 命令行模式下，需要启动一个runloop才可以保护多线程
    let runLoop = CFRunLoopGetCurrent();
    let runLoopMode = CFRunLoopMode.defaultMode;
    let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                                      CFRunLoopActivity.allActivities.rawValue,
                                                      false, 0) { (server, act) in
                                                        singletonTest()
    }
    CFRunLoopAddObserver(runLoop, observer, runLoopMode);
    CFRunLoopRun()
}

func iteratorTest() {
    let t = ItemSet()
    t.appendItem(i: Item("Alpha"))
    t.appendItem(i: Item("Beta"))
    t.appendItem(i: Item("Mu"))
    t.appendItem(i: Item("Nu"))
    
    let i = t.iterator
    while i.hasNext() {
        let t = i.next() as! Item
        print(t.getName())
    }
    
}


func templateMethodTest() {
    let t = CharDisplay("H")
    t.display()
}


func bridgeTest()  {
    let d1 = Display(StringDisplayImpl("Hello boy"))
    let d2 = CountDisplay(StringDisplayImpl("Hello countDisplay"))
    
    d1.display()
    d2.display()
    d2.multiDisplay(times: 5)
    
}


func strategyTest() {
    let play1 = Player(name: "Leo", strategy: IdiotStrategy())
    let play2 = Player(name: "Ada", strategy: WinningStrategy())
    
    for _ in 0..<10000 {
        let h1 = play1.nextHand()
        let h2 = play2.nextHand()
        
        if h1.isStrongerThan(h: h2){
            play1.win()
            play2.lose()
        }else if h1.isWeakerThan(h: h2){
            play1.lose()
            play2.win()
        }else{
            play1.even()
            play2.even()
        }
    }
    print("Total:")
    print(play1.toString())
    print(play2.toString())
    
    /*
     WinningStrategy ProbStrategy
     Total:
     [Leo:10000 games, 3126win 3537lose]
     [Ada:10000 games, 3537win 3126lose]
     
     IdiotStrategy ProbStrategy
     Total:
     [Leo:10000 games, 22win 9880lose]
     [Ada:10000 games, 9880win 22lose]
     
     IdiotStrategy WinningStrategy
     Total:
     [Leo:10000 games, 2win 9998lose]
     [Ada:10000 games, 9998win 2lose]
     */
}


func compositeTest() {
    let rootdir = Directory("root")
    let bindir = Directory("bin")
    let tmpdir = Directory("tmp")
    let usrdir = Directory("usr")
    rootdir.add(bindir)
    rootdir.add(tmpdir)
    rootdir.add(usrdir)
    bindir.add(File("vi", size: 10000))
    bindir.add(File("latex", size: 20000))
    rootdir.printList();
    
    print("Making user entries...")
    
    let yuki = Directory("yuki")
    let hanako = Directory("hanako")
    let tomura = Directory("tomura")

    usrdir.add(yuki)
    usrdir.add(hanako)
    usrdir.add(tomura)
    yuki.add(File("diary.html", size: 100))
    yuki.add(File("Composite.java", size: 200));
    hanako.add(File("memo.tex", size: 300));
    tomura.add(File("game.doc", size: 400));
    tomura.add(File("junk.mail", size: 500));
    rootdir.printList();
}

func decoratorTest() {
    let b1 = StringDisplay("hello world")
    let b2 = SideBorder(b1, ch: "#")
    let b3 = FullBorder(b2)
    
    b1.show()
    b2.show()
    b3.show()
    
    
    
    let b4 = SideBorder(FullBorder(SideBorder(FullBorder(StringDisplay("wtf")), ch: "*")), ch: "-")
    b4.show()
    
    // 链式调用
    let b5 = StringDisplay("nice").fullBorder().sideBorder(ch: "*").sideBorder(ch: "-")
    b5.show()
}


func visitorTest() {
    let rootdir = Directory("root")
    let bindir = Directory("bin")
    let tmpdir = Directory("tmp")
    let usrdir = Directory("usr")
    rootdir.add(bindir)
    rootdir.add(tmpdir)
    rootdir.add(usrdir)
    bindir.add(File("vi", size: 10000))
    bindir.add(File("latex", size: 20000))
//    rootdir.printList();
    rootdir.accept(v: ListVisitor())
    
    print("Making user entries...")
    
    let yuki = Directory("yuki")
    let hanako = Directory("hanako")
    let tomura = Directory("tomura")
    
    usrdir.add(yuki)
    usrdir.add(hanako)
    usrdir.add(tomura)
    yuki.add(File("diary.html", size: 100))
    yuki.add(File("Composite.java", size: 200));
    hanako.add(File("memo.tex", size: 300));
    tomura.add(File("game.doc", size: 400));
    tomura.add(File("junk.mail", size: 500));
//    rootdir.printList();
    rootdir.accept(v: ListVisitor())

}


func chainOfResponsibilityTest() {
    let alice = NoSupport("Alice")
    let bob = LimitSupport("Bob", limit: 100)
    let charlie = SpecialSupport("Charlie", n: 429)
    let diana = LimitSupport("Diana", limit: 200)
    let elmo = Oddsupport("Elmo")
    let fred = LimitSupport("Fred", limit: 300)
    
    _ = alice.setNext(next: bob).setNext(next: charlie).setNext(next: diana).setNext(next: elmo).setNext(next: fred)
    for i in stride(from: 0, to: 500, by: 33) {
        alice.support(t: Trouble(i))
    }
}


func facadeTest(){
    _ = PageMaker.makeWelcomePage(mailaddr: "hyuki@hyuki.com", fileName: "nothing")
}


func mediatorTest() {
    // 模拟操作在text长度为偶数,一致调整A,B的类的state属性
    let a = ConcreteMediator()
    for i in stride(from: 0, to: 500, by: 33) {
        a.inputText(n: i)
    }
}

func observerTest() {
    let generator = RandomNumberGenerator()
    let observer1 = DigitObserver()
    let observer2 = GraphObserver()
    generator.addObserver(ob: observer1)
    generator.addObserver(ob: observer2)
    
    generator.deleteObserver(ob: observer1)

    generator.execute()
    
    
}

func mementoTest() {
    let gamer = Gamer(100)
    var memento = gamer.createMemento()
    for i in 0..<100 {
        print("====== \(i)")
        print("当前状态:\(gamer)")
        gamer.bet()
        
        print("所持金钱为\(gamer.money)元。")
        
        // 决定如何处理Memento
        if gamer.money > memento.getMoney() {
            print("所持金钱增加了许多,因此保存当前的状态")
            memento = gamer.createMemento()
        }else if gamer.money < memento.getMoney() / 2 {
            print("所持金钱减少了许多,因此将恢复到以前的状态")
            print(memento)
            gamer.restoreMemento(memento: memento)
        }
        Thread.sleep(forTimeInterval: 5)
    }
}



func stateTest() {
    let cop = RoboCop.sharedInstance
    for i in 1..<100 {
        print("\(i) day")
        cop.setTager(id: Int.random(in: 2..<216))
        cop.begin()
        print("")
        Thread.sleep(forTimeInterval: 10)
    }
}



func flyweightTest(){
    print("输入数字字符串 0到9 和 -")
    let text = readLine(strippingNewline: true)
    if let t = text {
        let bigText = BigString(t)
        bigText.printBigString()
    }
}
func proxyTest()  {
    let p = PrinterProxy("Alice")
    print("现在的名字是:\(p.printerName)")
    p.printerName = "Bob"
    print("现在的名字是:\(p.printerName)")
    p.startPrint(text: "Hello, world.")
}
func delegateTest() {
    // main内模拟App运行
    let _ = AppView().viewDidAppear()
}
func commandText() {
    let history = MacroCommand()
    for i in 0..<10 {
        let log = CommandExecuter()
        let command = PrintCommand(log, text: "HELLO,NO.\(i)")
        history.add(cmd: command)
    }
    
    
    history.execute()
    
    history.undo()
    history.undo()
    history.undo()
    
    history.add(cmd: PrintCommand(CommandExecuter(),text: "Hello, world!"))
    history.execute()
    
    history.clear()
    history.add(cmd: PrintCommand(CommandExecuter(),text: "new world!"))
    history.execute()

}


func interpreterTest() {
    let file = "BehavioralPattern/InterpreterFile/program.txt"
    let path=URL(fileURLWithPath: file)
    let text=try! String(contentsOf: path)

    let texts = text.split(separator: "\n")
    for item in texts {
        print("===================")
        print("开始解释:\(item)")
        let node = ProgramNode()
        node.parse(context: Context(String(item)))
        print("解释结束")
        print("===================")
    }
 
    
}

interpreterTest()

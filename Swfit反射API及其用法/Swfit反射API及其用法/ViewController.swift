//
//  ViewController.swift
//  Swfit反射API及其用法
//
//  Created by 呆仔～林枫 on 2018/2/6.
//  Copyright © 2018年 最怕追求不凡,最后依然碌碌无为 - Crazy_Lin. All rights reserved.
//

import UIKit

/*
 Mirror
 Swift 的反射机制是基于一个叫 Mirror 的 Struct 来实现的.你为具体的 subject 创建一个 Mirror ,然后就可以通过它查询这个对象 subject
 */

// 在创建 Mirror 之前,先创建一个可以让我们当做对象来使用的简单数据结构

public class Store {
    let storesToDisk: Bool = true
}

public class BookmarkStore: Store {
    let itemCount: Int = 10
}

public struct Bookmark {
    enum Group {
        case Tech
        case News
    }
    
    fileprivate let store = {
        return BookmarkStore()
    }()
    
    let title: String?
    let url: URL
    let keywords: [String]
    let group: Group
}




class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let aBookmark = Bookmark(title: "Appventure", url: URL(string: "appventure.me")!, keywords: ["Swift","iOS","OS X"], group: .Tech)
//         创建 Mirror 最简单的方式就是使用 reflecting 构造器
        let aMirror = Mirror(reflecting: aBookmark)
//        print(aMirror)
        // 打印结果:  Mirror for Bookmark

/// Mirror 中有什么
        /*
         Mirror struct 中包含几个 types 来帮助确定你想查询的信息
         第一个是 DisplayStyle enum ,它会告诉你对象的类型
         public enum DisplayStyle {
            case `struct`
            case `class`
            case `enum`
            case tuple
            case optional
            case collection
            case dictionary
            case set
         }
         
         这些都是反射 API 的辅助类型.反射只要求对象是 Any 类型,而且 Swfit 标准库中有很多类型为 Any ,并且没有被列举在上面的 DisplayStyle enum 中.如果试图反射它们中间的某一个又会发生什么呢?
         */
//        let closure = { (a: Int) -> Int in return a * 2 }
//        let aMirror = Mirror(reflecting: closure).displayStyle
//        print(aMirror as Any)
        // 打印结果: nil 这里你会得到一个 Mirror ,但是 DisplayStyle 为 nil
        
        /*
         也有提供给 Mirror 的子节点使用的 typealias
         public typealias Child = (label: String?, value: Any)
         每个 Child 都包含一个可选的 label 和 Any 类型的 value.
         */
        /*
         接下来是 AncestorRepresentation
         public enum AncestorRepresentation {
            // 生成默认的 Mirror
            case generated
            // 使用最近的 ancestor 的 customized() 实现来给它生成一个 Mirror
            case customized(() -> Mirror)
            // 禁用所有的 ancestor class 的行为,superclassMirror() 返回值为 nil
            case suppressed
         }
         这个 enum 用来定义被反射的对象的父类应该如何被反射,你可以使用 AncestorRepresentation enum 来定义父类被反射的细节
         */
/// 如何使用一个 Mirror
        /*
        下面列举了 Mirror 可用的属性/方法
        public let subjectType: Any.Type  // 对象的类型
        public let children: Mirror.Children  // 对象的子节点
        public let displayStyle: Mirror.DisplayStyle?  // 对象的展示风格
        public var superclassMirror: Mirror? { get }  // 对象父类的 Mirror
        */
        
/// subjectType
        print(aMirror.subjectType) //打印结果: Bookmark
        print(Mirror(reflecting: 9).subjectType) //打印结果: Int
/// children
        for (label,value) in aMirror.children {
            print(label ?? "nil","--",value)
        }
        /* 打印结果 :
         Optional("store") -- Swfit反射API及其用法.BookmarkStore
         Optional("title") -- Optional("Appventure")
         Optional("url") -- appventure.me
         Optional("keywords") -- ["Swift", "iOS", "OS X"]
         Optional("group") -- Tech
         */
/// displayStyle
        print(aMirror.displayStyle ?? "nil")
        // 打印结果: Optional(Swift.Mirror.DisplayStyle.struct)
/// superclassMirror
        /* 这是我们对象父类的 Mirror .如果这个对象不是一个类,它会是一个空的 Optional 值,如果对象是类型是基于类的,我们会得到一个新的 Mirror */
        print(Mirror(reflecting: aBookmark).superclassMirror ?? "对象不是一个类")
        // 打印结果: nil
        print(Mirror(reflecting: aBookmark.store).superclassMirror ?? "对象不是一个类")
        //打印结果: Optional(Mirror for Store)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }


}


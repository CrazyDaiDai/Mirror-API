//
//  ViewController.swift
//  Swift-Mirror的使用
//
//  Created by 呆仔～林枫 on 2018/2/6.
//  Copyright © 2018年 最怕追求不凡,最后依然碌碌无为 - Crazy_Lin. All rights reserved.
//

import UIKit

public enum sexEnum {
    case man
    case woman
}

class User {
    
    private var userAge: Int = 0
    
    /// 姓名
    fileprivate var name: String?
    /// 昵称
    fileprivate var nickName: String = ""
    /// 年龄
    fileprivate var age: Int {
        get {
            return userAge
        }
        set {
            userAge = max(0, newValue)
        }
    }
    /// 性别
    fileprivate var sex: sexEnum?
    
    convenience init(name: String?,
                     nickName: String = "这个用户比较懒",
                     age: Int = 18,
                     sex: sexEnum? = .man) {
        self.init()
        self.name = name
        self.nickName = nickName
        self.age = age
        self.sex = sex
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User(name: "Crazylin.cn", age: 18, sex: .man)
        let user_mirror = Mirror(reflecting: user)
        print("对象的类型 : \(user_mirror.subjectType)")
        print("对象的元素个数 : \(user_mirror.children.count)")
        for (label,value) in user_mirror.children {
            print("\(label ?? "nil") -- \(value)")
        }
        
        print(getValueForKey(obj: user, key: "nickName"))
        print(getValueForKey(obj: user, key: "name"))
    }

    private func getValueForKey(obj: Any,key: String) -> Any {
        let obj_mirror = Mirror(reflecting: obj)
        for (label,value) in obj_mirror.children {
            if label == key {
                return unwrap(any: value)
            }
        }
        return NSNull()
    }
    // 拆包可选类型
    private func unwrap(any: Any) -> Any {
        let any_mirror = Mirror(reflecting: any)
        if any_mirror.displayStyle != Mirror.DisplayStyle.optional {
            return any
        }
        if any_mirror.children.count == 0 {
            return any
        }
        let (_,value) = any_mirror.children.first!
        return value
    }
}


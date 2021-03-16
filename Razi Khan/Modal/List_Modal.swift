//
//  List_Modal.swift
//  Razi Khan
//
//  Created by Razi Khan on 15/03/21.
//

import UIKit

//MARK:- List_Modal class
class List_Modal: NSObject {

    var imageMain                 : String?
    var name                      : String?
    var subArr                    : NSMutableArray!
    var subCatName                : String?
    var displayName               : String?

    
    override init() {
        super.init()
        self.imageMain            = ""
        self.name                 = ""
        self.subArr               = NSMutableArray()
        self.subCatName           = ""
        self.displayName          = ""
    }
    
    //MARK:- getDataFromJson1 Function
    class func getDataFromJson1(dict: NSDictionary) -> List_Modal {
        let model = List_Modal()
        //model.imageMain = dict.value(forKey: "name") as? String ?? ""
        model.name = dict.value(forKey: "name") as? String ?? ""
        model.subArr = NSMutableArray()
        if let dataArray: NSArray = dict.value(forKey: "sub_category") as? NSArray {
            if dataArray.count > 0 {
                for obj in dataArray {
                    let dic = obj as! NSDictionary
                    let listModel:List_Modal = List_Modal.getDataFromJson2(dict: dic)
                    model.subArr.add(listModel)
                }
            }
        }
        return model
    }
    
    //MARK:- getDataFromJson2 Function
    class func getDataFromJson2(dict: NSDictionary) -> List_Modal {
        let model = List_Modal()
        model.subCatName = dict.value(forKey: "name") as? String ?? ""
        model.displayName = dict.value(forKey: "display_name") as? String ?? ""
        return model
    }
}

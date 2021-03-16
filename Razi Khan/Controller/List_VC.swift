//
//  List_VC.swift
//  Razi Khan
//
//  Created by Razi Khan on 15/03/21.
//

import UIKit
import Kingfisher

//MARK:- headerViewCell class
class headerViewCell: UITableViewCell {
    @IBOutlet weak var item_Image               : UIImageView?
    @IBOutlet weak var name_Lbl                 : UILabel?
    @IBOutlet weak var arrow_Image              : UIImageView?

    func setExpanded() {
        arrow_Image?.image = #imageLiteral(resourceName: "topArrow")
    }
    func setCollapsed() {
        arrow_Image?.image = #imageLiteral(resourceName: "downArrow")
    }
}

//MARK:- mainCell class
class mainCell: UITableViewCell {
    @IBOutlet weak var nameSC_Lbl               : UILabel?
    @IBOutlet weak var displaySC_Lbl            : UILabel?
}

//MARK:- List_VC class
class List_VC: UIViewController {

    @IBOutlet weak var listTable                : UITableView?

    //MARK:- Array's Variable Declaration
    var dataArr                                 : [List_Modal] = []
    private var sectionIsExpanded               = [false]

    
    //MARK:- viewDidLoad LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        self.getListFromJson()
    }
}

//MARK:- List_VC extension for All Function's
extension List_VC {
    
    //MARK:- getListFromJson Function
    func getListFromJson() {
        
        let path = Bundle.main.path(forResource: "menu", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        let datastring = NSString(data: jsonData! as Data, encoding: String.Encoding.utf8.rawValue)
        let dictData = self.convertToArray(text: datastring! as String)
        let dataArray = dictData as? NSArray ?? []
        dataArray.enumerateObjects { (obj, idx, point) in
            let dictData:NSDictionary = dataArray.object(at: idx) as? NSDictionary ?? [:]
            let modal:List_Modal = List_Modal.getDataFromJson1(dict: dictData)
            self.dataArr.append(modal)
        }
        for i in 0..<self.dataArr.count {
             if !(i == 0) {
                self.sectionIsExpanded.append(false)
             }
        }
    }
}

//MARK:- List_VC extension For UITableView
extension List_VC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.dataArr.count > 0) ? self.dataArr.count : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.dataArr.count > 0) {
            let model = self.dataArr[section]
            return sectionIsExpanded[section] ? (1+model.subArr.count) : 1
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.dataArr.count > 0) ? ((indexPath.row == 0) ? UITableView.automaticDimension : UITableView.automaticDimension) : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerViewCell", for: indexPath) as! headerViewCell
             if self.dataArr.count > 0 {
                let model:List_Modal = self.dataArr[indexPath.section]
                cell.item_Image?.image = #imageLiteral(resourceName: "ring")
                //let imageURL = URL(string: model.imageMain ?? "")
                //cell.item_Image?.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "ring"))
                cell.name_Lbl?.text = model.name ?? ""
                if sectionIsExpanded[indexPath.section] {
                     cell.setExpanded()
                } else {
                     cell.setCollapsed()
                }
             }
             return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! mainCell
            if self.dataArr.count > 0 {
               let model:List_Modal = self.dataArr[indexPath.section]
                if ((model.subArr?.count ?? 0) > 0) {
                    let modelClass: List_Modal = model.subArr.object(at: indexPath.row - 1) as! List_Modal
                    cell.nameSC_Lbl?.text = modelClass.subCatName ?? ""
                    cell.displaySC_Lbl?.text = modelClass.displayName ?? ""
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            DispatchQueue.main.async {
                self.sectionIsExpanded[indexPath.section] = !self.sectionIsExpanded[indexPath.section]
                tableView.reloadSections([indexPath.section], with: .automatic)
            }
        }
    }
}

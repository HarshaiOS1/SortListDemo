//
//  ListViewModel.swift
//  HexadDemoAssignment
//
//  Created by Harsha on 04/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import Foundation

class ListViewModel: NSObject {
    var model: ListModel?
    /*
     Mock service call with Json file
     */
    
    func getListData(completion: @escaping (Bool, Int, String?)->Void) {
        RandomObjectsListAPI().getListData { (isSuccess, responseCode, data) in
            if isSuccess {
                guard let data = data else {
                    completion(false,404,"error")
                    return
                }
                let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                print(string1)
                do {
                    let list = try JSONDecoder().decode(ListModel.self, from: data)
                    self.model = list
                    completion(true, responseCode, "success")
                } catch let err {
                    completion(false,responseCode, err as? String)
                }
            } else {
                completion(false,responseCode,"error")
            }
        }
    }
    
    func filterData(dropDownRow: Int) {
        var filterModel : [Itemlist]?
        if let list = model?.itemlist {
            switch dropDownRow {
            case FilterOption.atoz.rawValue:
                filterModel = list.sorted { ($0.name ?? "") < ($1.name ?? "")}
            case FilterOption.ztoa.rawValue:
                filterModel = list.sorted { ($0.name ?? "") > ($1.name ?? "")}
            case FilterOption.ltoh.rawValue:
                filterModel = list.sorted { ($0.rating ?? 0) < ($1.rating ?? 0)}
            case FilterOption.htol.rawValue:
                filterModel = list.sorted { ($0.rating ?? 0) > ($1.rating ?? 0)}
            default:
                break
            }
            model?.itemlist = filterModel
        }
    }
    
    func generateRandomRating() {
        if var list = model?.itemlist {
            for i in 0...(list.count-1) {
                let randomVal = Float.random(in: 0 ..< 1)
                let val = Float(String(format: "%.2f",((list[i].rating ?? 0.0) + randomVal)))
                list[i].rating = val
            }
            model?.itemlist = list
        }
    }

    enum Rate: Int {
        case increment = 0
        case decrement = 1
    }
    
    enum FilterOption: Int {
        case atoz = 0
        case ztoa = 1
        case ltoh = 2
        case htol = 3
    }
}

struct RandomObjectsListAPI {
    func getListData(completion: @escaping (Bool, Int, Data?) -> Void) {
        if let path = Bundle.main.path(forResource: "MockJson", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let jsonData = try Data(contentsOf: url, options: .alwaysMapped)
                completion(true, 200, jsonData)
            } catch {
                completion(false, 400, nil)
            }
        }
    }
}

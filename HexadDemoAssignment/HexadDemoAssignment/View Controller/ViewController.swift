//
//  ViewController.swift
//  HexadDemoAssignment
//
//  Created by Harsha on 04/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var arrFilterList = ["Name: A - Z", "Name: Z - A", "Rating: Low - High", "Rating: High - Low"]
    var isExpand : Bool?
    var currentlySelectedFilter = 0
    @IBOutlet weak var filterTypeLabel: UILabel!
    var viewModel = ListViewModel()
    var randomTimer: Timer?
    var isTimerOn = false
    
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var randomRatingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getListData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func getListData() {
        viewModel.getListData { (isSuccess, responseCode, message) in
            if isSuccess {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("error")
            }
        }
    }
    
    @IBAction func randomratingButtonAction(_ sender: Any) {
        if !isTimerOn {
            addRandomNumber()
            isTimerOn = true
            randomTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addRandomNumber), userInfo: nil, repeats: true)
        } else {
            isTimerOn = false
            randomTimer?.invalidate()
        }
    }
    
    @objc func addRandomNumber() {
        viewModel.generateRandomRating()
        DispatchQueue.main.async {
            self.tableView.reloadSections([1], with: .top)
        }
    }
    
    @IBAction func dropDownButtonAction(_ sender: Any) {
        isExpand = !(isExpand ?? false)
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .bottom)
        }
    }
    
    deinit {
        print("Deinit - ViewController")
    }
}

//MARK: UITableViewDelegate & UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isExpand ?? false ? arrFilterList.count : 0
        }
        return viewModel.model?.itemlist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
            cell.textLabel?.text = arrFilterList[indexPath.row]
            cell.textLabel?.font = UIFont(name: "FuturaBook", size: 16.0)
            cell.textLabel?.textColor = UIColor.lightText
            cell.backgroundColor = UIColor.gray
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsListTableViewCell", for: indexPath) as? ItemsListTableViewCell else {
                return UITableViewCell.init()
            }
            if let deviceData = viewModel.model?.itemlist {
                cell.itemTitleName.text = (deviceData[indexPath.row].name ?? "") + "\nRating: " + String(deviceData[indexPath.row].rating ?? 0)
            }
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = UIColor.lightText
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            filterTypeLabel.text = self.arrFilterList[indexPath.row].uppercased()
            isExpand = !(isExpand ?? false)
            currentlySelectedFilter = indexPath.row
            viewModel.filterData(dropDownRow: indexPath.row)
            tableView.reloadData()
        } else { }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 35.0
        }
        return 65.0
    }
}

//MARK: RatingButtonActionDelegate
extension ViewController: RatingButtonActionDelegate {
    func changeRating(tag: ListViewModel.Rate, cell: ItemsListTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell),
            let modelData = viewModel.model?.itemlist {
            switch tag {
            case ListViewModel.Rate.increment:
                viewModel.model?.itemlist?[indexPath.row].rating = (modelData[indexPath.row].rating ?? 0.0) + 0.5
            case ListViewModel.Rate.decrement:
                viewModel.model?.itemlist?[indexPath.row].rating = (modelData[indexPath.row].rating ?? 0.0) - 0.5
            }
            viewModel.filterData(dropDownRow: currentlySelectedFilter)
            DispatchQueue.main.async {
                if self.currentlySelectedFilter == 0 || self.currentlySelectedFilter == 1 {
                    self.tableView.reloadSections([indexPath.section], with: .none)
                } else {
                    self.tableView.reloadSections([indexPath.section], with: .fade)
                }
            }
        }
    }
}


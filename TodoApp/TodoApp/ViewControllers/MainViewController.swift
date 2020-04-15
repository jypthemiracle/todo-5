//
//  ViewController.swift
//  TodoApp
//
//  Created by delma on 2020/04/06.
//  Copyright © 2020 delma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var navigationBar: UINavigationBar!
    let firstViewController = TasksViewController()
    let secondViewController = TasksViewController()
    let thirdViewController = TasksViewController()
    
    lazy var controllers = [firstViewController, secondViewController, thirdViewController]
    
    private var firstView: UIView?
    private var secondView: UIView?
    private var thirdView: UIView?
    
    let networkManager = NetworkManager()
    private var allData: AllData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild()
        configureViews()
        addSubViews()
        setConstraints()
        requestAllData()
        addObserver()
    }
    
    func addChild() {
        self.addChild(firstViewController)
        self.addChild(secondViewController)
        self.addChild(thirdViewController)
    }
    
    func configureViews() {
        firstView = firstViewController.view
        secondView = secondViewController.view
        thirdView = thirdViewController.view
    }
    
    func addSubViews() {
        self.view.addSubview(firstView!)
        self.view.addSubview(secondView!)
        self.view.addSubview(thirdView!)
    }
    
    private func requestAllData() {
        networkManager.getResource(url: EndPoints.AllCategories!, methodType: .get, dataType: AllData.self) { self.branchAllData(result: $0) }
    }
    
    private func branchAllData(result: Result<Any, NetworkErrorCase>) {
        switch result {
        case .success(let anyData):
            self.allData = anyData as? AllData
            guard let allData = self.allData else { return }
            DispatchQueue.main.async {
                for index in 0..<self.controllers.count {
                    self.controllers[index].category = allData.data[index]
                }
            }
        case .failure(let error):
            //네트워크 오류 알림 알럿창 생성
            print(error.localizedDescription)
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(requestOneCategory(_:)), name: .addNewCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(_:)), name: .updateCount, object: nil)
    }
    
    @objc func requestOneCategory(_ notification: Notification) {
        guard let categoryNumber = notification.userInfo?["categoryNumber"] as? Int else { return }
        let urlString = EndPoints.API!.absoluteString + "/category/\(categoryNumber)/all"
        let url = URL(string: urlString)
        networkManager.getResource(url: url!, methodType: .get, dataType: Category.self, body: nil) { result in
            switch result {
            case .success(let anyData):
                guard let categoryData = anyData as? Category else { return }
                self.controllers[categoryNumber-1].category = categoryData
            case .failure(let error):
                //네트워크 오류 알림 알럿창 생성
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func updateData(_ notification: Notification) {
        guard let updateInfo = notification.userInfo?["updateInfo"] as? (count: Int, categoryID: Int, taskID: Int) else { return }
        requestDelete(taskID: updateInfo.taskID)
        updateTasksCount(updateInfo: updateInfo)
    }
    
    private func updateTasksCount(updateInfo: (count: Int, categoryID: Int, taskID: Int)) {
        let targetController = controllers.filter { $0.category?.id == updateInfo.categoryID }.first
        guard let controller = targetController else { return }
        controller.titleView.setTasksCount(count: updateInfo.count)
    }
    
    private func requestDelete(taskID: Int) {
        let urlString = EndPoints.API!.absoluteString + "/task/\(taskID)/delete"
        let url = URL(string: urlString)
        networkManager.getResource(url: url!, methodType: .post, dataType: RequestBody.self) { _ in }
    }
    
    private func setConstraints() {
        firstView?.translatesAutoresizingMaskIntoConstraints = false
        firstView?.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 0).isActive = true
        firstView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        firstView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        firstView?.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.33, constant: 0).isActive = true
        
        secondView?.translatesAutoresizingMaskIntoConstraints = false
        secondView?.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 0).isActive = true
        secondView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        secondView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        secondView?.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.33, constant: 0).isActive = true
        
        thirdView?.translatesAutoresizingMaskIntoConstraints = false
        thirdView?.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 0).isActive = true
        thirdView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        thirdView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        thirdView?.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.33, constant: 0).isActive = true
    }

}

extension Notification.Name {
    static let updateCount = Notification.Name(rawValue: "updateTitle")
    static let addNewCard = Notification.Name("addNewCard")
}

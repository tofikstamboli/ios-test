//
//  ViewController.swift
//  PracticeApp
//
//  Created by Indiawyn Gaming on 10/08/20.
//  Copyright © 2020 myorg. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ViewController: UIViewController {

    var tableView = UITableView()
    var dataModel = [DataModel]()
    let fetchData = FetchDataVM()
    let errorView = UIView()
    let msg = UILabel()
    let btn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(tableView)
        tableView.register(CustomCell1.self, forCellReuseIdentifier: "Cell1") // For setting text data
        tableView.register(CustomCell2.self, forCellReuseIdentifier: "Cell2") // For setting image data
        
        // set autoresizable table cell
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupView()
        
        fetch()
    }
    
    // set constrsints for tableView view
    func setupView(){
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }
    
   
   // fetch data from ViewModel FetchDataVM
    func fetch() {
        fetchData.fetchData(resp: {dataModel in
            self.tableView.isHidden = false
            self.errorView.isHidden = true
            self.btn.isHidden = true
            self.msg.isHidden = true
            self.dataModel = dataModel!
            self.tableView.reloadData()
        }, issue: {errStr in
            
            
            // hide table and retry
            
            self.tableView.isHidden = true
            self.view.addSubview(self.errorView)
            self.errorView.addSubview(self.msg)
            self.errorView.addSubview(self.btn)
            self.btn.setTitle("Retry", for: .normal)
            self.btn.backgroundColor = .black
            self.msg.numberOfLines = 0
            
            // set constrsints for error view
            self.errorView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalToSuperview().inset(20)
                make.height.equalTo(200)
            }
            
            // set constrsints for message view
            self.msg.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(self.errorView).inset(10)
            }
            
            // set constrsints for retry button
            self.btn.snp.makeConstraints { make in
                make.centerX.equalTo(self.errorView)
                make.bottom.equalTo(self.errorView).inset(20)
                make.width.equalTo(100)
                make.height.equalTo(50)
            }
            
            // add action for retry button
            self.btn.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
           
            if errStr == "The Internet connection appears to be offline." { // handle internet connection
                self.errorView.backgroundColor = .orange
                self.msg.text = errStr! + " Please connect to Internet and try again !"
            } else { // Data loading or core data or fetching error
                self.errorView.backgroundColor = .red
                self.msg.text = "Something Went wrong ! Please try again or Reistall application"
            }
        })
    }
    
    
    //retry button action
    @objc func buttonClicked() {
      
          fetch()
        
       }
       
}


// Table View Delegates 
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dataModel[indexPath.row].type == "text" { // check for text type and set text data cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell1
            
            cell.date.text = dataModel[indexPath.row].date
            cell.data.text = dataModel[indexPath.row].data
            
            if dataModel[indexPath.row].date == "" || dataModel[indexPath.row].data == ""  {
                cell.data.text = "Data Not Found"
            }
        return cell
            
        } else { // set image data cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! CustomCell2
            cell.date.text = dataModel[indexPath.row].date
            cell._imageView.kf.indicatorType = .activity
            cell._imageView.kf.setImage(with: URL(string: dataModel[indexPath.row].data!),placeholder: UIImage(named: "img"))
            
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ShowDetails()
        vc.data = dataModel[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
}


// create text data cell and setup
class CustomCell1 : UITableViewCell {
    
    let in_view = UIView()
    let data = UILabel()
    let date = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style:style,reuseIdentifier : reuseIdentifier)
        self.contentView.addSubview(in_view)
        in_view.backgroundColor = .black
        in_view.addSubview(data)
        in_view.addSubview(date)
        in_view.layer.cornerRadius = 20
        data.numberOfLines = 0
        data.textColor = .white
        date.textColor = .systemBlue
        setupConstaints()
    }
    
    func setupConstaints(){
               
               in_view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(10)
                make.top.bottom.equalToSuperview().inset(5)
               }
               date.snp.makeConstraints { make in
                make.top.trailing.equalTo(in_view).inset(10)
               }
               data.snp.makeConstraints { make in
                make.top.equalTo(date).inset(30)
                make.leading.trailing.bottom.equalTo(in_view).inset(10)
               }
        
           }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// create imgae data cell and setup
class CustomCell2 : UITableViewCell {
    
    let date = UILabel()
    let _imageView = UIImageView()
    let in_view = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        
        date.textColor = .systemBlue
        contentView.addSubview(in_view)
        in_view.addSubview(date)
        in_view.addSubview(_imageView)
        
        setupView()
    }
    
    func setupView(){
        
        in_view.snp.makeConstraints { make in
         make.leading.trailing.equalToSuperview().inset(10)
         make.top.bottom.equalToSuperview().inset(5)
        }
        
        date.snp.makeConstraints { make in
         make.top.trailing.equalTo(in_view).inset(10)
        }
        
        _imageView.snp.makeConstraints { make in
         make.center.equalTo(in_view)
         make.top.equalTo(date).inset(30)
         make.height.equalTo(in_view.snp.width).dividedBy(1.2)
         make.width.equalTo(in_view.snp.width).dividedBy(1.2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

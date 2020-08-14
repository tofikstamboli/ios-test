//
//  ShowDetails.swift
//  PracticeApp
//
//  Created by Indiawyn Gaming on 14/08/20.
//  Copyright © 2020 myorg. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

// showing details of clicked cell

class ShowDetails : UIViewController {
    
    let in_view = UIView()
    let top_view = UIView()
    var data = DataModel()
    let date = UILabel()
    let datalbl = UILabel()
    let _image = UIImageView()
    let scrollView = UIScrollView()
    let close = UIButton()
    
    
    override func viewDidLoad() {
        
        // set properties
        self.view.backgroundColor = .clear
        self.view.addSubview(in_view)
        
        datalbl.numberOfLines = 0
        in_view.backgroundColor = .white
       
        close.backgroundColor = .black
        close.setTitle("Close", for: .normal)
        self.view.addSubview(top_view)
        top_view.backgroundColor = .white
        self.top_view.addSubview(date)
        self.top_view.addSubview(close)
        
        //set constrains for each components
        close.addTarget(self, action: #selector(BtnAction), for: .touchUpInside)
        
        if data.date != "" {
        date.text = data.date
        }else{
            date.text = "Date Not Found"
        }
        
        in_view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(self.view.snp.width).inset(5)
        }
        top_view.snp.makeConstraints { make in
            
            make.bottom.equalTo(in_view.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(in_view.snp.width)
            make.height.equalTo(50)
            
        }
        
        close.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(top_view).inset(5)
            make.width.equalTo(50)
        }
        
        date.snp.makeConstraints { make in
            make.top.leading.equalTo(top_view).inset(10)
        }
        
        if data.type == "text" { // show text type data
            
            self.in_view.addSubview(scrollView)
            scrollView.snp.makeConstraints { make in
                make.top.trailing.bottom.leading.equalTo(in_view)
            }
            if data.data != "" { // check for empty data / text
            self.datalbl.text = data.data
            }else{
                self.datalbl.text = "Data Not Found "
            }
            
            // large amount of data need to be in scroll view
            self.scrollView.addSubview(datalbl)
            
            datalbl.snp.makeConstraints { make in
                make.top.leading.bottom.equalTo(scrollView).inset(5)
                make.width.equalToSuperview().inset(10)
            }
         
        }else{ // view image type data
            
            self.in_view.addSubview(_image)
            self._image.kf.indicatorType = .activity
            self._image.kf.setImage(with: URL(string: data.data!),placeholder: UIImage(named: "img"))
            _image.snp.makeConstraints { make in
                 make.center.equalTo(in_view)
                 make.top.equalTo(date).inset(30)
                 make.height.equalTo(in_view.snp.width).dividedBy(1.2)
                 make.width.equalTo(in_view.snp.width).dividedBy(1.2)
            }
            
        }
    }
    
    
    // dismiss view on close button action
    @objc func BtnAction(){
        self.dismiss(animated: true, completion: nil)
    }
}

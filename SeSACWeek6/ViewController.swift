//
//  ViewController.swift
//  SeSACWeek6
//
//  Created by 이현호 on 2022/08/08.
//

import UIKit

//import SwiftyJSON

/*
 1. html tag <> </> 기능 활용
 2. 문자열 대체 메서드 사용
 * response에서 처리하는 것과 보여지는 셀 등에서 처리하는 것의 차이는?
 */

/*
 TableView automaticDimension
 - 컨텐츠 양에 따라서 셀 높이가 자유롭게
 - 조건: 레이블 numberOfLines 0
 - 조건: tableView Height automaticDimension
 - 조건: 레이아웃
 */

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var blogList: [String] = []
    var cafeList: [String] = []
    
    var isExpanded = false // false 2줄, true 0으로!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBlog()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension //모든 섹션의 셀에 대해서 유동적으로 잡겠다!
    }
    
    func searchBlog() {
        kakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
            
//            print(json)
            
            //swifty json의 라이브러리의 방식을 사용해야 subscript를 사용가능함
            for item in json["documents"].arrayValue {
                
                //가독성 측면에서 나눠주는 점이 좋아보이긴함
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                self.blogList.append(value)
            }
            
            self.searchCafe()
            
        }
    }
    
    func searchCafe() {
        kakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            
//            print(json)
            
            for item in json["documents"].arrayValue {
                
                //of를 with로 바꿔줌
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                
                self.cafeList.append(value)
            }
            
            print(self.blogList)
            print("블로그 정보 출력 끝")
            print("==============================여기서부터 카페")
            print(self.cafeList)
            print("카페 정보 출력 끝")
            
            self.tableView.reloadData()
                        
        }
    }
    
    //더보기 기능으로 활용 가능
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        
        isExpanded = !isExpanded
        tableView.reloadData()
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return blogList.count
//        } else {
//            return cafeList.count
//        }
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kakaoCell", for: indexPath) as? kakaoCell else { return UITableViewCell() }
        
        cell.testLabel.numberOfLines = isExpanded ? 0 : 2
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색 결과" : "카페 검색 결과"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //조건에 따라서 높이를 따로 설정해줄 수 있음
        return UITableView.automaticDimension
    }
    
}

class kakaoCell: UITableViewCell {
    
    //연결이 잘 안될때는 역으로 작성 후에 해보기
    @IBOutlet weak var testLabel: UILabel!
    
}

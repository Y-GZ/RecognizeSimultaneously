//
//  SubViewController.swift
//  RecognizeSimultaneously
//
//  Created by YanGuangZi on 2017/4/20.
//  Copyright © 2017年 YanGuangZi. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {
    
    @IBOutlet fileprivate var tableView: RSTableView!
    
    var canScroll = true
    var setCanScrollBlock: ((_ canScroll: Bool) -> Void)?
    /// 标志区分不同的控制器
    var mark = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SubViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mark
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

extension SubViewController: UIScrollViewDelegate {
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.y > 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if canScroll {
            setCanScrollBlock?(scrollView.contentOffset.y <= 0)
            if scrollView.contentOffset.y < 0 {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
}

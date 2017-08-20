//
//  MainViewController.swift
//  RecognizeSimultaneously
//
//  Created by YanGuangZi on 2017/4/5.
//  Copyright © 2017年 YanGuangZi. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {
    
    @IBOutlet private var scrollView: UIScrollView!
    
    private var viewControllers = [Int: UIViewController]()
    private var parentVC: MainViewController?
    private let childVCTitles = ["viewController1", "viewController2"]
    fileprivate var currentIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(setScrollStatus(_:)), name: Notification.Name(rawValue: "kSetMainCellCanScroll"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: contentView.frame.width * CGFloat(childVCTitles.count), height: 0)
        scrollView.setContentOffset(CGPoint(x: contentView.frame.width * CGFloat(currentIndex), y: 0), animated: false)
    }
    
    @objc private func setScrollStatus(_ notify: Notification) {
        if let canScroll = notify.userInfo?["canScroll"] as? Bool {
            for (_, value) in viewControllers {
                if let vc = value as? SubViewController {
                    vc.canScroll = canScroll
                }
            }
        }
    }
    
    fileprivate func viewAtIndex(_ index: Int) -> UIViewController {
        if let viewController = viewControllers[index] {
            return viewController
        } else {
            if index < childVCTitles.count {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubViewController") as? SubViewController {
                    viewController.view.frame = CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
                    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin]
                    viewController.canScroll = parentVC?.canScroll ?? true
                    viewController.setCanScrollBlock = {[weak self] canScroll in
                        self?.parentVC?.canScroll = canScroll
                    }
                    viewController.mark = index * 5 + 1
                    viewControllers[index] = viewController
                    parentVC?.addChildViewController(viewController)
                    return viewController
                }
            }
        }
        return UIViewController()
    }
    
    func updateCell(_ parentVC: MainViewController) {
        self.parentVC = parentVC
        scrollView.contentSize = CGSize(width: contentView.frame.width * CGFloat(childVCTitles.count), height: 0)
        scrollView.addSubview(viewAtIndex(currentIndex).view)
    }
    
}

extension MainCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newIndex = Int((scrollView.contentOffset.x + contentView.frame.width * 0.5) / contentView.frame.width)
        currentIndex = newIndex
        scrollView.addSubview(viewAtIndex(newIndex).view)
    }
    
}

class MainViewController: UIViewController {

    @IBOutlet private var tableView: RSTableView!
    
    fileprivate let tableHeaderHeight: CGFloat = 100 //子控制器切换栏
    fileprivate var canScroll = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
        headerView.backgroundColor = UIColor(white: 246 / 255, alpha: 1.0)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height - tableHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell {
            cell.updateCell(self)
            return cell
        }
        return UITableViewCell()
    }
    
}

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        return scrollView.contentOffset.y < floor(tableHeaderHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if canScroll {
            if scrollView.contentOffset.y >= floor(tableHeaderHeight) {
                scrollView.setContentOffset(CGPoint(x: 0, y: tableHeaderHeight), animated: false)
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "kSetMainCellCanScroll"), object: nil, userInfo: ["canScroll" : scrollView.contentOffset.y >= floor(tableHeaderHeight)])
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: tableHeaderHeight), animated: false)
        }
    }

}

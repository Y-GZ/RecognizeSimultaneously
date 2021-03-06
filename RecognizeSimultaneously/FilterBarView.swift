//
//  FilterBarView.swift
//  RecognizeSimultaneously
//
//  Created by YanGuangZi on 2017/8/20.
//  Copyright © 2017年 YanGuangZi. All rights reserved.
//

import UIKit

private var selfContext = 0
private var buttonContext = 1

class FilterBarView: UIView {
    
    fileprivate lazy var barLineView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.bounds.height - 2, width: 30, height: 2))
        view.backgroundColor = UIColor(red: 0 / 255, green: 168 / 255, blue: 255 / 255, alpha: 1.0)
        return view
    }()
    
    fileprivate var buttons = [UIButton]()
    fileprivate var observerTags = [Int]()
    private var titles = [String]()
    private var selectIndex = 0
    private var maxWidth: CGFloat = 0
    private var perfixCenterX: CGFloat = 0
    var selectBlock: ((_ index: Int) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, titles: [String]) {
        super.init(frame: frame)
        self.titles = titles
        createSubViews()
    }
    
    deinit {
        removeAllObserver()
    }
    
    //MARK: - Action
    private func createSubViews() {
        backgroundColor = UIColor(white: 245 / 255.0, alpha: 1.0)
        for i in 0...titles.count - 1 {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: bounds.width / CGFloat(titles.count) * CGFloat(i), y: 0, width: bounds.width / CGFloat(titles.count), height: bounds.height)
            button.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
            button.backgroundColor = UIColor.clear
            button.tag = 1000 + i
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1.0), for: .normal)
            button.setTitleColor(UIColor(red: 0 / 255, green: 168 / 255, blue: 255 / 255, alpha: 1.0), for: .selected)
            button.setTitleColor(UIColor(red: 0 / 255, green: 168 / 255, blue: 255 / 255, alpha: 1.0), for: [.highlighted, .selected])
            button.setTitle(titles[i], for: .normal)
            button.addTarget(self, action:#selector(buttonAction(_:)) , for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
            if i == selectIndex {
                button.isSelected = true
                addFrameObserve(button)
            }
        }
        addSubview(barLineView)
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        addFrameObserve(sender)
        selectIndex = max(sender.tag - 1000, 0)
        selectBlock?(selectIndex)
    }
    
    fileprivate func getPerWidth() {
        if let leftBtn = buttons.first, let rightBtn = buttons.last {
            maxWidth = max(rightBtn.center.x - leftBtn.center.x, 0)
            perfixCenterX = leftBtn.center.x
        }
    }
    
    private func addFrameObserve(_ sender: UIButton) {
        removeAllObserver()
        addObserver(self, forKeyPath: "frame", options: [.initial, .new], context: &selfContext)
        observerTags.append(999)
        sender.addObserver(self, forKeyPath: "frame", options: [.initial, .new], context: &buttonContext)
        observerTags.append(sender.tag)
    }
    
    func changeSelectIndex(_ index: Int) {
        for i in 0..<titles.count {
            if let button = viewWithTag(1000 + i) as? UIButton {
                if i == index {
                    button.isSelected = true
                    addFrameObserve(button)
                } else {
                    button.isSelected = false
                }
            }
        }
        selectIndex = index
    }
    
    func changeLineViewWithOffset(_ offset: CGFloat) {
        let realWidth = max(0, offset) * maxWidth / (max(CGFloat(titles.count - 1), 1) * bounds.width)
        barLineView.center.x = perfixCenterX + realWidth
    }
    
}

// MARK: - KVO
extension FilterBarView {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            if context == &buttonContext {
                if let value = change?[NSKeyValueChangeKey.newKey] as? CGRect {
                    self.barLineView.center.x = value.origin.x + (value.width / 2)
                }
            } else if context == &selfContext {
                self.getPerWidth()
            }
        }
    }
    
    fileprivate func removeAllObserver() {
        let tempTags = observerTags
        for tag in tempTags {
            if tag == 999 {
                removeObserver(self, forKeyPath: "frame")
                removeObserverForTag(tag)
            } else if let button = viewWithTag(tag) as? UIButton {
                button.removeObserver(self, forKeyPath: "frame")
                removeObserverForTag(tag)
            }
        }
    }
    
    private func removeObserverForTag(_ tag: Int) {
        for (index, item) in zip(0..<observerTags.count, observerTags) {
            if item == tag {
                observerTags.remove(at: index)
                break
            }
        }
    }
}

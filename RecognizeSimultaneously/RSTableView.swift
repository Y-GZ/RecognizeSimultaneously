//
//  RSTableView.swift
//  RecognizeSimultaneously
//
//  Created by YanGuangZi on 2017/4/17.
//  Copyright © 2017年 YanGuangZi. All rights reserved.
//

import UIKit

class RSTableView: UITableView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view is RSTableView {
            return true
        }
        return false
    }

}

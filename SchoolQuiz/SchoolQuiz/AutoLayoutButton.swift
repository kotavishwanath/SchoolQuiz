//
//  AutoLayoutButton.swift
//  SchoolQuiz
//
//  Created by Vishwanath Kota on 23/07/2020.
//  Copyright © 2020 VBCLimited. All rights reserved.
//

import UIKit

class AutoLayoutButton: UIButton {
    override var intrinsicContentSize: CGSize {
        var size = titleLabel!.sizeThatFits(CGSize(width: titleLabel!.preferredMaxLayoutWidth - contentEdgeInsets.left - contentEdgeInsets.right, height: .greatestFiniteMagnitude))
        size.height += contentEdgeInsets.left + contentEdgeInsets.right
        if (size.height <= 70) {
            size.height = 70
        }
        return size
    }
    override func layoutSubviews() {
        titleLabel?.preferredMaxLayoutWidth = frame.size.width
        super.layoutSubviews()
    }
}

//
//  Dug0ngStickyHeader.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/09.
//

import UIKit

class DugongStickyHeaderConfiguration {
    let headerMaxHeight: CGFloat
    let headerMinHeight: CGFloat
    let menuTabHeight: CGFloat
    var containerBackgroundColor: UIColor = .clear
    var selectedMenuTabItemUnderlineHeight: CGFloat = 2.5
    var selectedMenuTabItemUnderlineColor: UIColor = .black
    
    init(headerMaxHeight: CGFloat, headerMinHeight: CGFloat, menuTabHeight: CGFloat) {
        self.headerMaxHeight = headerMaxHeight
        self.headerMinHeight = headerMinHeight
        self.menuTabHeight = menuTabHeight
    }
}

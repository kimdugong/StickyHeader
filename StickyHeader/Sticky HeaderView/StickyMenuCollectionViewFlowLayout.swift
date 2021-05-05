//
//  MenuCollectionViewFlowLayout.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/05.
//

import UIKit

class StickyMenuCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    }
}

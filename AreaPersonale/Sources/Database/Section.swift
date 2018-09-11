//
//  Section.swift
//  Iliad
//
//  Created by Luigi Aiello on 29/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation

class Section {
    var name: String?
    var items: [ConsumptionDetail]
    var collapsed: Bool

    init(name: String?, items: [ConsumptionDetail], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

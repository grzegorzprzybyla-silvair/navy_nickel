//
//  Array+SizeOf.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła(S) on 23/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import Foundation

extension Array {
    func sizeOf() -> Int {
        guard count > 0 else { return 0 }
        let itemSize = MemoryLayout.size(ofValue: self[0])
        return count * itemSize
    }
}

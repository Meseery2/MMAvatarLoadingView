//
//  MMDataCache.swift
//  MMAvatarLoadingView
//
//  Created by Mohamed EL Meseery on 7/21/18.
//

import Foundation

class MMDataCache : NSCache<NSString, NSData> {
    init(maximumNumberOfObjects:Int,
         maximumDiskStorage:Int) {
        super.init()
        self.countLimit = maximumNumberOfObjects
        self.totalCostLimit = maximumDiskStorage
    }
}

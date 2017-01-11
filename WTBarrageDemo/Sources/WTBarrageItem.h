//
//  WTBarrageItem.h
//  BarrageDemo
//
//  Created by ben on 2017/1/5.
//  Copyright © 2017年 ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBarrageContent.h"

@class WTBarrageItem;
typedef void(^WTBarrageItemFinishedBlock)(WTBarrageItem* item);
@interface WTBarrageItem : UIView
+ (instancetype)barrageItemWithContent:(WTBarrageContent*)content;
- (void)animate:(WTBarrageItemFinishedBlock)block;
@end

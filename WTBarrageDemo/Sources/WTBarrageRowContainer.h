//
//  WTBarrageRowContainer.h
//  BarrageDemo
//
//  Created by ben on 2017/1/5.
//  Copyright © 2017年 ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBarrageItem.h"

typedef WTBarrageContent *(^WTBarrageRowContainerBlock)();

@interface WTBarrageRowContainer : UIView
@property (nonatomic,copy) WTBarrageRowContainerBlock rowContainerBlock;

- (void)start;

- (void)stop;
@end

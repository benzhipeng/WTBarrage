//
//  WTBarrageContainer.h
//  BarrageDemo
//
//  Created by ben on 2017/1/5.
//  Copyright © 2017年 ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBarrageRowContainer.h"

@interface WTBarrageContainer : UIView



- (void)insertBarrages:(NSArray*)barrages;

- (void)start;

- (void)stop;
@end

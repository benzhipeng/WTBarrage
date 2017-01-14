//
//  WTBarrageContent.h
//  BarrageDemo
//
//  Created by ben on 2017/1/11.
//  Copyright © 2017年 ben. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface WTBarrageContent : NSObject
@property (nonatomic,copy) NSString* avatar;
@property (nonatomic,strong) UIImage* avatarPlaceHolder;
@property (nonatomic,strong) UIImage* trailImage;
@property (nonatomic,strong) NSMutableAttributedString* content;
@end

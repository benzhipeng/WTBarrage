//
//  ViewController.m
//  BarrageDemo
//
//  Created by ben on 2017/1/5.
//  Copyright © 2017年 ben. All rights reserved.
//

#import "ViewController.h"
#import "WTBarrageContainer.h"
#import "Masonry.h"
#import "WTBarrageItem.h"
@interface ViewController (){
    NSInteger index;
}
@property (strong, nonatomic) WTBarrageContainer *barrageContainer;
@property (strong, nonatomic) NSTimer*  timer;
@property (strong, nonatomic) NSMutableArray*     barrages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.barrages = [NSMutableArray arrayWithCapacity:0];
    
    self.barrageContainer = ({
       
        WTBarrageContainer* view = [[WTBarrageContainer alloc] init];
        [self.view addSubview:view];
        view;
    });
    
    [self.barrageContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.mas_equalTo(0);
        make.height.mas_equalTo(98);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
     self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}


- (void)refresh{

    
    NSString* barrage = @"离岸人民币隔夜存款利率飙升至纪录高点80%";
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    for(NSInteger i = 0;i < 10; i++){
        
        NSString* tmp = [barrage substringToIndex:arc4random() % (barrage.length)];
        WTBarrageContent* barrage = [[WTBarrageContent alloc] init];
        barrage.avatar = @"http://xq.139life.com/images/16.jpg";
        barrage.avatarPlaceHolder = [UIImage imageNamed:@"avatar"];
        barrage.trailImage = [UIImage imageNamed:@"fengche"];
        barrage.content = [[NSMutableAttributedString alloc] initWithString:tmp];
        [array addObject:barrage];
    }
    [self.barrageContainer insertBarrages:array];
   
    
//    UIView* view =  [self.barrageContainer.subviews lastObject];
//    if(view && [view isKindOfClass:[WTBarrageItem class]]){
//        
//        
//
//    }else {
//    }
    
    
//    index++;
//    UIView* view = [self.barrageContainer viewWithTag:index - 1];
//    
//
//
//    if([view isKindOfClass:[WTBarrageItem class]]){
//
//
//        NSLog(@"%f",x);
//    }
//    item.tag = index;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

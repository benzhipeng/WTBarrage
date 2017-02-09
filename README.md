最近在做直播这块方面的内容，然后有个弹幕的需求需要我们实现一下。一开始为了图方便就直接使用了一个第三方的库BarrageRenderer，star数目也比较多，用起来也挺方便，唯一的不好的地方就是定制弹幕的灵活性不是很强，但是用在项目里已经足够了。大概的效果如下：![](https://ww1.sinaimg.cn/large/006tKfTcgy1fckaismzx3j30d6046dg9.jpg)

但是这种效果有个不好的地方，就是弹幕之间有遮挡，产品说这样不行，需要改进。两种方案，第一是动源码，第二就是自己写一个。尝试了第一种方案之后发现可执行性不是很高，而且周期比较长。为了后面的可扩展性就索性自己写一个吧。
弹幕的主要构成如图:
![](https://ww4.sinaimg.cn/large/006tKfTcgy1fckairvffdj30h405sq3g.jpg)

弹幕由一个大的container包着，每一行都是一个rowContainer,大的container的高度由row数目来决定，弹幕item是在rowContainer里面显示的。使用的时候只需要初始化WTBarrageContainer就行了。

## WTBarrageContainer

```objective-c
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.barrages = [NSMutableArray arrayWithCapacity:0];
        self.barrageQueue = dispatch_queue_create(nil, nil);
        
        self.row1 = ({
            WTBarrageRowContainer* view = [[WTBarrageRowContainer alloc] init];
            [self addSubview:view];
            view;
        });
        
        self.row2 = ({
            WTBarrageRowContainer* view = [[WTBarrageRowContainer alloc] init];
            [self addSubview:view];
            view;
        });
        
        
        [self.row1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.and.top.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        
        [self.row2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.mas_equalTo(0);
            make.top.mas_equalTo(self.row1.mas_bottom).offset(10);
            make.height.mas_equalTo(44);
        }];
        
  
        __weak __typeof(self)weakSelf = self;
        self.row1.rowContainerBlock = ^WTBarrageContent*() {
        
            WTBarrageContent* barrage = [weakSelf getBarrage];
            if(!barrage){
                return nil;
            }
            dispatch_barrier_sync(weakSelf.barrageQueue, ^{
                [weakSelf.barrages removeObject:barrage];
            });
            return barrage;
        };
        
        self.row2.rowContainerBlock = ^WTBarrageContent*() {
            
            WTBarrageContent* barrage = [weakSelf getBarrage];
            if(!barrage){
                return nil;
            }
            dispatch_barrier_sync(weakSelf.barrageQueue, ^{
                [weakSelf.barrages removeObject:barrage];
            });
            return barrage;
        };
        
        [self start];
    }
    return self;
}
```

​        
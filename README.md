# countLabel
可以动态的显示增加的数值
#属性说明
```
@property (nonatomic, assign) NSTimeInterval allTime; //运行总共所需时间
@property (nonatomic, assign) CGFloat num;            //所需运行到的数字
@property (nonatomic, assign) TimingFunction timingFunction;//运行方式
@property (nonatomic, assign) TimingMode timingMode;      //最小单位
```
```
- (void)start;   //开始运行
- (void)startWithCompletionBlock:(void(^)(void))completionBlock; //开始运行 附带运行结束后回调的block
```

#使用说明
```objective-c
    #import "testViewController.h"
    #import "AmountAnimationLabel.h"

    @interface testViewController ()<>
    {
    AmountAnimationLabel *_label;
    }

    @end

    @implementation ViewController

    @end
    
    _label = [[AmountAnimationLabel alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
    _label.num =20;
    _label.allTime = 10;
    _label.timingFunction = TimingFunctionDefault;
    _label.timingMode = TimingOnePercentMode;
    [self.view addSubview:_label];
    
    [_label start];
```
![1111](https://github.com/GithubChinaCH/countLabel/raw/master/111111.gif)

//
//  XZCustomCameraWaterView.m
//  WaterCamera
//
//  Created by LuckyXYJ on 2023/3/2.
//

#import "XZCustomCameraWaterView.h"
#import "XZCustomWaterTopView.h"
#import "XZCustomWaterContentView.h"
#import "XZCameraHeader.h"

@interface XZCustomCameraWaterView()

@property(nonatomic, strong)XZCustomWaterTopView *topView;

@property(nonatomic, strong)NSMutableArray *contentArray;

@property(nonatomic, strong)NSDictionary *data;
@property(nonatomic, assign)BOOL isNormer;
@end
@implementation XZCustomCameraWaterView

- (instancetype)init{
    if(self = [super init]){
        _contentArray = [NSMutableArray array];
        [self ui_config];
    }
    
    return self;
}

- (void)ui_config {

    self.backgroundColor = XZRGBACOLOR(0x333333, 0.4);
    
    XZCustomWaterTopView *topView = [[XZCustomWaterTopView alloc]init];
    [self addSubview:topView];
    _topView = topView;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)event:(UITapGestureRecognizer *)gesture {
    if (_waterViewTap) {
        _waterViewTap();
    }
}

- (void)showWaterWithDetail:(id)detail {
    [self showWaterWithDetail:detail isNormer:NO];
}

- (void)showWaterWithDetail1:(id)detail isNormer:(BOOL)isNormer {
    
    NSDictionary *dict = (NSDictionary *)detail;
    
    self.data = dict;
    
    _isNormer = isNormer;
}

- (void)showWaterWithDetail:(id)detail isNormer:(BOOL)isNormer {
    
    NSDictionary *dict = (NSDictionary *)detail;
    
    self.backgroundColor = XZRGBCOLOR(isNormer?0x213979:0x3333334E);
    
    self.topView.frame = CGRectMake(0, 0, self.width, 33);
    [self.topView showViewData:(NSDictionary *)detail];
    
    NSString *type = [dict XZ_stringForKey:@"type"];
    NSArray *formItems = [dict XZ_arrayForKey:@"formItem"];
    NSArray *checkedList = [dict XZ_arrayForKey:@"checkedList"];
    NSDictionary *data = [dict XZ_dicForKey:@"data"];
    
    
    CGFloat top = self.topView.bottomY + 8;
    
    int viewIndex = 0;
    
    for (int i = 0; i<formItems.count; i++) {
        NSDictionary *item = formItems[i];
        
        if ([checkedList containsObject:[item XZ_stringForKey:@"dataKey"]]) {
            
            NSMutableDictionary *infoItem = [NSMutableDictionary dictionary];
            
            [infoItem setObject:[item XZ_stringForKey:@"label"] forKey:@"title"];
            
            [infoItem setObject:[self contentOfData:data withFormItem:item andType:type] forKey:@"content"];
            
            XZCustomWaterContentView *contentView;
            if (viewIndex < _contentArray.count) {
                contentView = _contentArray[viewIndex];
            }else {
                contentView = [[XZCustomWaterContentView alloc]init];
                [self addSubview:contentView];
                [_contentArray addObject:contentView];
            }
            viewIndex ++;
            contentView.frame = CGRectMake(0, top, self.width, 17);
            [contentView showViewData:infoItem];
            contentView.hidden = NO;
            top = contentView.bottomY + 3;
        }
    }
    
    top = top + 5;
    
    for (int i = viewIndex; i < _contentArray.count; i++) {
        XZCustomWaterContentView *contentView = _contentArray[i];
        contentView.hidden = YES;
    }
    
    CGFloat space = top - self.height;
    
    if (!isNormer) {
        self.frame = CGRectMake(self.originX, (self.originY - space), self.width, top);
    }else {
        if (top < self.superview.height) {
            self.frame = CGRectMake(self.originX, (self.superview.height - top)/2, self.width, top);
        }else {
            self.frame = CGRectMake(self.originX, 0, self.width, top);
        }
    }
//    self.frame = CGRectMake(self.originX, isNormer?0:(self.originY - space), self.width, top);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
}


- (NSString *)contentOfData:(NSDictionary *)data withFormItem:(NSDictionary *)formItem andType:(NSString *)type{
    
    NSString *comType = [formItem XZ_stringForKey:@"comType"];
    NSString *dataKey = [formItem XZ_stringForKey:@"dataKey"];
    NSString *nameKey = [formItem XZ_stringForKey:@"nameKey"];
    NSString *placeholder = [formItem XZ_stringForKey:@"placeholder"];
    
    NSObject *obj = [data objectForKey:dataKey];
    if (!obj) {
        return placeholder;
    }
    
    if([comType isEqualToString:@"currentDate"]) {
        NSString *timestamp = [data XZ_stringForKey:dataKey];
        if (timestamp.length > 0) {
            NSDate *date = [NSDate dateWithTimestampString:[data XZ_stringForKey:dataKey]];
            if ([type isEqualToString:@"attendance"]) {
                return [date stringWithFormat:@"yyyy-MM-dd"];
            }
            return [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
        }
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString*)obj;
    }else if([obj isKindOfClass:[NSDictionary class]]){
        return [(NSDictionary *)obj XZ_stringForKey:nameKey];
    }else {
        return placeholder;
    }
}

@end

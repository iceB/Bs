//
//  YPToastView.m
//  课程设计-3D导航
//
//  Created by xingyukun on 16/5/14.
//  Copyright © 2016年 iceB. All rights reserved.
//

#import "YPToastView.h"
#import "Masonry.h"

@implementation YPToastView
@synthesize beacon1;
@synthesize beacon2;
@synthesize altLabel;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}
-(void)initUI{
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"设备列表";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor grayColor];
    [self addSubview:label1];
    
    beacon1 = [[UILabel alloc]init];
    beacon1.text = @"设备ID:0 RSSI:0";
    beacon1.font = [UIFont systemFontOfSize:14];
    beacon1.textAlignment = NSTextAlignmentLeft;
    beacon1.textColor = [UIColor blackColor];
    [self addSubview:beacon1];
    
    beacon2 = [[UILabel alloc]init];
    beacon2.text = @"设备ID:0 RSSI:0";
    beacon2.font = [UIFont systemFontOfSize:14];
    beacon2.textAlignment = NSTextAlignmentLeft;
    beacon2.textColor = [UIColor blackColor];
    [self addSubview:beacon2];
    
    UILabel *beacon3 = [[UILabel alloc]init];
    beacon3.text = @"设备ID:0 RSSI:0";
    beacon3.font = [UIFont systemFontOfSize:14];
    beacon3.textAlignment = NSTextAlignmentLeft;
    beacon3.textColor = [UIColor blackColor];
    [self addSubview:beacon3];
    
    altLabel = [[UILabel alloc]init];
    altLabel.textAlignment = NSTextAlignmentLeft;
    altLabel.textColor = [UIColor redColor];
    altLabel.font = [UIFont systemFontOfSize:20];
    altLabel.text = @"当前海拔高度:0 楼层：0";
    [self addSubview:altLabel];
    
    __weak __typeof(&*self)ws = self;
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top).offset(3);
        make.left.equalTo(ws.mas_left).offset(8);
    }];
    
    [beacon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(15);
        make.left.equalTo(label1.mas_left);
    }];
    
    [beacon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beacon1);
        make.top.equalTo(beacon1.mas_bottom).offset(10);
    }];
    
    [beacon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beacon1);
        make.top.equalTo(beacon2.mas_bottom).offset(10);
    }];
    
    [altLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beacon1.mas_left);
        make.top.equalTo(beacon3.mas_bottom).offset(40);
    }];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
@end

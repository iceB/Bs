//
//  YPDormMapView.m
//  课程设计-3D导航
//
//  Created by xingyukun on 16/5/12.
//  Copyright © 2016年 iceB. All rights reserved.
//

#import "YPDormMapView.h"
//#import "Masonry.h"
#import "UIColor+extend.h"

@implementation YPDormMapView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bathView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 135, 175)];
        bathView.backgroundColor = [UIColor hexChangeFloat:@"DC143C"];
        [self addSubview:bathView];

        UILabel *bathLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        bathLabel.textAlignment = NSTextAlignmentLeft;
        bathLabel.textColor = [UIColor blackColor];
        bathLabel.font = [UIFont systemFontOfSize:16];
        bathLabel.text = @"卫生间";
        [bathView addSubview:bathLabel];
        
        washView = [[UIView alloc]initWithFrame:CGRectMake(233, 0, 107, 175)];
        washView.backgroundColor = [UIColor hexChangeFloat:@"C71585"];
        [self addSubview:washView];
        UILabel *washLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        washLabel.textAlignment = NSTextAlignmentLeft;
        washLabel.textColor = [UIColor blackColor];
        washLabel.font = [UIFont systemFontOfSize:16];
        washLabel.text = @"洗漱台";
        [washView addSubview:washLabel];
        
        bed1 = [[UIView alloc]initWithFrame:CGRectMake(0, 175, 84, 195)];
        bed1.backgroundColor = [UIColor hexChangeFloat:@"4165E1"];
        [self addSubview:bed1];
        UILabel *bed1Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        bed1Label.textAlignment = NSTextAlignmentLeft;
        bed1Label.textColor = [UIColor blackColor];
        bed1Label.font = [UIFont systemFontOfSize:16];
        bed1Label.text = @"床位1";
        [bed1 addSubview:bed1Label];
        
        bed2 = [[UIView alloc]initWithFrame:CGRectMake(0, 370, 84, 195)];
        bed2.backgroundColor = [UIColor hexChangeFloat:@"6495ED"];
        [self addSubview:bed2];
        UILabel *bed2Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        bed2Label.textAlignment = NSTextAlignmentLeft;
        bed2Label.textColor = [UIColor blackColor];
        bed2Label.font = [UIFont systemFontOfSize:16];
        bed2Label.text = @"床位2";
        [bed2 addSubview:bed2Label];
         
        bed3 = [[UIView alloc]initWithFrame:CGRectMake(256, 175, 84, 195)];
        bed3.backgroundColor = [UIColor hexChangeFloat:@"B0E0E6"];
        [self addSubview:bed3];
        UILabel *bed3Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        bed3Label.textAlignment = NSTextAlignmentLeft;
        bed3Label.textColor = [UIColor blackColor];
        bed3Label.font = [UIFont systemFontOfSize:16];
        bed3Label.text = @"床位3";
        [bed3 addSubview:bed3Label];
        
        bed4 =[[UIView alloc]initWithFrame:CGRectMake(256, 370, 84, 195)];
        bed4.backgroundColor = [UIColor hexChangeFloat:@"5F9EA0"];
        [self addSubview:bed4];
        UILabel *bed4Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        bed4Label.textAlignment = NSTextAlignmentLeft;
        bed4Label.textColor = [UIColor blackColor];
        bed4Label.font = [UIFont systemFontOfSize:16];
        bed4Label.text = @"床位4";
        [bed4 addSubview:bed4Label];

        NSInteger x =arc4random()%340;
        NSInteger y =arc4random()%600;
        
        positionView = [[UIView alloc]initWithFrame:CGRectMake(x, y, 24, 24)];
        positionView.backgroundColor = [UIColor hexChangeFloat:@"00Bfff"];
        positionView.layer.cornerRadius = 12;
        positionView.layer.borderWidth = 2;
        positionView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:positionView];
        
        UIView *door = [[UIView alloc]initWithFrame:CGRectMake(140, 590, 60, 10)];
        door.backgroundColor = [UIColor greenColor];
        [self addSubview:door];
    }
    return self;
}

-(void)setPostionCoordinate:(CGPoint)point{
    CGRect frame1 = positionView.frame;
    frame1.origin = point;
    positionView.frame = frame1;
    [self layoutIfNeeded];
}
@end

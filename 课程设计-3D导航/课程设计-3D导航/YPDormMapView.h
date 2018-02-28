//
//  YPDormMapView.h
//  课程设计-3D导航
//
//  Created by xingyukun on 16/5/12.
//  Copyright © 2016年 iceB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPDormMapView : UIView
{
    UIView * bed1;
    UIView * bed2;
    UIView * bed3;
    UIView * bed4;
    UIView * bathView;
    UIView * washView;
    UIView * positionView;
}
-(void)setPostionCoordinate:(CGPoint)point;
@end

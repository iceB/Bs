//
//  YPDormMapViewController.h
//  课程设计-3D导航
//
//  Created by xingyukun on 16/5/12.
//  Copyright © 2016年 iceB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "Fingerprin.h"

@class YPDormMapView;
@interface YPDormMapViewController : UIViewController
{
    int rssi1[5],rssi2[5];//五个相临点

    YPDormMapView  *dormView;
    NSTimer *timer;

    NSMutableArray *rssi1Array;
    NSMutableArray *rssi2Array;
    Fingerprin     *rssiFingerprin; //指纹
    NSMutableArray *fpArray; //指纹数组
    NSMutableArray *distanceArray; //距离数组
    
}
@property(nonatomic,strong)FMDatabase *db;
@property(nonatomic,assign)BOOL isDataRefresh;
@property(nonatomic,assign)NSInteger beacon1Rssi; //滤波数组1
@property(nonatomic,assign)NSInteger beacon2Rssi; //滤波数组2


@end


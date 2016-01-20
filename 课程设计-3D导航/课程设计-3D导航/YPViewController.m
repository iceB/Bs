//
//  YPViewController.m
//  课程设计-3D导航
//
//  Created by Etouch on 16/1/20.
//  Copyright © 2016年 iceB. All rights reserved.
//
#import "YPViewController.h"
#import "SBKBeacon.h"
#import "SBKBeaconManager.h"
#import "SBKBeaconManager+Cloud.h"

@interface YPViewController ()
{
    SBKBeacon * sb;
}
@end

@implementation YPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*初始化UUID*/
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23A01AF0-232A-4518-9C0E-323FB773F5EF"];
    SBKBeaconID *beaconID = [SBKBeaconID beaconIDWithProximityUUID:uuid];
    
    /* 设置云子防蹭用密钥 (如果没有可以不设置) */
//    [[SBKBeaconManager sharedInstance]addBroadcastKey:@"01Y2GLh1yw3+6Aq0RsnOQ8xNvXTnDUTTLE937Yedd/DnkHESUpvQ7YvLucs9YfwGR5R/jwW8Rqp9XtGbmwbKXzXQ=="];
    
    /*开始扫描*/
    [[SBKBeaconManager sharedInstance] startRangingBeaconsWithID:beaconID
                                               wakeUpApplication:NO];
    /*申请权限*/
    [[SBKBeaconManager sharedInstance] requestAlwaysAuthorization];
    
    /* 设置启用云服务 (上传传感器数据，如电量、UMM等)。如果不设置，默认为关闭状态。*/
    [[SBKBeaconManager sharedInstance] setCloudServiceEnable:YES];
    
    [SBKBeaconManager sharedInstance].delegate = self;

    sb = [[SBKBeacon alloc]init];
    sb.delegate = self;
    
}
- (void)beaconManager:(SBKBeaconManager *)beaconManager didRangeNewBeacon:(SBKBeacon *)beacon{
    
}

/* 传感器设备离开 */
- (void)beaconManager:(SBKBeaconManager *)beaconManager beaconDidGone:(SBKBeacon *)beacon{
    
}

/* 每秒返回还在范围内的传感器设备 */
- (void)beaconManager:(SBKBeaconManager *)beaconManager scanDidFinishWithBeacons:(NSArray *)beacons{
    
}

/* 传感器设备信号强度变化*/
- (void)sensoroBeacon:(SBKBeacon *)beacon didUpdateRSSI:(NSInteger)rssi{
    NSLog(@"%ld",rssi);

}

/* 传感器设备温度变化*/
- (void)sensoroBeacon:(SBKBeacon *)beacon didUpdateTemperatureData:(NSNumber *)temperature{
    
}

/* 传感器设备移动计数器数值变化*/
- (void)sensoroBeacon:(SBKBeacon *)beacon didUpdateAccelerometerCount:(NSNumber *)accelerometerCount{
    
}

/* 传感器设备移动状态变化*/
- (void)sensoroBeacon:(SBKBeacon *)beacon didUpdateMovingState:(NSNumber *)isMoving{
    
    
}


@end

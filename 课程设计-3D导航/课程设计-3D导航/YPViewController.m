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
    [SBKBeaconManager sharedInstance].delegate = self;
    NSLog(@"%@",[SBKBeaconManager sharedInstance].version);
    
    sb = [[SBKBeacon alloc]init];
    sb.delegate = self;
    
}

-(BOOL)checkLocationServices
{
    if (!self.locationManager) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=100.0f;
    }
    
    BOOL enable=[CLLocationManager locationServicesEnabled];//定位服务是否可用
    
    int status=[CLLocationManager authorizationStatus];//是否具有定位权限
    if(!enable || status<3){
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
            [self.locationManager requestAlwaysAuthorization];//请求权限
        }
        return NO;//需求请求定位权限
        
    }
    return YES;
}
-(BOOL)checkBluetoothServices
{
    if (!self.CM) {
        self.CM = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    if (self.CM.state == CBCentralManagerStatePoweredOff) {
        return NO;
    }
    else if(self.CM.state == CBCentralManagerStatePoweredOn){
        return YES;
    }
    return YES;
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}

#pragma mark - delegate

- (void)beaconManager:(SBKBeaconManager *)beaconManager didRangeNewBeacon:(SBKBeacon *)beacon{
    
}
-(void)beacon:(SBKBeacon *)beacon{
    
}
/* 传感器设备离开 */
- (void)beaconManager:(SBKBeaconManager *)beaconManager beaconDidGone:(SBKBeacon *)beacon{
    
}

/* 每秒返回还在范围内的传感器设备 */
- (void)beaconManager:(SBKBeaconManager *)beaconManager scanDidFinishWithBeacons:(NSArray *)beacons{
    if(beacons.count>0){
        SBKBeacon *beacon = beacons[0];
        NSLog(@"%d,距离：%f",(int)beacon.rssi,beacon.accuracy);
    }
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

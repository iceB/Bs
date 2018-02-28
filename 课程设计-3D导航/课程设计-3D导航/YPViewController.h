//
//  YPViewController.h
//  课程设计-3D导航
//
//  Created by Etouch on 16/1/20.
//  Copyright © 2016年 iceB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBKBeaconManager.h"
#import "FMDB.h"
#import "iToast.h"

@interface YPViewController : UIViewController<SBKBeaconManagerDelegate,SBKBeaconDelegate,CBCentralManagerDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
{
    NSInteger real1Rssi,UID1,real2Rssi,UID2;
    NSInteger X;
    NSInteger Y;
    NSMutableArray    *Beacon1RssiArray;
    NSMutableArray    *Beacon2RssiArray;
    BOOL      beginRecive;
    BOOL      writeToDb;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CBCentralManager  *CM;
@end

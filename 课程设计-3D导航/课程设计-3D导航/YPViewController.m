//
//  YPViewController.m
//  课程设计-3D导航
//
//  Created by Etouch on 16/1/20.
//  Copyright © 2016年 iceB. All rights reserved.
//
#import "YPViewController.h"
#import "YPDormMapViewController.h"
#import "SBKBeacon.h"
#import "SBKBeaconManager.h"
#import "SBKBeaconManager+Cloud.h"
#import "Masonry.h"
#import "FMDB.h"
#import "UIColor+extend.h"
#import <CoreLocation/CoreLocation.h>
#import "YPToastView.h"
#import <math.h>


#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"Rssi.sqlite"
#define PI 3.1415927

@interface YPViewController ()
{
    SBKBeacon   *sb;
    UIButton    *bottomBtn;
    FMDatabase  *db;
    UITextField *xField;
    UITextField *yField;
    CLLocation  *location;
    YPToastView *tostVeiw;
    NSInteger current1Rssi,current2Rssi;
    YPDormMapViewController * dormVc;
}
@end

@implementation YPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*初始化UUID*/
    [SBKBeaconManager sharedInstance].delegate = self;
    sb = [[SBKBeacon alloc]init];
    sb.delegate = self;
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 0;
    [_locationManager startUpdatingLocation];
    
    Beacon1RssiArray = [[NSMutableArray alloc]init];
    Beacon2RssiArray = [[NSMutableArray alloc]init];
    
    [self initUI];
    NSLog(@"%@",dataBasePath);
    db = [FMDatabase databaseWithPath:dataBasePath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }else if ([db tableExists:@"beaconsRecord"]){
        NSLog(@"tabel exists");
    }else{
        [db executeUpdate:@"CREATE TABLE 'beaconsRecord' ('index_id' integer, 'aixs_x' integer, 'aixs_y' integer, 'iBeacon1_id' integer, 'beacon1Rssi' integer,'iBeacon2_id' integer, 'beacon2Rssi' integer)"];
    }
    
}

-(void)initUI{
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:textLabel];
    
    UILabel *xLabel = [[UILabel alloc]init];
    xLabel.textAlignment = NSTextAlignmentLeft;
    xLabel.textColor = [UIColor blackColor];
    xLabel.font = [UIFont systemFontOfSize:20];
    xLabel.text = @"X:";
    [self.view addSubview:xLabel];
    
    UILabel *yLabel = [[UILabel alloc]init];
    yLabel.textAlignment = NSTextAlignmentLeft;
    yLabel.textColor = [UIColor blackColor];
    yLabel.font = [UIFont systemFontOfSize:20];
    yLabel.text = @"Y:";
    [self.view addSubview:yLabel];
    
    xField = [[UITextField alloc] init];
    xField.backgroundColor = [UIColor whiteColor];
    xField.delegate = self;
    xField.keyboardType = UIKeyboardTypeNumberPad;
    xField.textColor = [UIColor hexChangeFloat:@"e55051"];
    xField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:xField];
    
    yField = [[UITextField alloc] init];
    yField.backgroundColor = [UIColor whiteColor];
    yField.delegate = self;
    yField.keyboardType = UIKeyboardTypeNumberPad;
    yField.textColor = [UIColor hexChangeFloat:@"e55051"];
    yField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:yField];
    
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.backgroundColor = [UIColor whiteColor];
    [recordBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [recordBtn setTag:2];
    recordBtn.layer.cornerRadius = 8;
    recordBtn.layer.borderColor  = [UIColor brownColor].CGColor;
    recordBtn.layer.borderWidth  = 2;
    [recordBtn setTitle:@"记录到数据库" forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [self.view addSubview:recordBtn];
    
    tostVeiw = [[YPToastView alloc]init];
    [self.view addSubview:tostVeiw];
    
    __weak __typeof(&*self)ws = self;
    [xField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(90);
        make.left.equalTo(ws.view.mas_left).offset(40);
        make.right.equalTo(yField.mas_left).offset(-40);
        make.height.equalTo(@40);
        make.width.equalTo(yField.mas_width);
    }];
    
    [yField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(90);
        make.left.equalTo(xField.mas_right).offset(40);
        make.right.equalTo(ws.view.mas_right).offset(-40);
        make.height.equalTo(@40);
        make.width.equalTo(xField.mas_width);

    }];
    
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xField.mas_bottom).offset(20);
        make.left.equalTo(xField.mas_left).offset(0);
        make.right.equalTo(yField.mas_right).offset(0);
        make.height.equalTo(@70);
    }];
    
    [xLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(xField.mas_left).offset(-8);
        make.centerY.equalTo(xField.mas_centerY).offset(0);
    }];
    
    [yLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yField.mas_left).offset(-8);
        make.centerY.equalTo(yField.mas_centerY).offset(0);
    }];
    
    [tostVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recordBtn.mas_bottom).offset(20);
        make.left.equalTo(ws.view).offset(0);
        make.right.equalTo(ws.view).offset(0);
        make.bottom.equalTo(ws.view).offset(0);
    }];
    
    bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(300, 587, 60, 60);
    [bottomBtn addTarget:self action:@selector(mapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bottomBtn setTitle:@"定位" forState:UIControlStateNormal];
    bottomBtn.backgroundColor = [UIColor brownColor];
    bottomBtn.tag = 1;
    bottomBtn.layer.cornerRadius = 30;
    bottomBtn.layer.masksToBounds = YES;
    [self.view addSubview:bottomBtn];
    
    

    
}

-(void)btnClick:(UIButton *)sender{
    if (sender.tag == 2) {
        [xField resignFirstResponder];
        [yField resignFirstResponder];
        
        [[[iToast makeText:@"开始记录"] setGravity:iToastGravityTop] show];
        X = xField.text.integerValue;
        Y = yField.text.integerValue;
        writeToDb = YES;
        beginRecive = YES;
        
    }
}

-(void)deleteTableData{
    if ([db executeUpdate:@"DELETE FROM RssiList"]) {
        
    }else{
        NSLog(@"fail to clear");
    }
}
-(void)mapBtnClick:(UIButton *)sender{
    if (beginRecive) {
        [[[iToast makeText:@"正在采集数据，请稍后"] setGravity:iToastGravityCenter] show];
    }
    dormVc = [[YPDormMapViewController alloc]init];
    dormVc.db = db;
    dormVc.beacon1Rssi = current1Rssi;
    dormVc.beacon2Rssi = current2Rssi;
    [self.navigationController pushViewController:dormVc animated:YES];
    
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

#pragma mark - locationDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (locations.count>0) {
        location = locations[0];
        NSString *altStr = [NSString stringWithFormat:@"当前海拔高度:%f 楼层高度：%zd",location.altitude,location.floor.level];
        tostVeiw.altLabel.text = altStr;
        NSLog(@"海拨高度%f,楼层%zd",location.altitude,location.floor.level);
    }
    
}

#pragma mark - beacondelegate
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
        SBKBeacon *beacon1 = beacons[0];
        NSString *str1 = [NSString stringWithFormat:@"设备ID:%zd , RSSI:%zd",[beacon1.beaconID.major integerValue],beacon1.rssi];
        tostVeiw.beacon1.text =str1;
       
        NSLog(@"%@",str1);
        
        //11141 16717
        SBKBeacon *beacon2;
        
        if (beacons.count>1) {
            beacon2 = beacons[1];
            
            NSString *str2 = [NSString stringWithFormat:@"设备ID:%zd , RSSI:%zd",[beacon2.beaconID.major integerValue],beacon2.rssi];
            tostVeiw.beacon2.text =str2;
            NSLog(@"%@",str2);
        }
        if ([beacon1.beaconID.major integerValue] == 11141) {
          
        }else{
            //交换指针
            SBKBeacon *temp;
            temp = beacon1;
            beacon1 = beacon2;
            beacon2 = temp;
        }
        //需传入定位需要的数据
        if (dormVc) {
            dormVc.beacon1Rssi = beacon1.rssi;
            dormVc.beacon2Rssi = beacon2.rssi;
            dormVc.isDataRefresh = YES;
        }
        
        
        if (beginRecive) {
            
            [Beacon1RssiArray addObject:[NSNumber numberWithInteger:beacon1.rssi]];

            if (Beacon1RssiArray.count == 30) {
                real1Rssi = [self fliterRssi:Beacon1RssiArray];
                UID1 = [beacon1.beaconID.major integerValue];
            }
            
            [Beacon2RssiArray addObject:[NSNumber numberWithInteger:beacon2.rssi]];
            
            if (Beacon2RssiArray.count == 30) {
                real2Rssi = [self fliterRssi:Beacon2RssiArray];
                UID2 = [beacon2.beaconID.major integerValue];
            }
            //数据库写入
            if (Beacon2RssiArray.count >= 30 && Beacon1RssiArray.count >= 30) {
                    NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:@"index_id"];
                    NSInteger index_id = [index integerValue];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:index_id+1] forKey:@"index_id"];
                    if ([db open]) {
                    
                    [db executeUpdate:@"INSERT INTO 'beaconsRecord' ('index_id', 'aixs_x','aixs_y','iBeacon1_id','beacon1Rssi','iBeacon2_id','beacon2Rssi') VALUES (?,?,?,?,?,?,?)",[NSNumber numberWithInteger: index_id], [NSNumber numberWithInteger: X], [NSNumber numberWithInteger: Y], [NSNumber numberWithInteger: UID1], [NSNumber numberWithInteger: real1Rssi], [NSNumber numberWithInteger: UID2], [NSNumber numberWithInteger: real2Rssi]];
                        //写入后清除数据
                        [Beacon2RssiArray removeAllObjects];
                        [Beacon1RssiArray removeAllObjects];
                        beginRecive = NO;
                        [[[iToast makeText:@"采集完成，可以采集下一组了"] setGravity:iToastGravityCenter] show];
                    }
            }
        }
    }
}

//滤波处理
-(NSInteger)fliterRssi:(NSMutableArray*)rssiArray{
    
    NSInteger sum = 0;
    for (NSNumber *number in rssiArray) {
        sum = [number integerValue]+sum;
    }
    
    //平均数
    double miu = (double)sum/30.0;
    double rSum = 0;
    for (NSNumber *number in rssiArray) {
        rSum = rSum + ([number integerValue]-miu)*([number integerValue]-miu);
    }
    // 方差
    double sigma = sqrt(rSum/29);
//遍历所有的采样点，如果概率小于65%则滤除掉
    for (int i = 0; i<rssiArray.count; i++) {
        NSNumber * number = rssiArray[i];
        double P = gaussianFunction([number integerValue], miu, sigma);
        if (P < 0.7) {
            [rssiArray removeObject:number];
            i--;
        }
    }
    sum = 0;
    for (NSNumber * number in rssiArray) {
        sum = [number integerValue]+sum;
    }
    //滤波后的数据取平均值返回
    sum = sum/rssiArray.count;
    return sum;
}


double gaussianFunction(double x,double miu,double sigma) //对数正态分布概率密度函数
{
    return 1.0/(sqrt(2*PI)*sigma) * exp(-1*(log(x)-miu)*(log(x)-miu)/(2*sigma));
}

/* 传感器设备信号强度变化*/
- (void)sensoroBeacon:(SBKBeacon *)beacon didUpdateRSSI:(NSInteger)rssi{
    NSLog(@"%ld",rssi);
}

@end

//
//  YPDormMapViewController.m
//  课程设计-3D导航
//
//  Created by xingyukun on 16/5/12.
//  Copyright © 2016年 iceB. All rights reserved.
//

#import "YPDormMapViewController.h"
#import "YPDormMapView.h"
#import <math.h>
#import "iToast.h"
#import "YPDistModel.h"

@interface YPDormMapViewController ()
{
     
}

@end

@implementation YPDormMapViewController
@synthesize db;

-(void)dealloc{
    [timer invalidate];
    timer = nil;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dormView = [[YPDormMapView alloc]initWithFrame:CGRectMake(17.5, 67, 340, 600)];
    dormView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:dormView];
    
    fpArray = [[NSMutableArray alloc]init];
    distanceArray = [[NSMutableArray alloc]init];
    rssi1Array = [[NSMutableArray alloc]init];
    rssi2Array = [[NSMutableArray alloc]init];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getRssiData) userInfo:nil repeats:YES];
    
}

-(void)getRssiData{
    if (_isDataRefresh) {
        if (rssi1Array.count>4 && rssi2Array.count>4) {
            
            [rssi1Array removeObjectAtIndex:0];
            [rssi2Array removeObjectAtIndex:0];
            
            [rssi1Array addObject:[NSNumber numberWithInteger:self.beacon1Rssi]];
            [rssi2Array addObject:[NSNumber numberWithInteger:self.beacon2Rssi]];
        
            for (int i = 0; i<rssi1Array.count; i++) {
                rssi1[i] = (int)[rssi1Array[i] integerValue];
                rssi2[2] = (int)[rssi2Array[i] integerValue];
            }
            dealWithFliter(rssi1);
            dealWithFliter(rssi2);
            
            //0.加权处理。
            double sumW1 = 0,sumRssiW1 = 0;
            double sumW2 = 0,sumRssiW2 = 0;
            for (int i = 0 ; i<4; i++) {
                sumW1 = sumW1 +(double)1.0/labs(rssi1[i] - self.beacon1Rssi);
                sumRssiW1=  (double)1.0/labs(rssi1[i] - self.beacon1Rssi)*self.beacon1Rssi;
                
                sumW2 = sumW2 +(double)1.0/labs(rssi2[i] - self.beacon2Rssi);
                sumRssiW2 = (double)2.0/labs(rssi2[i] - self.beacon2Rssi)*self.beacon2Rssi;
            }
            double Rssi_m1 = sumRssiW1/sumW1;
            double finalRssi1 = (Rssi_m1 +self.beacon1Rssi)/2;
            double Rssi_m2 = sumRssiW2/sumW2;
            double finalRssi2 = (Rssi_m2 +self.beacon2Rssi)/2;
            
            //1.遍历数据库求指纹数组；
            [self getDataFromeDatabase];
            if(fpArray.count<6 ){
                [[[iToast makeText:@"指纹数据太少，请多采集些"] setGravity:iToastGravityCenter] show];
//                return;
            }
            //2.将指纹数据与当前加权处理后的RSSI求距离数组
            if (fpArray.count==0) {
                return;
            }
            
            [distanceArray removeAllObjects];
            for (Fingerprin *fPrin in fpArray) {
                YPDistModel *distModel = [[YPDistModel alloc]init];
                
                distModel.distance =sqrt((fPrin.beacon1Rssi- finalRssi1)*(fPrin.beacon1Rssi- finalRssi1)+(fPrin.beacon2Rssi- finalRssi2)*(fPrin.beacon2Rssi- finalRssi2));
                distModel.aixs_x = fPrin.aixs_x;
                distModel.aixs_y = fPrin.aixs_y;

                [distanceArray addObject:distModel];
            }
            //3.将距离数组从小到大排序,采用快排算法
            [self quickSort:distanceArray and:0 and:(int)distanceArray.count-1];
            
           //取前4个坐标平均
            if (distanceArray.count>5) {
                double sumX = 0.0,sumY = 0.0;
                for (int i = 0; i< 4; i++) {
                    YPDistModel *tempModel = distanceArray[i];
                    sumX = sumX + tempModel.aixs_x;
                    sumY = sumY + tempModel.aixs_y;
                }
                double averageX,averageY;
                
                averageX  = sumX/4;
                averageY = sumY/4;
            
                //转换坐标
                CGPoint point;
                point.x = averageX;
                point.y = averageY;
                
                //完成定位UI展示；
                [dormView setPostionCoordinate:point];
                
                
            }else{
                [[[iToast makeText:@"指纹数据太少，请多采集些"] setGravity:iToastGravityCenter] show];
            }

        }else{
            [rssi1Array addObject:[NSNumber numberWithInteger:self.beacon1Rssi]];
            [rssi2Array addObject:[NSNumber numberWithInteger:self.beacon2Rssi]];
        }
       
        _isDataRefresh = NO;
    }
}
void swap(YPDistModel *x,YPDistModel *y)
{
    YPDistModel *temp;
    temp = x;
    x = y;
    y = temp;
}

int choose_pivot(int i,int j )
{
    return((i+j) /2);
}

#pragma mark -快排
-(void)quickSort:(NSMutableArray *)distArray and:(int)m and:(int)n{
    YPDistModel *key;
    int i,j,k;

    if (m < n ) {
        k = choose_pivot(m,n);
        YPDistModel *distModel_m = [distArray objectAtIndex:m];
        YPDistModel *distModel_n = [distArray objectAtIndex:n];
        swap(distModel_m,distModel_n);
        key = distModel_m;
        i = m+1;
        j = n;
        
        YPDistModel *distModel_i = [distArray objectAtIndex:i];
        YPDistModel *distModel_j = [distArray objectAtIndex:j];
        while(i <= j)
        {
            while((i <= n) && ( distModel_i.distance <= key.distance))
                i++;
            while((j >= m) && (distModel_j.distance > key.distance))
                j--;
            if( i < j)
                swap(distModel_i,distModel_j);
        }
        // 交换两个元素的位置
        swap(distModel_m,distModel_j);
        // 递归地对较小的数据序列进行排序
        [self quickSort:distArray and:m and:j-1];
        [self quickSort:distArray and:j+1 and:n];
    }
}

#pragma mark -滤波处理
void dealWithFliter(int * a){
    for (int i =0; i<3; i++) {
        if (abs(a[i]-a[i+1])> abs(a[i]-a[i+2])) {
            a[i+1] = (a[i]+a[1+2])/2;
        }
    }
}
#pragma mark -取数据
-(void)getDataFromeDatabase{
    if ([db open]) {
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM '%@'",@"beaconsRecord"];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            Fingerprin *fp = [[Fingerprin alloc]init];
            fp.index_id      = [rs intForColumn:@"index_id"];
            fp.aixs_x        = [rs intForColumn:@"aixs_x"];
            fp.aixs_y        = [rs intForColumn:@"aixs_y"];
            fp.iBeacon1_id   = [rs intForColumn:@"iBeacon1_id"];
            fp.beacon1Rssi   = [rs intForColumn:@"beacon1Rssi"];
            fp.iBeacon2_id   = [rs intForColumn:@"iBeacon2_id"];
            fp.beacon2Rssi   = [rs intForColumn:@"beacon2Rssi"];
            if (fp) {
                [fpArray addObject:fp];
            }
            NSLog(@"index_id = %zd, (%zd,%zd),  beacon1Rssi = %zd  beacon2Rssi = %zd", fp.index_id, fp.aixs_x, fp.aixs_y, fp.beacon1Rssi,fp.beacon2Rssi);
        }
        [db close];
    }else{
        [[[iToast makeText:@"打开数据库失败"] setGravity:iToastGravityCenter] show];

    }
}
//[db executeUpdate:@"CREATE TABLE beaconsRecord (index_id integer, aixs_x integer, aixs_y integer, iBeacon1_id integer, beacon1Rssi integer,iBeacon2_id integer, beacon2Rssi integer,iBeacon3_id integer,beacon3Rssi integer)"];

@end

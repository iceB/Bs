//
//  YPDistModel.h
//  课程设计-3D导航
//
//  Created by xingyukun on 16/6/7.
//  Copyright © 2016年 iceB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPDistModel : NSObject
@property(nonatomic,assign)NSInteger aixs_x;
@property(nonatomic,assign)NSInteger aixs_y;
@property(nonatomic,assign)double distance;
@property(nonatomic,assign)NSInteger beacon1Rssi;
@property(nonatomic,assign)NSInteger beacon2Rssi;
@end

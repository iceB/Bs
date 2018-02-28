//
//  YPToastView.h
//  课程设计-3D导航
//
//  Created by xingyukun on 16/5/14.
//  Copyright © 2016年 iceB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPToastView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *beaconList;

}
@property(nonatomic,strong) UILabel *beacon1;
@property(nonatomic,strong) UILabel *beacon2;
@property(nonatomic,strong) UILabel *altLabel;

@end

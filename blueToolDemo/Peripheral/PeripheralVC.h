//
//  PeripheralVC.h
//  blueToolDemo
//
//  Created by 易博 on 2017/8/23.
//  Copyright © 2017年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralVC : UIViewController

@property (nonatomic,strong) CBPeripheral *peripheral;

@end

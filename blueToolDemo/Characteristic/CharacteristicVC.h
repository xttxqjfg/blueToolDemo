//
//  CharacteristicVC.h
//  blueToolDemo
//
//  Created by 易博 on 2017/8/23.
//  Copyright © 2017年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CharacteristicVC : UIViewController

@property (nonatomic,strong) CBPeripheral *peripheral;

@property (nonatomic,strong) CBService *service;

@end

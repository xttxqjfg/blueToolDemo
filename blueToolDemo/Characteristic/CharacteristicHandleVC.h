//
//  CharacteristicHandleVC.h
//  blueToolDemo
//
//  Created by 易博 on 2017/8/28.
//  Copyright © 2017年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreBluetooth/CoreBluetooth.h>

@interface CharacteristicHandleVC : UIViewController

@property (nonatomic,strong) CBPeripheral *peripheral;

@property (nonatomic,strong) CBService *service;

@property (nonatomic,strong) CBCharacteristic *characteristic;


@end

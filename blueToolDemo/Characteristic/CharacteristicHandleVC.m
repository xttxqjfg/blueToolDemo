//
//  CharacteristicHandleVC.m
//  blueToolDemo
//
//  Created by 易博 on 2017/8/28.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "CharacteristicHandleVC.h"

@interface CharacteristicHandleVC ()<UITextFieldDelegate,CBPeripheralDelegate,CBCentralManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *msgShowLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;

@property (weak, nonatomic) IBOutlet UILabel *characteristicLabel;

@property (weak, nonatomic) IBOutlet UITextField *msgTextField;

@property (nonatomic,strong) CBCentralManager *centerManager;


@end

@implementation CharacteristicHandleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@",self.peripheral.name];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.serviceLabel.text = [NSString stringWithFormat:@"%@",self.service.UUID.UUIDString];
    
    self.characteristicLabel.text = [NSString stringWithFormat:@"%@",self.characteristic.UUID.UUIDString];
    
    self.msgTextField.delegate = self;
    self.peripheral.delegate = self;
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    self.msgShowLabel.text = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        self.msgShowLabel.text = @"didWriteValueForCharacteristic error";
    }
    else
    {
        [peripheral readValueForCharacteristic:characteristic];
    }
}

- (IBAction)readMsgBtnClicked:(UIButton *)sender {
    [self.peripheral readValueForCharacteristic:self.characteristic];
}

- (IBAction)sendMsgBtnClicked:(UIButton *)sender {
    //写数据
    NSString *msg = [self.msgTextField.text length] > 0 ? self.msgTextField.text : @"无";
    [self.peripheral writeValue:[msg dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(CBCentralManager *)centerManager
{
    if (!_centerManager) {
        _centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _centerManager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

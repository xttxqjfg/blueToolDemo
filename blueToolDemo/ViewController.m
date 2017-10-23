//
//  ViewController.m
//  blueToolDemo
//
//  Created by 易博 on 2017/8/22.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "PeripheralVC.h"

#define myMacUUID @"0E698202-B11F-49C3-8026-098243C64222"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//外设列表
@property (nonatomic,strong) NSMutableArray *deviceListArr;

@property (nonatomic,strong) CBCentralManager *centerManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (IBAction)startScan:(UIButton *)sender {
    [self.deviceListArr removeAllObjects];
    [self.centerManager scanForPeripheralsWithServices:nil options:nil];
}

- (IBAction)stopScan:(UIButton *)sender {
    [self.centerManager stopScan];
}

#pragma mark CBCentralManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStatePoweredOn:
        {
            [self.centerManager scanForPeripheralsWithServices:nil options:nil];
            break;
        }
        default:
            NSLog(@"异常状态:%ld",(long)central.state);
            break;
    }
}

//扫描到设备后调用
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    [self.deviceListArr addObject:peripheral];
    [self.tableView reloadData];
}

//连接成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"连接成功...");
    PeripheralVC *peripheralVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PeripheralVC"];
    peripheralVC.peripheral = peripheral;
    [self.navigationController pushViewController:peripheralVC animated:YES];
}

//连接失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接失败...");
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blueIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"blueIdentifier"];
    }
    CBPeripheral *peripheral = [self.deviceListArr objectAtIndex:indexPath.row];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.identifier.UUIDString;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceListArr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.centerManager stopScan];
    
    CBPeripheral *peripheral = [self.deviceListArr objectAtIndex:indexPath.row];
    NSLog(@"+++++++++++++++:%@",peripheral.identifier.UUIDString);
    
    // 连接外设 传入你搜索到的目标外设对象
    [self.centerManager connectPeripheral:peripheral options:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(NSMutableArray *)deviceListArr
{
    if (!_deviceListArr) {
        _deviceListArr = [[NSMutableArray alloc]init];
    }
    return _deviceListArr;
}

-(CBCentralManager *)centerManager
{
    if (!_centerManager) {
        _centerManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    return _centerManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

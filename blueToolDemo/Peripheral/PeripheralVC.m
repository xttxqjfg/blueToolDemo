//
//  PeripheralVC.m
//  blueToolDemo
//
//  Created by 易博 on 2017/8/23.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "PeripheralVC.h"
#import "CharacteristicVC.h"

@interface PeripheralVC ()<UITableViewDelegate,UITableViewDataSource,CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) NSMutableArray *servicesList;

@end

@implementation PeripheralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@的服务列表",self.peripheral.name];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.peripheral.delegate = self;
}



- (IBAction)scanServices:(UIButton *)sender {
    [self.servicesList removeAllObjects];
    //扫描所有服务
    [self.peripheral discoverServices:nil];
}

#pragma mark CBPeripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"didDiscoverServices:%@",error.localizedDescription);
        return;
    }
    else
    {
        for (CBService *services in peripheral.services) {
            NSLog(@"service UUID:%@",services.UUID.UUIDString);
            [self.servicesList addObject:services];
        }
    }
    [self.tableview reloadData];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.servicesList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"servicesIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"servicesIdentifier"];
    }
    CBService *service = [self.servicesList objectAtIndex:indexPath.row];
    cell.textLabel.text = service.UUID.UUIDString;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBService *service = [self.servicesList objectAtIndex:indexPath.row];
    
    CharacteristicVC *characteristicVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CharacteristicVC"];
    characteristicVC.peripheral = self.peripheral;
    characteristicVC.service = service;
    [self.navigationController pushViewController:characteristicVC animated:YES];
    
}

-(NSMutableArray *)servicesList
{
    if (!_servicesList) {
        _servicesList = [[NSMutableArray alloc]init];
    }
    return _servicesList;
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

//
//  CharacteristicVC.m
//  blueToolDemo
//
//  Created by 易博 on 2017/8/23.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "CharacteristicVC.h"

#import "CharacteristicHandleVC.h"

@interface CharacteristicVC ()<UITableViewDataSource,UITableViewDelegate,CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *characteristicList;

@end

@implementation CharacteristicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@的特征值列表",self.service.UUID.UUIDString];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.peripheral.delegate = self;
}

#pragma mark CBPeripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error
{
    if (error) {
        NSLog(@"didDiscoverCharacteristicsForService:%@",error.localizedDescription);
        return;
    }
    else
    {
        for (CBCharacteristic *cha in service.characteristics) {
            [self.characteristicList addObject:cha];
            switch (cha.properties) {
                case CBCharacteristicPropertyRead:
                {
                    NSLog(@"------------------读:%@",cha);
                    break;
                }
                case CBCharacteristicPropertyWrite:
                {
                    NSLog(@"------------------写:%@",cha);
                    break;
                }
                case CBCharacteristicPropertyNotify:
                {
                    NSLog(@"------------------订阅:%@",cha);
                    break;
                }
                default:
                    NSLog(@"------------------:%@",cha);
                    break;
            }
        }
        [self.tableView reloadData];
    }
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"characteristicIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"characteristicIdentifier"];
    }
    CBCharacteristic *characteristic = [self.characteristicList objectAtIndex:indexPath.row];
    cell.textLabel.text = characteristic.UUID.UUIDString;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.characteristicList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBCharacteristic *characteristic = [self.characteristicList objectAtIndex:indexPath.row];
    
    CharacteristicHandleVC *characteristicHandleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CharacteristicHandleVC"];
    characteristicHandleVC.peripheral = self.peripheral;
    characteristicHandleVC.service = self.service;
    characteristicHandleVC.characteristic = characteristic;
    [self.navigationController pushViewController:characteristicHandleVC animated:YES];
}

- (IBAction)scanCharacteristics:(UIButton *)sender {
    [self.characteristicList removeAllObjects];
    [self.peripheral discoverCharacteristics:nil forService:self.service];
}

-(NSMutableArray *)characteristicList
{
    if (!_characteristicList) {
        _characteristicList = [[NSMutableArray alloc]init];
    }
    return _characteristicList;
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

//
//  ViewController.m
//  OnoDemo
//
//  Created by fengweiru on 2017/11/28.
//  Copyright © 2017年 fengweiru. All rights reserved.
//

#import "ViewController.h"
#import "BarcodeViewController.h"
#import "ProductModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ProductModel *product;

@end

@implementation ViewController

- (ProductModel *)product
{
    if (!_product) {
        _product = [[ProductModel alloc] init];
    }
    return _product;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
}

- (void)setupUI
{
    self.title = @"Ono解析";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavLeftItem];
    [self setNavRightItem];
    
    [self.view addSubview:self.tableView];
}

#pragma mark -- UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"商品条码";
            cell.detailTextLabel.text = self.product.code;
            break;
        case 1:
            cell.textLabel.text = @"名称";
            cell.detailTextLabel.text = self.product.name;
            break;
        case 2:
            cell.textLabel.text = @"规格型号";
            cell.detailTextLabel.text = self.product.specificagionmodel;
            break;
        case 3:
            cell.textLabel.text = @"描述";
            cell.detailTextLabel.text = self.product.descriptions;
            break;
        case 4:
            cell.textLabel.text = @"商标";
            cell.detailTextLabel.text = self.product.brand;
            break;
        case 5:
            cell.textLabel.text = @"发布厂商";
            cell.detailTextLabel.text = self.product.manufacturer;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)setNavLeftItem {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [leftButton setTitle:@"手动输入" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0);
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0);
    
    [leftButton addTarget:self action:@selector(clickLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftFinishItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftFinishItem;
}

- (void)setNavRightItem {

    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [rightButton setTitle:@"条形码扫描" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -9);
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -9);
    
    [rightButton addTarget:self action:@selector(clickRightItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightFinishItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightFinishItem;
    
}

- (void)clickLeftItem:(UIButton *)sender {
    __weak __typeof(&*self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入商品条形码值" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = false;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (alert.textFields.firstObject.text.length != 0) {
            NSString *urlstring = [NSString stringWithFormat:@"http://search.anccnet.com/searchResult2.aspx?keyword=%@",alert.textFields.firstObject.text];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring] options:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
            
            [weakSelf.product analysisWithData:data];
            [weakSelf.tableView reloadData];
        }
        
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)clickRightItem:(UIButton *)sender {
    BarcodeViewController *vc = [[BarcodeViewController alloc] initWithProductModel:self.product];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

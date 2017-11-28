//
//  ProductModel.h
//  OnoDemo
//
//  Created by fengweiru on 2017/11/28.
//  Copyright © 2017年 fengweiru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, strong) NSString *code;                 //商品条码
@property (nonatomic, strong) NSString *name;                 //名称
@property (nonatomic, strong) NSString *specificagionmodel;   //规格型号
@property (nonatomic, strong) NSString *descriptions;         //描述
@property (nonatomic, strong) NSString *brand;                //商标
@property (nonatomic, strong) NSString *manufacturer;         //发布厂商

- (void)analysisWithData:(NSData *)data;

@end

//
//  ProductModel.m
//  OnoDemo
//
//  Created by fengweiru on 2017/11/28.
//  Copyright © 2017年 fengweiru. All rights reserved.
//

#import "ProductModel.h"
#import "ONOXMLDocument.h"

@implementation ProductModel

- (instancetype)init
{
    if (self = [super init]) {
        
        self.code = @"";
        self.name = @"";
        self.specificagionmodel = @"";
        self.descriptions = @"";
        self.brand = @"";
        self.manufacturer = @"";
        
    }
    return self;
}

- (void)analysisWithData:(NSData *)data
{
    ONOXMLDocument *document = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
    NSString *xpath = @"//body/form/div[@class='wrap']/div[@class='bodyer']/div[@class='mainly']/div[@id='outter']/ol[@id='results']/li[1]/div[@class='result']";
    [document enumerateElementsWithXPath:xpath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        //        NSLog(@"%@: %@", element.tag, element.attributes);
        
        for (ONOXMLElement *celement in element.children) {
            
            //商家和发布厂家
            if ([celement.tag isEqualToString:@"dl"] && [celement.attributes[@"class"] isEqualToString:@"p-supplier"]) {
                NSInteger i = 0;
                for (ONOXMLElement *ccelement in celement.children) {
                    if ([ccelement.tag isEqualToString:@"dd"] && i == 0) {
                        self.brand = [ccelement stringValue];
                        i++;
                    }
                    else if ([ccelement.tag isEqualToString:@"dd"] && i == 1) {
                        self.manufacturer = [[ccelement stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    }
                    
                }
            }
            
            //商品条码、名称、规格型号、描述
            if ([celement.tag isEqualToString:@"dl"] && [celement.attributes[@"class"] isEqualToString:@"p-info"]) {
                NSInteger i = 0;
                for (ONOXMLElement *ccelement in celement.children) {
                    if ([ccelement.tag isEqualToString:@"dd"] && i == 0) {
                        self.code = [ccelement stringValue];
                        i++;
                    }
                    else if ([ccelement.tag isEqualToString:@"dd"] && i == 1) {
                        self.name = [ccelement stringValue];
                        i++;
                    }
                    else if ([ccelement.tag isEqualToString:@"dd"] && i == 2) {
                        self.specificagionmodel = [ccelement stringValue];
                        i++;
                    }
                    else if ([ccelement.tag isEqualToString:@"dd"] && i == 3) {
                        self.descriptions = [ccelement stringValue];
                    }
                }
            }
        }
        //        NSLog(@"%@",self);
    }];
    
}

@end

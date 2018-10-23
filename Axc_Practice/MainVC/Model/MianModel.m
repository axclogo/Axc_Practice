//
//  MianModel.m
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/22.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import "MianModel.h"

@implementation MianModel

+ (MianModel *)VCName:(NSString *)VCName title:(NSString *)title disTitle:(NSString *)disTitle{
    MianModel *model = [MianModel new];
    model.VCName = VCName;
    model.title = title;
    model.disTitle = disTitle;
    return model;
}

@end

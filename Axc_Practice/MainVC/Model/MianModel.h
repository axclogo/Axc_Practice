//
//  MianModel.h
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/22.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MianModel : NSObject

+ (MianModel *)VCName:(NSString *)VCName title:(NSString *)title disTitle:(NSString *)disTitle;

@property(nonatomic , strong)NSString *VCName;
@property(nonatomic , strong)NSString *title;
@property(nonatomic , strong)NSString *disTitle;

@end

NS_ASSUME_NONNULL_END

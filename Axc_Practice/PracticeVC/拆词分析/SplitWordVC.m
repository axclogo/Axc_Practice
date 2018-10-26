//
//  SplitWordVC.m
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/25.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import "SplitWordVC.h"
#import <Parsimmon.h>
#import "ParsimmonTaggedToken.h"

@interface SplitWordVC ()
@property(nonatomic , strong)UITextView *textView;
@property(nonatomic , strong)UIButton *analysisBtn;
@property(nonatomic , strong)UITextView *showTextView;

@end

@implementation SplitWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.textView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    self.showTextView.frame = CGRectMake(0, 110, kScreenWidth, 300);
    self.analysisBtn.frame = CGRectMake(10, kScreenHeight - 150, kScreenWidth-20, 40);
}
- (void)click_analysisBtn{
//    NSMutableString *showString = @"".mutableCopy;
//    [[self splitWord:self.textView.text] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [showString appendString:obj];
//        [showString appendString:@","];
//    }];
//    self.showTextView.text = showString;
    
    ParsimmonTokenizer *tokenizer = [[ParsimmonTokenizer alloc] init];
    NSArray *tokens = [tokenizer tokenizeWordsInText:self.textView.text ];
    NSMutableString *showString = @"".mutableCopy;
    [tokens enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [showString appendString:obj];
        [showString appendString:@"\n"];
    }];
    self.showTextView.text = showString;
    
//    ParsimmonTagger *tagger = [[ParsimmonTagger alloc] initWithLanguage:@"China"];
//    NSArray *taggers = [tagger tagWordsInText:self.textView.text];
//    NSMutableString *showString = @"".mutableCopy;
//    [taggers enumerateObjectsUsingBlock:^(ParsimmonTaggedToken * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [showString appendFormat:@"%@---%@",obj.token,obj.tag];
//        [showString appendString:@"\n"];
//    }];
//    self.showTextView.text = showString;
    
}

- (NSArray <NSString *>*)splitWord:(NSString *)string{
    CFStringTokenizerRef ref = CFStringTokenizerCreate(NULL,
                                                       (__bridge CFStringRef)string,
                                                       CFRangeMake(0,string .length),
                                                       kCFStringTokenizerUnitWord,
                                                       NULL);// 创建分词器
    CFRange range;// 当前分词的位置
    // 获取第一个分词的范围
    CFStringTokenizerAdvanceToNextToken(ref);
    range = CFStringTokenizerGetCurrentTokenRange(ref);
    // 循环遍历获取所有分词并记录到数组中
    NSMutableArray *textArray = @[].mutableCopy;
    NSString *keyWord;
    while (range.length>0) {
        keyWord = [string substringWithRange:NSMakeRange(range.location, range.length)];
        [textArray addObject:keyWord];
        CFStringTokenizerAdvanceToNextToken(ref);
        range = CFStringTokenizerGetCurrentTokenRange(ref);
    }
    CFRelease(ref);
    return textArray;
}

// 13867461539
#pragma mark - 懒加载
- (UITextView *)showTextView{
    if (!_showTextView) {
        _showTextView = [UITextView new];
        _showTextView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.view addSubview:_showTextView];
    }
    return _showTextView;
}
- (UIButton *)analysisBtn{
    if (!_analysisBtn) {
        _analysisBtn = [UIButton new];
        _analysisBtn.backgroundColor = [UIColor orangeColor];
        [_analysisBtn setTitle:@"拆词分析" forState:UIControlStateNormal];
        [_analysisBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_analysisBtn addTarget:self action:@selector(click_analysisBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_analysisBtn];
    }
    return _analysisBtn;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.text = @"故事的小黄花，从出生那年就飘着，童年的荡秋千，随记忆一直晃到现在";
//        _textView.text = @"The quick brown fox jumps over the lazy dog";
        _textView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

        [self.view addSubview:_textView];
    }
    return _textView;
}


@end

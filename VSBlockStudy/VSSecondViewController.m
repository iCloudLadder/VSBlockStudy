//
//  VSSecondViewController.m
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/14.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "VSSecondViewController.h"
#import "Common.h"

@interface VSSecondViewController ()

@property (nonatomic, strong) UITextView *inputTextField;

@end

@implementation VSSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Common creatButtonWith:@[@"Done"] target:self action:@selector(buttonClickedEvent:)];
    
    [self creatInputText];
}

- (void)creatInputText
{
    self.inputTextField = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.frame) - 40, 100)];
    self.inputTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputTextField.layer.borderWidth = 0.5;
    [self.view addSubview:_inputTextField];
    
}

- (void)buttonClickedEvent:(id)sender
{
    if (_inputText) {
        _inputText(_inputTextField.text);
    }else if ([_delegate respondsToSelector:@selector(getInputTextWith:)]){
        [_delegate getInputTextWith:_inputTextField.text];
    }else{
    
    }
    

    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

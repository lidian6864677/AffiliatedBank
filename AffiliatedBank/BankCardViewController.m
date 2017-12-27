//
//  BankCardViewController.m
//  XYQ
//
//  Created by Dian on 2017/12/25.
//  Copyright © 2017年 XYQ. All rights reserved.
//

#import "BankCardViewController.h"
#import "NSString+Handler.h"
#import "UIView+Extension.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
@interface BankCardViewController ()<UITextFieldDelegate, UIScrollViewDelegate>{
    int count;
    NSTimer *timer;
    UITextField *_selectTextField;  // 选中的 textField
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *idCardTextField;
@property (nonatomic, strong) UITextField *bankNumberTextField;
@property (nonatomic, strong) UILabel *affiliatedBankLabel;   // 银行卡所属银行
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UIButton *sendCodeButton;

@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的银行卡";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self prepareViews];
}


- (void)prepareViews{
    
    self.nameTextField.placeholder = @"张三";
    self.idCardTextField.placeholder = @"11111123****1232";
    self.bankNumberTextField.placeholder = @"请输入银行卡号";
    self.phoneNumberTextField.placeholder = @"请输入银行预留手机号";
    self.verifyCodeTextField.placeholder = @"请输入验证码";
    self.scrollView.contentSize = CGSizeMake(SCREENW, CGRectGetMaxY(self.verifyCodeTextField.frame)+150);
}

- (void)handleSendSmsResult{
    count = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [_sendCodeButton setEnabled:YES];
}

- (void)requestIdentifyCode:(NSString *)url parameters:(NSMutableDictionary *)parameters{
    [self handleSendSmsResult];
}

#pragma mark - SELs
- (void)clickSecdCodeButton:(UIButton *)button{
    NSLog(@"send code");
    [_selectTextField resignFirstResponder];
    [self requestIdentifyCode:@"" parameters:[@{@"mobilePhoneNumber":self.phoneNumberTextField.text,@"countryCode":@"+86"} mutableCopy]];
}


- (void)clickedSubmitVerifyButton:(UIButton *)button{
    NSLog(@"submit click");
}

-(void)countDown{
    if (count<1) {
        [timer invalidate];
        [_sendCodeButton setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        [_sendCodeButton setEnabled:YES];
    }else{
        [_sendCodeButton setTitle:[NSString stringWithFormat:@"%ds",count] forState:UIControlStateNormal];
        [_sendCodeButton setEnabled:NO];
        count--;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_selectTextField resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_selectTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _selectTextField = textField;
    if ([textField isEqual:self.bankNumberTextField]) {
        _affiliatedBankLabel.text = @"";
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.nameTextField]) {
        
    }else if([textField isEqual:self.bankNumberTextField]){
        
    }else if ([textField isEqual:self.phoneNumberTextField]){
        
    }else if ([textField isEqual:self.verifyCodeTextField]){
        
        
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.bankNumberTextField]) {
        NSString *string = [NSString returnBankName:textField.text];
        NSLog(@"%@",string);
        _affiliatedBankLabel.text = string;
    }
}

#pragma mark - GUIs

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UITextField *)nameTextField{
    if (_nameTextField == nil) {
        UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        titleName.font = [UIFont systemFontOfSize:14];
        titleName.text = @"绑定信息";
        [self.scrollView addSubview:titleName];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, 40, 20)];
        titleLabel.text = @"姓名";
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:titleLabel];
        
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), titleLabel.y, SCREENW - titleLabel.width - titleLabel.x, titleLabel.height)];
        _nameTextField.userInteractionEnabled = NO;
        _nameTextField.font = [UIFont systemFontOfSize:14];
        _nameTextField.delegate = self;
        [self.scrollView addSubview:_nameTextField];
        
        // line
        CALayer *line1 = [CALayer layer];
        [line1 setFrame:CGRectMake(20, CGRectGetMaxY(_nameTextField.frame)+10, SCREENW - 40, 0.5)];
        line1.backgroundColor = [UIColor grayColor].CGColor;
        [self.scrollView.layer addSublayer:line1];
    }
    return _nameTextField;
}

- (UITextField *)idCardTextField{
    if (_idCardTextField == nil) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.nameTextField.frame)+50, 70, 20)];
        titleLabel.text = @"身份证号";
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:titleLabel];
        
        _idCardTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), titleLabel.y, SCREENW - titleLabel.width - titleLabel.x, titleLabel.height)];
        _idCardTextField.userInteractionEnabled = NO;
        _idCardTextField.font = [UIFont systemFontOfSize:14];
        _idCardTextField.delegate = self;
        [self.scrollView addSubview:_idCardTextField];
        CALayer *line1 = [CALayer layer];
        
        // line
        [line1 setFrame:CGRectMake(20, CGRectGetMaxY(_idCardTextField.frame)+10, SCREENW - 40, 0.5)];
        line1.backgroundColor = [UIColor grayColor].CGColor;
        [self.scrollView.layer addSublayer:line1];
    }
    return _idCardTextField;
}

- (UITextField *)bankNumberTextField{
    if (_bankNumberTextField == nil) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.idCardTextField.frame)+50, 70, 20)];
        titleLabel.text = @"银行卡号";
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:titleLabel];
        
        self.affiliatedBankLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), titleLabel.y - titleLabel.height - 5, SCREENW - titleLabel.width - titleLabel.x, titleLabel.height)];
        _affiliatedBankLabel.textColor = [UIColor blackColor];
        _affiliatedBankLabel.font = [UIFont systemFontOfSize:12];
        [self.scrollView addSubview:_affiliatedBankLabel];
        
        _bankNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), titleLabel.y, SCREENW - titleLabel.width - titleLabel.x, titleLabel.height)];
        _bankNumberTextField.delegate = self;
        _bankNumberTextField.textColor = [UIColor darkGrayColor];
        _bankNumberTextField.font = [UIFont systemFontOfSize:14];
        _bankNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.scrollView addSubview:_bankNumberTextField];
        CALayer *line1 = [CALayer layer];
        // line
        [line1 setFrame:CGRectMake(20, CGRectGetMaxY(_bankNumberTextField.frame)+10, SCREENW - 40, 0.5)];
        line1.backgroundColor = [UIColor grayColor].CGColor;
        [self.scrollView.layer addSublayer:line1];
    }
    return _bankNumberTextField;
}
- (UITextField *)phoneNumberTextField{
    if (_phoneNumberTextField == nil) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.bankNumberTextField.frame)+50, 110, 20)];
        titleLabel.text = @"银行预留手机号";
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:titleLabel];
        
        _phoneNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), titleLabel.y, SCREENW - titleLabel.width - titleLabel.x , titleLabel.height)];
        _phoneNumberTextField.delegate = self;
        _phoneNumberTextField.textColor = [UIColor darkGrayColor];
        _phoneNumberTextField.font = [UIFont systemFontOfSize:14];
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.scrollView addSubview:_phoneNumberTextField];
        CALayer *line1 = [CALayer layer];
        // line
        [line1 setFrame:CGRectMake(20, CGRectGetMaxY(_phoneNumberTextField.frame)+10, SCREENW - 40, 0.5)];
        line1.backgroundColor = [UIColor grayColor].CGColor;
        [self.scrollView.layer addSublayer:line1];
    }
    return _phoneNumberTextField;
}
- (UITextField *)verifyCodeTextField{
    if (_verifyCodeTextField == nil) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.phoneNumberTextField.frame)+50, 80, 20)];
        titleLabel.text = @"填写验证码";
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:titleLabel];
        [self.scrollView addSubview:self.sendCodeButton];
        
        _verifyCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), titleLabel.y, SCREENW - titleLabel.width - titleLabel.x - self.sendCodeButton.width, titleLabel.height)];
        _verifyCodeTextField.textColor = [UIColor darkGrayColor];
        _verifyCodeTextField.delegate = self;
        _verifyCodeTextField.font = [UIFont systemFontOfSize:14];
        _verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.scrollView addSubview:_verifyCodeTextField];
        CALayer *line1 = [CALayer layer];
    
        // line
        [line1 setFrame:CGRectMake(20, CGRectGetMaxY(_verifyCodeTextField.frame)+10, SCREENW - 40 -self.sendCodeButton.width - 10, 0.5)];
        line1.backgroundColor = [UIColor grayColor].CGColor;
        [self.scrollView.layer addSublayer:line1];
    }
    return _verifyCodeTextField;
}
- (UIButton *)sendCodeButton{
    if (_sendCodeButton == nil) {
        _sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendCodeButton setFrame:CGRectMake(SCREENW - 90 - 20, CGRectGetMaxY(self.phoneNumberTextField.frame)+45, 90, 35)];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _sendCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendCodeButton addTarget:self action:@selector(clickSecdCodeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_sendCodeButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    }
    return _sendCodeButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


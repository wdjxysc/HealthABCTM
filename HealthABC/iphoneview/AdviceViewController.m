//
//  AdviceViewController.m
//  Thermometer
//
//  Created by 夏 伟 on 14-3-21.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "AdviceViewController.h"
#import "MySingleton.h"
#import "YLLabel.h"

@interface AdviceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodAdviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodAdviceDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportAdviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportAdviceDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorAdviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorAdviceDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *commAdviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commAdviceDataLabel;
@property (weak, nonatomic) IBOutlet YLLabel *sportAdviceDataYLLabel;
@property (weak, nonatomic) IBOutlet YLLabel *foodAdviceDataYLLabel;
@property (weak, nonatomic) IBOutlet YLLabel *doctorAdviceDataYLLabel;
@property (weak, nonatomic) IBOutlet YLLabel *commAdviceDataYLLabel;

@end

@implementation AdviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"健康建议";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [_resultLabel removeFromSuperview];
//    [_resultDataLabel removeFromSuperview];
//    [_foodAdviceLabel removeFromSuperview];
//    [_foodAdviceDataLabel removeFromSuperview];
//    [_sportAdviceLabel removeFromSuperview];
//    [_sportAdviceDataLabel removeFromSuperview];
//    [_doctorAdviceLabel removeFromSuperview];
//    [_doctorAdviceDataLabel removeFromSuperview];
//    [_commAdviceLabel removeFromSuperview];
//    [_commAdviceDataLabel removeFromSuperview];
    
    //设置圆角
    [_foodAdviceLabel.layer setCornerRadius:5.0];
    [_sportAdviceLabel.layer setCornerRadius:5.0];
    [_doctorAdviceLabel.layer setCornerRadius:5.0];
    [_commAdviceLabel.layer setCornerRadius:5.0];
    [_foodAdviceDataYLLabel.layer setCornerRadius:5.0];
    [_sportAdviceDataYLLabel.layer setCornerRadius:5.0];
    [_doctorAdviceDataYLLabel.layer setCornerRadius:5.0];
    [_commAdviceDataYLLabel.layer setCornerRadius:5.0];
    
    _foodAdviceDataLabel.hidden = YES;
    _sportAdviceDataLabel.hidden = YES;
    _doctorAdviceDataLabel.hidden = YES;
    _commAdviceDataLabel.hidden = YES;
    
    NSDictionary *dic = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"WeightAdviceDic"];
    
    if(dic != nil){
        _resultDataLabel.text = [dic valueForKey:@"result"];
        
        NSDictionary *advicedic = [dic valueForKey:@"advice"];
        _foodAdviceDataLabel.text = [advicedic valueForKey:@"foodSuggestion"];
        _sportAdviceDataLabel.text =[advicedic valueForKey:@"sportSuggestion"];
        _doctorAdviceDataLabel.text =[advicedic valueForKey:@"doctorSuggestion"];
        _commAdviceDataLabel.text =[advicedic valueForKey:@"commSuggestion"];
        
        
        [_foodAdviceDataYLLabel setText:[advicedic valueForKey:@"foodSuggestion"]];
        [_sportAdviceDataYLLabel setText:[advicedic valueForKey:@"sportSuggestion"]];
        [_doctorAdviceDataYLLabel setText:[advicedic valueForKey:@"doctorSuggestion"]];
        [_commAdviceDataYLLabel setText:[advicedic valueForKey:@"commSuggestion"]];
    }
    
    
    [_foodAdviceDataLabel sizeToFit];
    
    NSString *str = @"ashdkajsfhjksdfhajksdhfajkshgadfjksghaksghadkjghadksfghagklhadfgasdasfasfadsfasdffffffffffffffasdfasdfasdfasdfasdfsadfadsfashdkajsfhjksdfhajksdhfajkshgadfjksghaksghadkjghadksfghagklhadfgasdasfasfadsfasdffffffffffffffasdfasdfasdfasdfasdfsadfadsfashdkajsfhjksdfhajksdhfajkshgadfjksghaksghadkjghadksfghagklhadfgasdasfasfadsfasdffffffffffffffasdfasdfasdfasdfasdfsadfadsfashdkajsfhjksdfhajksdhfajkshgadfjksghaksghadkjghadksfghagklhadfgasdasfasfadsfasdffffffffffffffasdfasdfasdfasdfasdfsadfadsfashdkajsfhjksdfhajksdhfajkshgadfjksghaksghadkjghadksfghagklhadfgasdasfasfadsfasdffffffffffffffasdfasdfasdfasdfasdfsadfadsfashdkajsfhjksdfhajksdhfajkshgadfjksghaksghadkjghadksfghagklhadfgasdasfasfadsfasdffffffffffffffasdfasdfasdfasdfasdfsadfadsf";
    CGSize labelSize = [str sizeWithFont:[UIFont boldSystemFontOfSize:8.0f]
                       constrainedToSize:CGSizeMake(280, 100)
                           lineBreakMode:NSLineBreakByWordWrapping];   // str是要显示的字符串
    UILabel *patternLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 157, labelSize.width, labelSize.height)];
    
    patternLabel.text = str;
    patternLabel.backgroundColor = [UIColor clearColor];
    patternLabel.font = [UIFont boldSystemFontOfSize:8.0f];
    patternLabel.numberOfLines = 0;     // 不可少Label属性之一
    patternLabel.lineBreakMode = NSLineBreakByWordWrapping;    // 不可少Label属性之二
//    [self.view addSubview:patternLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

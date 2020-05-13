//
//  LoginViewController.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

typedef enum {
    LoginStatusSuccess = 1,
    LoginStatusFailure = 2,
    LoginStatusServerException = 3,
    LoginStatusNetworkException = 4
} LoginStatus;

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;



@property (weak, nonatomic) IBOutlet UITextField *loginName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)loginToMainView:(id)sender;
@end

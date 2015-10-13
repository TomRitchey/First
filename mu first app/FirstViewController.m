//
//  FirstViewController.m
//  mu first app
//
//  Created by Kacper Augustyniak on 26/05/2015.
//  Copyright (c) 2015 Kacper Augustyniak. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIButton *Button1;
@property (weak, nonatomic) IBOutlet UITextField *TextBox;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBox;

@end

@implementation FirstViewController
int buttonPressedTimes = 0;
NSString* timesButtonPresed;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.TextBox.text=@"No button press";
    [self.Button1 setTitle:@"Click" forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)ChrisSucksBalls:(id)sender {
    buttonPressedTimes++;
    timesButtonPresed = [NSString stringWithFormat:@"Button pressed %d times", buttonPressedTimes];
    self.TextBox.text=timesButtonPresed;
    [self.TextBox resignFirstResponder];
}

@end


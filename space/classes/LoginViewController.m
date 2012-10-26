//
//  HUDViewController.m
//  Created by Devin Ross on 7/4/09.
//
/*
 
 tapku.com || https://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "LoginViewController.h"
#import "GameManager.h"
#import "AppDelegate.h"

#define RETRY_SECONDS 3

@implementation LoginViewController

- (id) init{
	if(!(self=[super init])) return nil;
	
    // Add Loader BG
	UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];

    // Position BG
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];

	return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _alertView = [[TKProgressAlertView alloc] initWithProgressTitle:@"Logging In"];
    self.alertView.progressBar.progress = 0;
    [self.alertView show];
    
    [self performSelector:@selector(stepAuthenticate) withObject:nil afterDelay:0.75f];
}

#pragma mark Initialisation Sequence
-(void) stepAuthenticate
{
    self.alertView.label.text           = @"Logging In";
    
    [[GameManager sharedInstance] authenticate:^(){
        self.alertView.progressBar.progress = 0.20f;
        [self performSelector:@selector(stepMasterItemList) withObject:nil afterDelay:0.1f];
    } setErrorBlock:^(){
        self.alertView.label.text           = [NSString stringWithFormat:@"Retrying..."];
        [self performSelector:@selector(stepAuthenticate) withObject:nil afterDelay:RETRY_SECONDS];
    }];
}

-(void) stepMasterItemList
{
    self.alertView.label.text           = @"Updating 1/4";
    
    [[GameManager sharedInstance] retrieveMasterItem:^(){
        self.alertView.progressBar.progress = 0.40f;
        [self performSelector:@selector(stepMasterPartList) withObject:nil afterDelay:0.1f];
    } setErrorBlock:^(){
        self.alertView.label.text           = [NSString stringWithFormat:@"Retrying..."];
        [self performSelector:@selector(stepMasterItemList) withObject:nil afterDelay:RETRY_SECONDS];
    }];
}

-(void) stepMasterPartList
{
    self.alertView.label.text           = @"Updating 2/4";
    
    [[GameManager sharedInstance] retrieveMasterPart:^(){
        self.alertView.progressBar.progress = 0.60f;
        [self performSelector:@selector(stepMasterGroupList) withObject:nil afterDelay:0.1f];
    } setErrorBlock:^(){
        self.alertView.label.text           = [NSString stringWithFormat:@"Retrying..."];
        [self performSelector:@selector(stepMasterPartList) withObject:nil afterDelay:RETRY_SECONDS];
    }];
}

-(void) stepMasterGroupList
{
    self.alertView.label.text           = @"Updating 3/4";
    
    [[GameManager sharedInstance] retrieveMasterGroup:^(){
        self.alertView.progressBar.progress = 0.80f;
        [self performSelector:@selector(stepMasterBuildingList) withObject:nil afterDelay:0.1f];
    } setErrorBlock:^(){
        self.alertView.label.text           = [NSString stringWithFormat:@"Retrying..."];
        [self performSelector:@selector(stepMasterGroupList) withObject:nil afterDelay:RETRY_SECONDS];
    }];
}

-(void) stepMasterBuildingList
{
    self.alertView.label.text           = @"Updating 4/4";
    
    [[GameManager sharedInstance] retrieveMasterBuilding:^(){
        self.alertView.progressBar.progress = 1.0f;
        self.alertView.label.text           = @"Ready...";
        [self performSelector:@selector(dismissLogin) withObject:nil afterDelay:0.75f];
    } setErrorBlock:^(){
        self.alertView.label.text           = [NSString stringWithFormat:@"Retrying..."];
        [self performSelector:@selector(stepMasterBuildingList) withObject:nil afterDelay:RETRY_SECONDS];
    }];
}

#pragma mark Finished
-(void) dismissLogin
{
    // Release Queue
    // Dismiss Bezel / Flag Authenticated / Resume Secondary Queue
    [[GameManager sharedInstance] loginComplete];
    
    [_alertView hide];
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

@end

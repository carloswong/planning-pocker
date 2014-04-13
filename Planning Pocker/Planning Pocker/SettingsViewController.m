//
//  SettingsViewController.m
//  Planning Pocker
//
//  Created by carlos on 14-4-13.
//  Copyright (c) 2014年 CarlosWong. All rights reserved.
//

#import "SettingsViewController.h"
#import "CustomCardSetViewController.h"
#import "Storage.h"

@implementation SettingsViewController
{
    UISwitch *volumeSwitcher;
    UISwitch *sleepSwitcher;
    NSString *customCardSetName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:t(@"desk")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(back)];
 
    self.navigationItem.title = NSLocalizedString(@"setting",nil);
    
    volumeSwitcher = [[UISwitch alloc] init];
    [volumeSwitcher setOn:[[Storage shared] soundEnabled]];
    [volumeSwitcher addTarget:self
                       action:@selector(volumeControl:)
             forControlEvents:UIControlEventValueChanged];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,self.tableView.frame.size.height - 250)];

    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, footer.frame.size.height - 60, footer.frame.size.width, 30)];
    productNameLabel.text = @"Planning Pocker";
    productNameLabel.textColor = [UIColor lightGrayColor];
    productNameLabel.textAlignment = NSTextAlignmentCenter;
    productNameLabel.backgroundColor = [UIColor clearColor];
    [footer addSubview:productNameLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, footer.frame.size.height - 40, footer.frame.size.width, 30)];
    versionLabel.text = [NSString stringWithFormat:@"Version %@(%@) by %@",VERSION, LASTUPDATE, DEVELOPER];
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:12];
    versionLabel.backgroundColor = [UIColor clearColor];
    [footer addSubview:versionLabel];
    
    
    self.tableView.tableFooterView = footer;
}

- (void)volumeControl:(UISwitch *)switcher
{
    [[Storage shared] setSoundEnabled:switcher.on];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = t(@"customize");
    }else if(indexPath.section == 1) {
        cell.textLabel.text = t(@"enable");
        cell.accessoryView = volumeSwitcher;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return nil;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 20, 40)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor grayColor];
    [header addSubview:titleLabel];
    
    NSString *title;
    switch (section) {
        case 0:
            title = t(@"style");
            break;
        case 1:
            title = t(@"audio");
            break;
        default:break;
    }
    
    titleLabel.text = title;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self editCustomCardSet];
    }
}

- (void)editCustomCardSet
{
    CustomCardSetViewController *customSetController = [[CustomCardSetViewController alloc] init];
    
    [self.navigationController pushViewController:customSetController
                                         animated:YES];
}

@end

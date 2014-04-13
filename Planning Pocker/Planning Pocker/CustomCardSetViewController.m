//
//  CustomCardSetViewController.m
//  Planning Pocker
//
//  Created by carlos on 14-4-13.
//  Copyright (c) 2014年 CarlosWong. All rights reserved.
//

#import "CustomCardSetViewController.h"
#import "Storage.h"

@interface CustomCardSetViewController ()
{
    NSUInteger tableViewRows;
    CGFloat inputViewMargin;
    NSMutableArray *numberFields;
}
@end

@implementation CustomCardSetViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        numberFields = [[NSMutableArray alloc] init];
        NSUInteger setCount = [[Storage shared].cardSet count];
        tableViewRows = setCount ? setCount : 1;
        
        if ([[UIDevice currentDevice].systemVersion integerValue] > 6) {
            inputViewMargin = 5;
        }else {
            inputViewMargin = 10;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:t(@"save")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(save)];
    
    self.navigationItem.title = t(@"style");
    [self.tableView setEditing:YES animated:NO];
    [self.tableView setAllowsSelectionDuringEditing:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return tableViewRows;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddCardCell";
    UITableViewCell *cell; //= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger section = indexPath.section;
    if(section == 0) {
        UITextField *numberField;
        if ([numberFields count] > indexPath.row) {
            numberField = [numberFields objectAtIndex:indexPath.row];
        } else {
            numberField = [[UITextField alloc] initWithFrame:CGRectMake(5, inputViewMargin, 300, 40)];
            numberField.placeholder = t(@"card");
            [numberFields addObject:numberField];
    
            NSUInteger setCount = [[Storage shared].cardSet count];
            if (setCount && indexPath.row < setCount) {
                numberField.text = [[Storage shared].cardSet objectAtIndex:indexPath.row];
            }
        }
        [cell.contentView addSubview:numberField];
    } else {
        cell.textLabel.text = t(@"add");
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row != 0) {
        return UITableViewCellEditingStyleDelete;
    }
    
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self addNewItem];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        tableViewRows -= 1;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [numberFields removeObjectAtIndex:indexPath.row];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self addNewItem];
    }
}

- (void)addNewItem
{
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                                  animated:NO];
    
    tableViewRows += 1;
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(tableViewRows-1)
                                                     inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[insertIndexPath]
                     withRowAnimation:UITableViewRowAnimationNone];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row != 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section != destinationIndexPath.section) {
        return;
    }
    
    
    NSUInteger sourceRow = sourceIndexPath.row;
    NSUInteger destRow = destinationIndexPath.row;
    
    UITextField *sourceNumberField = [numberFields objectAtIndex:sourceRow];
    UITextField *destinationNumberField = [numberFields objectAtIndex:destRow];

    NSUInteger lasetRow = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
    
    if (sourceRow == lasetRow || destRow == lasetRow) {
        [numberFields removeObjectAtIndex:sourceRow];
        [numberFields insertObject:sourceNumberField atIndex:destRow];
    }else {
        [numberFields replaceObjectAtIndex:sourceRow withObject:destinationNumberField];
        [numberFields replaceObjectAtIndex:destRow withObject:sourceNumberField];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.section == 0 && proposedDestinationIndexPath.row == 0) {
        return [NSIndexPath indexPathForRow:1 inSection:proposedDestinationIndexPath.section];
    }
    
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}

- (void)save
{
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    for(UITextField *field in numberFields) {
        NSString *number = [field.text stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([number isEqualToString:@""] || number == nil) {
            field.placeholder = t(@"no empty");
            [field becomeFirstResponder];
            NSUInteger index = [numberFields indexOfObject:field];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            return;
        }
        [numbers addObject:number];
    }
    
    [[Storage shared] saveCardSet:numbers];

    [self.navigationController popViewControllerAnimated:YES];
}

@end

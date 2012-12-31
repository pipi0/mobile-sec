//
//  ScanHistoryViewController.m
//  CMCMobileSec
//
//  Created by Duc Tran on 12/27/12.
//  Copyright (c) 2012 CMC. All rights reserved.
//

#import "ScanHistoryViewController.h"

@interface ScanHistoryViewController ()

@end

@implementation ScanHistoryViewController
@synthesize scanHistory;
@synthesize segmentIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil)
    {
        self.title = NSLocalizedString(@"History", @"");
        self.navigationItem.prompt = NSLocalizedString(@"Please select the appropriate history", @"History");
	}
	return self;
}

- (void)viewDidLoad
{
//    [super viewDidLoad];
    self.title = NSLocalizedString(@"History", @"");
    self.navigationItem.prompt = NSLocalizedString(@"Please select the appropriate history", @"History");

    // segmented control as the custom title view
    
	NSArray *segmentTextContent = [NSArray arrayWithObjects:NSLocalizedString(@"SMS", @""), NSLocalizedString(@"Statistics", @""), NSLocalizedString(@"Detected", @""),nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 1;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 400, 30);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	
    defaultTintColor = segmentedControl.tintColor;
	self.navigationItem.titleView = segmentedControl;
	scanHistory = gScanHistory;
    segmentIndex = 1;
   
    // observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHistory) name:@"updateHistory" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (segmentIndex == 1) {
        return [scanHistory count];
    } else{
        return 1;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"history_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    if (segmentIndex == 1){
        NSMutableDictionary* item = [scanHistory objectAtIndex:indexPath.row];
        NSString* time = [item objectForKey:@"time"];
        cell.textLabel.text = time;
        NSString* totalScan = [item objectForKey:@"totalScanned"];
        NSString* totalDetected = [item objectForKey:@"totalDetected"];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.detailTextLabel.numberOfLines = 0;

        cell.detailTextLabel.text = [NSString stringWithFormat:@"Total scanned: %@ files\nTotal detected: %@ files", totalScan, totalDetected];
        //    cell.detailTextLabel.text = @"detail";
    } else{
        cell.textLabel.text = @"text label";
        cell.detailTextLabel.text = @"detail text label";
    }

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (void)viewWillAppear:(BOOL)animated
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)self.navigationItem.rightBarButtonItem.customView;
	
	// Before we show this view make sure the segmentedControl matches the nav bar style
	if (self.navigationController.navigationBar.barStyle == UIBarStyleBlackTranslucent || self.navigationController.navigationBar.barStyle == UIBarStyleBlackOpaque){
        segmentedControl.tintColor = [UIColor darkGrayColor];
    } else{
        segmentedControl.tintColor = defaultTintColor;
    }
    NSLog(@"segment index: %d", segmentIndex);
    
}

- (IBAction)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    segmentIndex = segmentedControl.selectedSegmentIndex;
    [[self tableView] reloadData];
}

- (void) updateHistory{
    NSLog(@"updateHistory is called");
    scanHistory = gScanHistory;
    [[self tableView] reloadData];
}

@end

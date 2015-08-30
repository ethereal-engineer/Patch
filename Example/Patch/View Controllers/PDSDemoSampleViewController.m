//
//  PDSDemoSampleViewController.m
//  Patch
//
//  Created by Adam Iredale on 27/05/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#import "PDSDemoSampleViewController.h"

@interface PDSDemoSampleViewController () <UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *sampledCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *completeCollectionView;

@property (weak, nonatomic) IBOutlet UISlider *sampleSlider;

@property (nonatomic, strong) PDSCollectionViewDataSource *completeCollectionViewDataSource;
@property (nonatomic, strong) PDSCollectionViewDataSource *sampledCollectionViewDataSource;

@property (nonatomic, strong) NSMutableArray *mutableBackingArray;

@property (nonatomic, strong) PDSSampleDataSource *sampledDataSource;

@end

@implementation PDSDemoSampleViewController

#pragma mark - DataSources (move these later)

- (id <PDSDataSource>)colorDataSource
{
    // 256 shades of colour - yay the 90s!
    NSMutableArray *colorArray = [NSMutableArray array];
    for (NSInteger colorOffset = 0; colorOffset < 256; colorOffset++)
    {
        float fraction = (float)colorOffset/255.0;
        [colorArray addObject:[UIColor colorWithRed:1.0 - fraction  green:0.0 blue:fraction alpha:1.0]];
    }
    return [PDSMutableArrayDataSource arrayDataSourceWithArray:colorArray];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set up the collection view datasources
    self.completeCollectionViewDataSource = [PDSCollectionViewDataSource dataSourceWithDataSource:[self colorDataSource]];
    self.completeCollectionViewDataSource.cellAtIndexPathBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath, id itemAtIndexPath)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        UIColor *color = itemAtIndexPath;
        cell.backgroundColor = color;
        UILabel *cellLabel = cell.contentView.subviews.firstObject;
        // set the label to be hue...
        CGFloat hue, saturation, brightness, alpha;
        [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        cellLabel.text = [NSString stringWithFormat:@"%.3f",hue];
        return cell;
    };
    self.completeCollectionView.dataSource = self.completeCollectionViewDataSource;
    self.mutableBackingArray = [(PDSMutableArrayDataSource *)_completeCollectionViewDataSource.dataSource array];
    
    // Now the sampled version (there's an instance variable for easy reference later on)
    self.sampledDataSource = [PDSSampleDataSource dataSourceWithDataSource:self.completeCollectionViewDataSource.dataSource];
    
    self.sampledCollectionViewDataSource = [PDSCollectionViewDataSource dataSourceWithDataSource:self.sampledDataSource];
    // They use the same interpretation of the cells, so...
    self.sampledCollectionViewDataSource.cellAtIndexPathBlock = self.completeCollectionViewDataSource.cellAtIndexPathBlock;
    self.sampledCollectionView.dataSource = self.sampledCollectionViewDataSource;
    // Sync the initial sampling with the slider at 50%
    self.sampledDataSource.maximumCount = self.mutableBackingArray.count / 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    self.sampledDataSource.maximumCount = self.mutableBackingArray.count * sender.value;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Delete the item from the original store and watch it cascade!
    id itemAtIndexPath = [self.completeCollectionViewDataSource.dataSource itemAtIndexPath:indexPath];
    [self.mutableBackingArray removeObject:itemAtIndexPath];
}

@end

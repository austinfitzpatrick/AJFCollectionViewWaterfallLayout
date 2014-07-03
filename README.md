# AJFCollectionViewWaterfallLayout

##Purpose

The default UICollectionViewLayout subclass, UICollectionViewFlowLayout, does a pretty good job of supporting a grid baesd layout but fails
when the items in the same row have differing heights, leaving blank spaces under cells even when another cell could fit underneath.

This type of layout, with a set number of fixed-width columns and variable height cells is called a Waterfall Layout.

There are several implementations of Waterfall layouts for UICollectionView available on the web including the inspiration for this project,
[CHTCollectionViewWaterfallLayout](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout).  In a recent project however I wanted a
waterfall layout in which the number of columns could be altered within the same UICollectionView.  It made sense that each section within
a UICollectionView could request a different number of sections.  This allows more dynamic layouts such as a full-width cell containing filtering
options for many smaller cells below or a layout that features occasional larger hero cells for highly detailed image content.

An example of this layout in action:

![AJFCollectionViewWaterfallLayout in action](http://i.imgur.com/41lWOm6.png)

## Usage

###In a storyboard or xib###

You can choose AJFCollectionViewWaterfallLayout as the layout object for a UICollectionView using the attributes inspector.

![The attributes inspector showing an AJFCollectionViewWaterfallLayout](http://i.imgur.com/qrD7O3V.png)

This is all that you need to set but make sure that the UICollectionView's delegate conforms to the AJFCollectionViewWaterfallLayoutDelegate protocol.


###Programmatically###

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[AJFCollectionViewWaterfallLayout alloc] init]];
    self.collectionView.delegate = self;    //make sure to set a delegate and datasource
    self.collectionView.dataSource = self;

or if you already have a UICollectionView...

    self.collectionView.collectionViewLayout = [[AJFCollectionViewWaterfallLayout alloc] init];

###Required Delegate Functions###

Your UICollectionView's delegate must conform to AJFCollectionViewWaterfallLayoutDelegate.  There are two required delegate functions that
must be implemented.

    - (NSInteger) collectionView:(UICollectionView*) collectionView numberOfColumnsInSection:(NSInteger) section;

Your implementation of this function should return the number of columns in the given section.  The number returned must be greater than 0.

    - (CGSize) collectionView:(UICollectionView*) collectionView layout:(UICollectionViewLayout*) layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

Your implementation of this function should return a suggested size for the cell at the given index path.  The width of the cell will always be the width of the column
as calculated by the AJFCollectionViewWaterfallLayout.  If the width provided here does not match the calculated width the returned size will be used
to calculate a width/height ratio for the cell.  For instance, returning CGSizeMake(1000.0f, 1000.0f) will result in square cells but they might not necessarily
be 1000 points wide and tall.

Note: If you're using cell stretching options other than AJFCollectionViewWaterfallNoStretching even the ratio width to height may not be preserved.  In this case
the ratio will be used to determine the minimum height for the cell but it may be increased to satisfy the requested stretching option.

###Optional Delegate Functions###

    - (NSInteger) collectionView:(UICollectionView*) collectionView layout:(UICollectionViewLayout*) collectionViewLayout columnSpacingForSection:(NSInteger) section;

Use this function to return the desired distance between columns for the given section.

    - (NSInteger) collectionView:(UICollectionView*) collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

Use this function to return the desired distance between cells for the given section.

    - (UIEdgeInsets) collectionView:(UICollectionView*) collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

Use this function to return the desired section insets for the given section.

###Stretching Options###
When implementing a dynamic waterfall layout its likely that your columns will be uneven in height leaving blank space.
Sometimes this is undesirable so AJFCollectionViewWaterfallLayout has a couple options for how to stretch cells to deal with this.

####No Stretching####
    AJFCollectionViewWaterfallLayout *layout = (AJFCollectionViewWaterfallLayout*) self.collectionView.layout;
    layout.stretchingType = AJFCollectionViewWaterfallNoStretching;

This is the default setting and creates UICollectionViews with blank space at the bottom of each column except the tallest one in each section.

![AJFCollectionViewWaterfallLayout with no stretching](http://i.imgur.com/ILo85G3.png)

####Last Cell Stretching####
    AJFCollectionViewWaterfallLayout *layout = (AJFCollectionViewWaterfallLayout*) self.collectionView.layout;
    layout.stretchingType = AJFCollectionViewWaterfallStretchLastCell;

This option will increase the height of the last cell in each column to such that the column's height matches that of the tallest column in the section.

![AJFCollectionViewWaterfallLayout with last cell stretching](http://i.imgur.com/xP6kMNP.png)

####All Cell Stretching####
    AJFCollectionViewWaterfallLayout *layout = (AJFCollectionViewWaterfallLayout*) self.collectionView.layout;
    layout.stretchingType = AJFCollectionViewWaterfallStretchAllCells;

![AJFCollectionViewWaterfallLayout with all cell stretching](http://i.imgur.com/41lWOm6.png)

This option will increase the height of all cells in a column equally such that the new height of the column is equal to that of the tallest column
in the section.

## Requirements

AJFCollectionViewWaterfallLayout requires iOS 6.0 or greater and ARC.

## Installation

AJFCollectionViewWaterfallLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "AJFCollectionViewWaterfallLayout"

## Author

Austin Fitzpatrick, fitzpatrick.austin@gmail.com

## License

AJFCollectionViewWaterfallLayout is available under the MIT license. See the LICENSE file for more info.

//
//  电影详情页面媒体库Cell
//
//  Created by KKZ on 16/2/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieMediaStoreCell.h"

#import "AudioCollectionViewCell.h"
#import "CommonViewController.h"
#import "Gallery.h"
#import "KKZUtility.h"
#import "Movie.h"
#import "MoviePictureCollectionViewCell.h"
#import "MovieStillScrollViewController.h"
#import "Song.h"
#import "Trailer.h"
#import "VideoCollectionViewCell.h"

#import "Movie.h"

#define marginX 15.0f
#define moviePicturesCellHeight 72

#define videoPicturesCellWidth 133
#define audioPicturesCellWidth 97
#define picturePicturesCellWdth 87

#define audioCellIndifier @"audioCell"
#define videoCellIndifier @"videoCell"
#define pictureCellIndifier @"pictureCell"

@implementation MovieMediaStoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加横向滚动列表布局
        moviePictureCollectionFrame = CGRectMake(marginX, 0, screentWith - marginX, moviePicturesCellHeight);
        flowLauout = [[UICollectionViewFlowLayout alloc] init];
        flowLauout.sectionInset = UIEdgeInsetsZero;
        [flowLauout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

        //添加横向滚动列表
        moviePictureCollectionView = [[UICollectionView alloc] initWithFrame:moviePictureCollectionFrame collectionViewLayout:flowLauout];
        moviePictureCollectionView.backgroundColor = [UIColor whiteColor];
        moviePictureCollectionView.showsHorizontalScrollIndicator = FALSE;
        moviePictureCollectionView.delegate = self;
        moviePictureCollectionView.dataSource = self;
        [self addSubview:moviePictureCollectionView];

        [moviePictureCollectionView registerClass:[AudioCollectionViewCell class]
                       forCellWithReuseIdentifier:audioCellIndifier];
        [moviePictureCollectionView registerClass:[VideoCollectionViewCell class]
                       forCellWithReuseIdentifier:videoCellIndifier];
        [moviePictureCollectionView registerClass:[MoviePictureCollectionViewCell class]
                       forCellWithReuseIdentifier:pictureCellIndifier];
    }
    return self;
}

- (void)reloadTableData {
    [moviePictureCollectionView reloadData];
}

- (void)layoutSubviews {
    moviePictureCollectionView.frame = moviePictureCollectionFrame;
}

#pragma mark - setter Method
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [moviePictureCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (section == 0 && self.movieTrailerTotal) {
        return 1;
    } else if (section == 1 && self.movieSongTotal) {
        return 1;
    } else if (section == 2 && self.movieGalleryTotal) {
        return self.movieGalleryArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && self.movieTrailerArray.count) {
        VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:videoCellIndifier forIndexPath:indexPath];
        if (self.movieTrailerArray.count) {
            Trailer *trailer = self.movieTrailerArray[0];
            if (trailer.trailerCover.length) {
                cell.imagePath = trailer.trailerCover;
            } else {
                if (self.movie.thumbPath.length) {
                    cell.imagePath = self.movie.thumbPath;
                } else {
                    cell.imagePath = self.movie.pathVerticalS;
                }
            }
        }
        cell.movie = self.movie;
        cell.videoSource = self.movieTrailerArray;
        [cell upLoadData];
        return cell;

    } else if (indexPath.section == 1 && self.movieSongArray.count) {
        AudioCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:audioCellIndifier forIndexPath:indexPath];
        if (self.movie.thumbPath.length) {
            cell.imagePath = self.movie.thumbPath;
        } else {
            cell.imagePath = self.movie.pathVerticalS;
        }
        cell.movie = self.movie;
        [cell upLoadData];
        return cell;
    } else if (indexPath.section == 2 && self.movieGalleryArray.count) {
        MoviePictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureCellIndifier forIndexPath:indexPath];
        if (self.movieGalleryArray.count) {
            Gallery *trailer = self.movieGalleryArray[indexPath.row];
            cell.imagePath = trailer.imageSmall;
        }

        [cell upLoadData];
        return cell;
    }

    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.movieTrailerArray.count) {
        flowLauout.minimumLineSpacing = 10;
        CGSize itemSize = CGSizeMake(videoPicturesCellWidth, moviePicturesCellHeight);
        return itemSize;
    } else if (indexPath.section == 1 && self.movieSongArray.count) {
        flowLauout.minimumLineSpacing = 10;
        CGSize itemSize = CGSizeMake(audioPicturesCellWidth, moviePicturesCellHeight);
        return itemSize;
    } else if (indexPath.section == 2 && self.movieGalleryArray.count) {
        flowLauout.minimumLineSpacing = 3;
        CGSize itemSize = CGSizeMake(picturePicturesCellWdth, moviePicturesCellHeight);
        return itemSize;
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    if (section == 0 && self.movieTrailerArray.count) {
        CGFloat minimumLineSpacing = 10;
        return minimumLineSpacing;
    } else if (section == 1 && self.movieSongArray.count) {
        CGFloat minimumLineSpacing = 10;
        return minimumLineSpacing;
    } else if (section == 2 && self.movieGalleryArray.count) {
        CGFloat minimumLineSpacing = 3;
        return minimumLineSpacing;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && self.movieGalleryArray.count) {

        MovieStillScrollViewController *ctr = [[MovieStillScrollViewController alloc] init];
        ctr.isMovie = YES;
        ctr.index = indexPath.row;
        ctr.gallerys = [NSMutableArray arrayWithArray:self.movieGalleryArray];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
    }
}

@end

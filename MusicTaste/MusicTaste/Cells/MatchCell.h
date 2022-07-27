//
//  MatchCell.h
//  MusicTaste
//
//  Created by Aman Abraham on 7/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *matchImage;
@property (weak, nonatomic) IBOutlet UILabel *matchName;
@property (weak, nonatomic) IBOutlet UILabel *matchArtists;
@property (weak, nonatomic) IBOutlet UILabel *matchGenres;
@end

NS_ASSUME_NONNULL_END

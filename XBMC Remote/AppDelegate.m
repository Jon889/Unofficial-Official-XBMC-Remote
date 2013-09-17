//
//  AppDelegate.m
//  XBMC Remote
//
//  Created by Giovanni Messina on 23/3/12.
//  Copyright (c) 2012 joethefox inc. All rights reserved.
//

#import "AppDelegate.h"
#import "mainMenu.h"
#import "MasterViewController.h"
#import "ViewControllerIPad.h"
#import "GlobalData.h"
#import <arpa/inet.h>
#import "InitialSlidingViewController.h"
#import "UIImageView+WebCache.h"

@implementation AppDelegate

NSMutableArray *mainMenuItems;
NSMutableArray *hostRightMenuItems;

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize windowController = _windowController;
@synthesize dataFilePath;
@synthesize arrayServerList;
@synthesize serverOnLine;
@synthesize serverVersion;
@synthesize serverMinorVersion;
@synthesize obj;
@synthesize playlistArtistAlbums;
@synthesize playlistMovies;
@synthesize playlistTvShows;
@synthesize rightMenuItems;
@synthesize serverName;
@synthesize nowPlayingMenuItems;
@synthesize serverVolume;
@synthesize remoteControlMenuItems;

+ (AppDelegate *) instance {
	return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark init

- (id) init {
	if ((self = [super init])) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        self.dataFilePath = [documentsDirectory stringByAppendingPathComponent:@"serverList_saved.dat"];
        NSFileManager *fileManager1 = [NSFileManager defaultManager];
        if ([fileManager1 fileExistsAtPath:self.dataFilePath]) {
            NSMutableArray *tempArray;
            tempArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.dataFilePath];
            [self setArrayServerList:tempArray];
        } else {
            arrayServerList = [[NSMutableArray alloc] init];
        }
        NSString *fullNamespace = @"LibraryCache";
        paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        self.libraryCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
        if (![fileManager1 fileExistsAtPath:self.libraryCachePath]) {
            [fileManager1 createDirectoryAtPath:self.libraryCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
	return self;
	
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    if ([[userDefaults objectForKey:@"lang_preference"] length]) {
        [userDefaults setObject:@[[userDefaults objectForKey:@"lang_preference"]] forKey:@"AppleLanguages"];
        [userDefaults synchronize];
    }
    else {
         [userDefaults removeObjectForKey:@"AppleLanguages"];
    }
    UIApplication *xbmcRemote = [UIApplication sharedApplication];
    if ([[userDefaults objectForKey:@"lockscreen_preference"] boolValue] == YES) {
        xbmcRemote.idleTimerDisabled = YES;
    }
    else {
        xbmcRemote.idleTimerDisabled = NO;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    int thumbWidth;
    int tvshowHeight;
    NSString *filemodeRowHeight = @"44";
    NSString *filemodeThumbWidth = @"44";
    NSString *livetvThumbWidth = @"64";

    NSString *filemodeVideoType = @"video";
    NSString *filemodeMusicType = @"music";
    if ([[userDefaults objectForKey:@"fileType_preference"] boolValue] == YES) {
        filemodeVideoType = @"files";
        filemodeMusicType = @"files";
    }
    
    obj = [GlobalData getInstance];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        thumbWidth = PHONE_TV_SHOWS_BANNER_WIDTH;
        tvshowHeight = PHONE_TV_SHOWS_BANNER_HEIGHT;
        NSDictionary *navbarTitleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithRed:1 green:1 blue:1 alpha:1],
                                                   UITextAttributeFont: [UIFont boldSystemFontOfSize:18]};
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    }
    else {
        thumbWidth = PAD_TV_SHOWS_BANNER_WIDTH;
        tvshowHeight = PAD_TV_SHOWS_BANNER_HEIGHT;
    }
    
    float itemMusicWidthIphone = 106.0f;
    float itemMusicHeightIphone = 106.0f;
    
    float itemMusicWidthIpad = 119.0f;
    float itemMusicHeightIpad = 119.0f;
    
    float itemMusicWidthLargeIpad = 158.0f;
    float itemMusicHeightLargeIpad = 158.0f;
    
    float itemMovieWidthIphone = 106.0f;
    float itemMovieHeightIphone = 151.0f;
    
    float itemMovieWidthIpad = 119.0f;
    float itemMovieHeightIpad = 170.0f;
    
    float itemMovieWidthLargeIpad = 158.0f;
    float itemMovieHeightLargeIpad =  230.0f;
    
    float itemMovieHeightRecentlyIphone =  132.0f;
    float itemMovieHeightRecentlyIpad =  196.0f;
    
    [self.window makeKeyAndVisible];
    
    mainMenuItems = [NSMutableArray arrayWithCapacity:1];
    mainMenu *item1 = [[mainMenu alloc] init];
    mainMenu *item2 = [[mainMenu alloc] init];
    mainMenu *item3 = [[mainMenu alloc] init];
    mainMenu *item4 = [[mainMenu alloc] init];
    mainMenu *item5 = [[mainMenu alloc] init];
    mainMenu *item6 = [[mainMenu alloc] init];
    mainMenu *item7 = [[mainMenu alloc] init];

    item1.subItem = [[mainMenu alloc] init];
    item1.subItem.subItem = [[mainMenu alloc] init];
    
    item2.subItem = [[mainMenu alloc] init];
    item2.subItem.subItem = [[mainMenu alloc] init];
    
    item3.subItem = [[mainMenu alloc] init];
    item3.subItem.subItem = [[mainMenu alloc] init];
    
    item4.subItem = [[mainMenu alloc] init];
    item4.subItem.subItem = [[mainMenu alloc] init];
    
#pragma mark - Music
    item1.mainLabel = NSLocalizedString(@"Music", nil);
    item1.upperLabel = NSLocalizedString(@"Listen to", nil);
    item1.icon = @"icon_home_music_alt";
    item1.family = 1;
    item1.enableSection = YES;
    item1.mainButtons = @[@"st_album", @"st_artist", @"st_genre", @"st_filemode", @"st_album_recently", @"st_songs_recently", @"st_album_top100", @"st_songs_top100", @"st_album_recently_played", @"st_songs_recently_played", @"st_song", @"st_addons", @"st_music_playlist"]; //
    
    item1.mainMethod = [NSMutableArray arrayWithObjects:
                      
                      @[@"AudioLibrary.GetAlbums", @"method",
                       @"AudioLibrary.GetAlbumDetails", @"extra_info_method"],
                      
                      @[@"AudioLibrary.GetArtists", @"method",
                       @"AudioLibrary.GetArtistDetails", @"extra_info_method"],
                      
                      @[@"AudioLibrary.GetGenres", @"method"],
                      
                      @[@"Files.GetSources", @"method"],
                      
                      @[@"AudioLibrary.GetRecentlyAddedAlbums", @"method",
                       @"AudioLibrary.GetAlbumDetails", @"extra_info_method"],
                      
                      @[@"AudioLibrary.GetRecentlyAddedSongs", @"method"],
                      
                      @[@"AudioLibrary.GetAlbums", @"method",
                       @"AudioLibrary.GetAlbumDetails", @"extra_info_method"],
                      
                      @[@"AudioLibrary.GetSongs", @"method"],
                      
                      @[@"AudioLibrary.GetRecentlyPlayedAlbums", @"method"],
                      
                      @[@"AudioLibrary.GetRecentlyPlayedSongs", @"method"],
                      
                      @[@"AudioLibrary.GetSongs", @"method"],
                      
                      @[@"Files.GetDirectory", @"method"],
                      
                      @[@"Files.GetDirectory", @"method"],
                      
                      nil];
    
    item1.mainParameters = [NSMutableArray arrayWithObjects:
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},@"sort",
                            @[@"year", @"thumbnail", @"artist"], @"properties",
                            nil],  @"parameters", NSLocalizedString(@"Albums", nil), @"label", @"Album", @"wikitype",
                           @{@"properties": @[@"year", @"thumbnail", @"artist", @"genre", @"description", @"albumlabel", @"fanart"]}, @"extra_info_parameters",
                           @"6", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",
                           @"YES", @"enableLibraryCache",
                           @{@"iphone": @{@"width": @(itemMusicWidthIphone),
                             @"height": @(itemMusicHeightIphone)},
                            @"ipad": @{@"width": @(itemMusicWidthIpad),
                             @"height": @(itemMusicHeightIpad)}}, @"itemSizes",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},@"sort",
                            @[@"thumbnail", @"genre"], @"properties",
                            nil], @"parameters", NSLocalizedString(@"Artists", nil), @"label", @"nocover_artist", @"defaultThumb", @"Artist", @"wikitype",
                           @{@"properties": @[@"thumbnail", @"genre", @"instrument", @"style", @"mood", @"born", @"formed", @"description", @"died", @"disbanded", @"yearsactive", @"fanart"]}, @"extra_info_parameters",
                           @"7", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",
                           @"YES", @"enableLibraryCache",
                           @{@"iphone": @{@"width": @(itemMusicWidthIphone),
                             @"height": @(itemMusicHeightIphone)},
                            @"ipad": @{@"width": @(itemMusicWidthIpad),
                             @"height": @(itemMusicHeightIpad)}}, @"itemSizes",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},@"sort",
                            @[@"thumbnail"], @"properties",
                            nil], @"parameters", NSLocalizedString(@"Genres", nil), @"label", @"nocover_genre.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth",
                           @"YES", @"enableLibraryCache",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},@"sort",
                            @"music", @"media",
                            nil], @"parameters", NSLocalizedString(@"Files", nil), @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"none"},@"sort",
                            @[@"year", @"thumbnail", @"artist"], @"properties",
                            nil],  @"parameters", NSLocalizedString(@"Added Albums", nil), @"label", @"Album", @"wikitype", NSLocalizedString(@"Recently added albums", nil), @"morelabel",
                           @{@"properties": @[@"year", @"thumbnail", @"artist", @"genre", @"description", @"albumlabel", @"fanart"]}, @"extra_info_parameters",
                           @"10", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",

                           @{@"iphone": @{@"width": @(itemMusicWidthIphone),
                             @"height": @(itemMusicHeightIphone)},
                            @"ipad": @{@"width": @(itemMusicWidthIpad),
                             @"height": @(itemMusicHeightIpad)}}, @"itemSizes",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"none"},@"sort",
                            //                            [NSDictionary dictionaryWithObjectsAndKeys:
                            //                             [NSNumber numberWithInt:0], @"start",
                            //                             [NSNumber numberWithInt:99], @"end",
                            //                             nil], @"limits",
                            @[@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file"], @"properties",
                            nil], @"parameters", NSLocalizedString(@"Added Songs", nil), @"label", NSLocalizedString(@"Recently added songs", nil), @"morelabel", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"descending",
                             @"ignorearticle": @NO,
                             @"method": @"playcount"},@"sort",
                            @{@"start": @0,
                             @"end": @100}, @"limits",
                            @[@"year", @"thumbnail", @"artist",  @"playcount"], @"properties",
                            nil],  @"parameters", NSLocalizedString(@"Top 100 Albums", nil), @"label", @"Album", @"wikitype", NSLocalizedString(@"Top 100 Albums", nil), @"morelabel",
                           @{@"properties": @[@"year", @"thumbnail", @"artist", @"genre", @"description", @"albumlabel", @"fanart"]}, @"extra_info_parameters",
                           @"11", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",

                           @{@"iphone": @{@"width": @(itemMusicWidthIphone),
                             @"height": @(itemMusicHeightIphone)},
                            @"ipad": @{@"width": @(itemMusicWidthIpad),
                             @"height": @(itemMusicHeightIpad)}}, @"itemSizes",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"descending",
                             @"ignorearticle": @NO,
                             @"method": @"playcount"},@"sort",
                            @{@"start": @0,
                             @"end": @100}, @"limits",
                            @[@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file"], @"properties",
                            nil], @"parameters", NSLocalizedString(@"Top 100 Songs", nil), @"label", NSLocalizedString(@"Top 100 Songs", nil), @"morelabel", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"none"},@"sort",
                            @[@"year", @"thumbnail", @"artist"], @"properties",//@"genre", @"description", @"albumlabel", @"fanart",
                            nil], @"parameters", NSLocalizedString(@"Played albums", nil), @"label", @"Album", @"wikitype", NSLocalizedString(@"Recently played albums", nil), @"morelabel",
                           @"12", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",

                           @{@"iphone": @{@"width": @(itemMusicWidthIphone),
                             @"height": @(itemMusicHeightIphone)},
                            @"ipad": @{@"width": @(itemMusicWidthIpad),
                             @"height": @(itemMusicHeightIpad)}}, @"itemSizes",nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"none"}, @"sort",
                            //                            [NSDictionary dictionaryWithObjectsAndKeys:
                            //                             [NSNumber numberWithInt:0], @"start",
                            //                             [NSNumber numberWithInt:99], @"end",
                            //                             nil], @"limits",
                            @[@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file"], @"properties",
                            nil], @"parameters", NSLocalizedString(@"Played songs", nil), @"label", NSLocalizedString(@"Recently played songs", nil), @"morelabel", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"none"},@"sort",
                            @[@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file"], @"properties",
                            nil], @"parameters", NSLocalizedString(@"All songs", nil), @"label", NSLocalizedString(@"All songs", nil), @"morelabel",
                           @"YES", @"enableLibraryCache",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},@"sort",
                            @"music", @"media",
                            @"addons://sources/audio", @"directory",
                            @[@"thumbnail", @"file"], @"properties",
                            nil], @"parameters", NSLocalizedString(@"Music Addons", nil), @"label", NSLocalizedString(@"Music Addons", nil), @"morelabel", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth",
                           @"13", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",

                           @{@"iphone": @{@"width": @(itemMusicWidthIphone),
                             @"height": @(itemMusicHeightIphone)},
                            @"ipad": @{@"width": @(itemMusicWidthIpad),
                             @"height": @(itemMusicHeightIpad)}}, @"itemSizes",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},@"sort",
                            @"music", @"media",
                            @"special://musicplaylists", @"directory",
                            @[@"thumbnail", @"file", @"artist", @"album", @"duration"], @"properties",
                            @[@"thumbnail", @"file", @"artist", @"album", @"duration"], @"file_properties",
                            nil], @"parameters", NSLocalizedString(@"Music Playlists", nil), @"label", NSLocalizedString(@"Music Playlists", nil), @"morelabel", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth",
                           @"YES", @"isMusicPlaylist",
                           nil],
                          
                          
                          nil];
    
    item1.mainFields = @[@{@"itemid": @"albums",
                       @"row1": @"label",
                       @"row2": @"artist",
                       @"row3": @"year",
                       @"row4": @"fanart",
                       @"row5": @"rating",
                       @"row6": @"albumid",
                       @"playlistid": @0,
                       @"row8": @"albumid",
                       @"row9": @"albumid",
                       @"row10": @"artist",
                       @"row11": @"genre",
                       @"row12": @"description",
                       @"row13": @"albumlabel",
                       @"itemid_extra_info": @"albumdetails"},
                      
                      @{@"itemid": @"artists",
                       @"row1": @"label",
                       @"row2": @"genre",
                       @"row3": @"yearsactive",
                       @"row4": @"genre",
                       @"row5": @"disbanded",
                       @"row6": @"artistid",
                       @"playlistid": @0,
                       @"row8": @"artistid",
                       @"row9": @"artistid",
                       @"row10": @"formed",
                       @"row11": @"artistid",
                       @"row12": @"description",
                       @"row13": @"instrument",
                       @"row14": @"style",
                       @"row15": @"mood",
                       @"row16": @"born",
                       @"row17": @"formed",
                       @"row18": @"died",
                       @"itemid_extra_info": @"artistdetails"},
                      
                      @{@"itemid": @"genres",
                       @"row1": @"label",
                       @"row2": @"genre",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"genreid",
                       @"playlistid": @0,
                       @"row8": @"genreid",
                       @"row9": @"genreid"},
                      
                      @{@"itemid": @"sources",
                       @"row1": @"label",
                       @"row2": @"year",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"file",
                       @"playlistid": @0,
                       @"row8": @"file",
                       @"row9": @"file"},
                      
                      @{@"itemid": @"albums",
                       @"row1": @"label",
                       @"row2": @"artist",
                       @"row3": @"year",
                       @"row4": @"fanart",
                       @"row5": @"rating",
                       @"row6": @"albumid",
                       @"playlistid": @0,
                       @"row8": @"albumid",
                       @"row9": @"albumid",
                       @"row10": @"artist",
                       @"row11": @"genre",
                       @"row12": @"description",
                       @"row13": @"albumlabel",
                       @"itemid_extra_info": @"albumdetails"},
                      
                      @{@"itemid": @"songs",
                       @"row1": @"label",
                       @"row2": @"artist",
                       @"row3": @"year",
                       @"row4": @"duration",
                       @"row5": @"rating",
                       @"row6": @"songid",
                       @"row7": @"track",
                       @"row8": @"songid",
                       @"playlistid": @0,
                       @"row9": @"songid",
                       @"row10": @"file",
                       @"row11": @"artist"},
                      
                      @{@"itemid": @"albums",
                       @"row1": @"label",
                       @"row2": @"artist",
                       @"row3": @"year",
                       @"row4": @"fanart",
                       @"row5": @"rating",
                       @"row6": @"albumid",
                       @"playlistid": @0,
                       @"row8": @"albumid",
                       @"row9": @"albumid",
                       @"row10": @"artist",
                       @"row11": @"genre",
                       @"row12": @"description",
                       @"row13": @"albumlabel",
                       @"row14": @"playcount",
                       @"itemid_extra_info": @"albumdetails"},
                      
                      @{@"itemid": @"songs",
                       @"row1": @"label",
                       @"row2": @"artist",
                       @"row3": @"year",
                       @"row4": @"duration",
                       @"row5": @"rating",
                       @"row6": @"songid",
                       @"row7": @"track",
                       @"row8": @"songid",
                       @"playlistid": @0,
                       @"row9": @"songid",
                       @"row10": @"file",
                       @"row11": @"artist"},
                      
                      @{@"itemid": @"albums",
                       @"row1": @"label",
                       @"row2": @"artist",
                       @"row3": @"year",
                       @"row4": @"fanart",
                       @"row5": @"rating",
                       @"row6": @"albumid",
                       @"playlistid": @0,
                       @"row8": @"albumid",
                       @"row9": @"albumid",
                       @"row10": @"artist"},
                      
                      @{@"itemid": @"songs",
                       @"row1": @"label",
                       @"row2": @"artist",
                       @"row3": @"year",
                       @"row4": @"duration",
                       @"row5": @"rating",
                       @"row6": @"songid",
                       @"row7": @"track",
                       @"row8": @"songid",
                       @"playlistid": @0,
                       @"row9": @"songid",
                       @"row10": @"file",
                       @"row11": @"artist"},
                      
                      @{@"itemid": @"songs",
                       @"row1": @"label",
                       @"row2": @"artist",
                       @"row3": @"year",
                       @"row4": @"duration",
                       @"row5": @"rating",
                       @"row6": @"songid",
                       @"row7": @"track",
                       @"row8": @"songid",
                       @"playlistid": @0,
                       @"row9": @"songid",
                       @"row10": @"file",
                       @"row11": @"artist"},
                      
                      @{@"itemid": @"files",
                       @"row1": @"label",
                       @"row2": @"year",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"file",
                       @"playlistid": @0,
                       @"row8": @"file",
                       @"row9": @"file"},
                      
                      @{@"itemid": @"files",
                       @"row1": @"label",
                       @"row2": @"artist",
                       @"row3": @"year",
                       @"row4": @"duration",
                       @"row5": @"filetype",
                       @"row6": @"file",
                       @"playlistid": @0,
                       @"row8": @"file",
                       @"row9": @"file",
                       @"row10": @"filetype",
                       @"row11": @"type"}];
    item1.rowHeight = 53;
    item1.thumbWidth = 53;
    item1.defaultThumb = @"nocover_music";
    
    item1.sheetActions = @[@[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Play in shuffle mode", nil), NSLocalizedString(@"Album Details", nil), NSLocalizedString(@"Search Wikipedia", nil)],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Play in shuffle mode", nil), NSLocalizedString(@"Artist Details", nil), NSLocalizedString(@"Search Wikipedia", nil), NSLocalizedString(@"Search last.fm charts", nil)],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Play in shuffle mode", nil)],
                        @[],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Play in shuffle mode", nil), NSLocalizedString(@"Album Details", nil), NSLocalizedString(@"Search Wikipedia", nil)],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Play in shuffle mode", nil), NSLocalizedString(@"Album Details", nil), NSLocalizedString(@"Search Wikipedia", nil)],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Play in shuffle mode", nil), NSLocalizedString(@"Album Details", nil), NSLocalizedString(@"Search Wikipedia", nil)],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                        @[],
                        [NSMutableArray arrayWithObjects:NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Show Content", nil), nil]];
    
    item1.subItem.mainMethod = [NSMutableArray arrayWithObjects:
                              
                              @[@"AudioLibrary.GetSongs", @"method", @"YES", @"albumView"],
                              
                              @[@"AudioLibrary.GetAlbums", @"method",
                               @"AudioLibrary.GetAlbumDetails", @"extra_info_method"],
                              
                              @[@"AudioLibrary.GetAlbums", @"method",
                               @"AudioLibrary.GetAlbumDetails", @"extra_info_method"],
                              
                              @[@"Files.GetDirectory", @"method"],
                              
                              @[@"AudioLibrary.GetSongs", @"method",
                               @"YES", @"albumView"],
                              
                              @[],
                              
                              @[@"AudioLibrary.GetSongs", @"method",
                               @"YES", @"albumView"],
                              
                              @[],
                              
                              @[@"AudioLibrary.GetSongs", @"method",
                               @"YES", @"albumView"],
                              
                              @[],
                              
                              @[],
                              
                              @[@"Files.GetDirectory", @"method"],
                              
                              @[],
//                              [NSArray arrayWithObjects:@"Files.GetDirectory", @"method", nil],
                              
                              nil];
    item1.subItem.mainParameters = [NSMutableArray arrayWithObjects:
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"track"},@"sort",
                                    @[@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file"], @"properties",
                                    nil], @"parameters", @"Songs", @"label", nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"year"},@"sort",
                                    @[@"year", @"thumbnail", @"artist"], @"properties",
                                    nil],  @"parameters", @"Albums", @"label", @"Album", @"wikitype",
                                   @{@"properties": @[@"year", @"thumbnail", @"artist", @"genre", @"description", @"albumlabel", @"fanart"]}, @"extra_info_parameters",
                                   @"YES", @"enableCollectionView",
                                   @"8", @"collectionViewUniqueKey",
                                   @{@"iphone": @{@"width": @(itemMusicWidthIphone),
                                     @"height": @(itemMusicHeightIphone)},
                                    @"ipad": @{@"width": @(itemMusicWidthLargeIpad),
                                     @"height": @(itemMusicHeightLargeIpad)}}, @"itemSizes",
                                   nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"label"},@"sort",
                                    @[@"year", @"thumbnail", @"artist"], @"properties",
                                    nil],  @"parameters", @"Albums", @"label", @"Album", @"wikitype",
                                   @{@"properties": @[@"year", @"thumbnail", @"artist", @"genre", @"description", @"albumlabel", @"fanart"]}, @"extra_info_parameters",
                                   @"YES", @"enableCollectionView",
                                   @"9", @"collectionViewUniqueKey",
                                   @"YES", @"enableLibraryCache",
                                   @{@"iphone": @{@"width": @(itemMusicWidthIphone),
                                     @"height": @(itemMusicHeightIphone)},
                                    @"ipad": @{@"width": @(itemMusicWidthIpad),
                                     @"height": @(itemMusicHeightIpad)}}, @"itemSizes",
                                   nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"label"},@"sort",
                                    filemodeMusicType, @"media",
                                    nil], @"parameters", @"Files", @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"track"},@"sort",
                                    @[@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file"], @"properties",
                                    nil], @"parameters", @"Songs", @"label", nil],
                                  
                                  @[],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"track"},@"sort",
                                    @[@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file"], @"properties",
                                    nil], @"parameters", @"Songs", @"label", nil],
                                  
                                  @[],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"track"},@"sort",
                                    @[@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file"], @"properties",
                                    nil], @"parameters", @"Songs", @"label", nil],
                                  
                                  @[],
                                  
                                  @[],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"none"},@"sort",
                                    @[@"thumbnail"], @"file_properties",
                                    @"music", @"media",
                                    nil], @"parameters", @"Files", @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", @"53", @"thumbWidth",
                                   @"YES", @"enableCollectionView",
                                   @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                                     @"height": @(itemMovieWidthIphone)},
                                    @"ipad": @{@"width": @(itemMovieWidthIpad),
                                     @"height": @(itemMovieWidthIpad)}}, @"itemSizes",
                                   nil],
                                  
//                                  [NSArray arrayWithObjects:nil],
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"none"},@"sort",
                                    @[@"thumbnail", @"artist", @"duration"], @"file_properties",
                                    @"music", @"media",
                                    nil], @"parameters", @"Files", @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", @"53", @"thumbWidth", nil],
                                  
                                  nil];
    item1.subItem.mainFields = @[@{@"itemid": @"songs",
                               @"row1": @"label",
                               @"row2": @"artist",
                               @"row3": @"year",
                               @"row4": @"duration",
                               @"row5": @"rating",
                               @"row6": @"songid",
                               @"row7": @"track",
                               @"row8": @"albumid",
                               @"playlistid": @0,
                               @"row9": @"songid",
                               @"row10": @"file",
                               @"row11": @"artist"},
                              
                              @{@"itemid": @"albums",
                               @"row1": @"label",
                               @"row2": @"artist",
                               @"row3": @"year",
                               @"row4": @"fanart",
                               @"row5": @"rating",
                               @"row6": @"albumid",
                               @"playlistid": @0,
                               @"row8": @"albumid",
                               @"row9": @"albumid",
                               @"row10": @"artist",
                               @"row11": @"genre",
                               @"row12": @"description",
                               @"row13": @"albumlabel",
                               @"itemid_extra_info": @"albumdetails"},
                              
                              @{@"itemid": @"albums",
                               @"row1": @"label",
                               @"row2": @"artist",
                               @"row3": @"year",
                               @"row4": @"fanart",
                               @"row5": @"rating",
                               @"row6": @"albumid",
                               @"playlistid": @0,
                               @"row8": @"albumid",
                               @"row9": @"albumid",
                               @"row10": @"artist",
                               @"row11": @"genre",
                               @"row12": @"description",
                               @"row13": @"albumlabel",
                               @"itemid_extra_info": @"albumdetails"},
                              
                              @{@"itemid": @"files",
                               @"row1": @"label",
                               @"row2": @"filetype",
                               @"row3": @"filetype",
                               @"row4": @"filetype",
                               @"row5": @"filetype",
                               @"row6": @"file",
                               @"playlistid": @0,
                               @"row8": @"file",
                               @"row9": @"file",
                               @"row10": @"filetype",
                               @"row11": @"type"},
                              
                              @{@"itemid": @"songs",
                               @"row1": @"label",
                               @"row2": @"artist",
                               @"row3": @"year",
                               @"row4": @"duration",
                               @"row5": @"rating",
                               @"row6": @"songid",
                               @"row7": @"track",
                               @"row8": @"albumid",
                               @"playlistid": @0,
                               @"row9": @"songid",
                               @"row10": @"file",
                               @"row11": @"artist"},
                              
                              @{},
                              
                              @{@"itemid": @"songs",
                               @"row1": @"label",
                               @"row2": @"artist",
                               @"row3": @"year",
                               @"row4": @"duration",
                               @"row5": @"rating",
                               @"row6": @"songid",
                               @"row7": @"track",
                               @"row8": @"albumid",
                               @"playlistid": @0,
                               @"row9": @"songid",
                               @"row10": @"file",
                               @"row11": @"artist"},
                              
                              @{},
                              
                              @{@"itemid": @"songs",
                               @"row1": @"label",
                               @"row2": @"artist",
                               @"row3": @"year",
                               @"row4": @"duration",
                               @"row5": @"rating",
                               @"row6": @"songid",
                               @"row7": @"track",
                               @"row8": @"albumid",
                               @"playlistid": @0,
                               @"row9": @"songid",
                               @"row10": @"file",
                               @"row11": @"artist"},
                              
                              @{},
                              
                              @{},
                              
                              @{@"itemid": @"files",
                               @"row1": @"label",
                               @"row2": @"filetype",
                               @"row3": @"filetype",
                               @"row4": @"filetype",
                               @"row5": @"filetype",
                               @"row6": @"file",
                               @"playlistid": @0,
                               @"row8": @"file",
                               @"row9": @"file",
                               @"row10": @"filetype",
                               @"row11": @"type"},
                              
//                              [NSDictionary dictionaryWithObjectsAndKeys: nil],
                              @{@"itemid": @"files",
                               @"row1": @"label",
                               @"row2": @"artist",
                               @"row3": @"year",
                               @"row4": @"duration",
                               @"row5": @"filetype",
                               @"row6": @"file",
                               @"playlistid": @0,
                               @"row8": @"file",
                               @"row9": @"file",
                               @"row10": @"filetype",
                               @"row11": @"type"}];
    item1.subItem.enableSection = NO;
    item1.subItem.rowHeight = 53;
    item1.subItem.thumbWidth = 53;
    item1.subItem.defaultThumb = @"nocover_music";
    item1.subItem.sheetActions = @[@[NSLocalizedString(@"Queue after current", nil),  NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)], //@"Stream to iPhone",
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Play in shuffle mode", nil), NSLocalizedString(@"Album Details", nil), NSLocalizedString(@"Search Wikipedia", nil)],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Play in shuffle mode", nil), NSLocalizedString(@"Album Details", nil), NSLocalizedString(@"Search Wikipedia", nil)],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Play in shuffle mode", nil)],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
//                                [NSArray arrayWithObjects:nil],
                                @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)]];//, @"Stream to iPhone"
    item1.subItem.originYearDuration = 248;
    item1.subItem.widthLabel = 252;
    item1.subItem.showRuntime = @[@YES,
                               @NO,
                               @NO,
                               @YES,
                               @YES,
                               @YES,
                               @YES,
                               @YES,
                               @YES,
                               @YES,
                               @YES,
                               @YES,
                               @YES];
    
    item1.subItem.subItem.mainMethod = [NSMutableArray arrayWithObjects:
                                      
                                      @[],
                                      
                                      @[@"AudioLibrary.GetSongs", @"method", @"YES", @"albumView"],
                                      
                                      @[@"AudioLibrary.GetSongs", @"method", @"YES", @"albumView"],
                                      
                                      @[@"Files.GetDirectory", @"method"],
                                      
                                      @[],
                                      
                                      @[],
                                      
                                      @[],
                                      @[],
                                      @[],
                                      @[],
                                      @[],
                                      @[@"Files.GetDirectory", @"method"],
//                                      [NSArray arrayWithObjects:nil],
                                      @[@"Files.GetDirectory", @"method"],
                                      nil];
    
    item1.subItem.subItem.mainParameters = [NSMutableArray arrayWithObjects:
                                          
                                          @[],
                                          
                                          [NSMutableArray arrayWithObjects:
                                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            @{@"order": @"ascending",
                                             @"ignorearticle": @NO,
                                             @"method": @"track"},@"sort",
                                            @[@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file"], @"properties",
                                            nil], @"parameters", @"Songs", @"label", nil],
                                          
                                          [NSMutableArray arrayWithObjects:
                                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            @{@"order": @"ascending",
                                             @"ignorearticle": @NO,
                                             @"method": @"track"},@"sort",
                                            @[@"genre", @"year", @"duration", @"track", @"thumbnail", @"rating", @"playcount", @"artist", @"albumid", @"file"], @"properties",
                                            nil], @"parameters", @"Songs", @"label", nil],
                                          
                                          @[],
                                          
                                          @[],
                                          
                                          @[],
                                          
                                          @[],
                                          
                                          @[],
                                          
                                          @[],
                                          
                                          @[],
                                          
                                          @[],
                                          
                                          [NSMutableArray arrayWithObjects:filemodeRowHeight, @"rowHeight", @"53", @"thumbWidth", nil],
                                          
//                                          [NSArray arrayWithObjects:nil],
                                          [NSMutableArray arrayWithObjects:filemodeRowHeight, @"rowHeight", @"53", @"thumbWidth", nil],
                                          
                                          nil];
    item1.subItem.subItem.mainFields = @[@[],
                                      
                                      @{@"itemid": @"songs",
                                       @"row1": @"label",
                                       @"row2": @"artist",
                                       @"row3": @"year",
                                       @"row4": @"duration",
                                       @"row5": @"rating",
                                       @"row6": @"songid",
                                       @"row7": @"track",
                                       @"row8": @"albumid",
                                       @"playlistid": @0,
                                       @"row9": @"songid",
                                       @"row10": @"file",
                                       @"row11": @"artist"},
                                      
                                      @{@"itemid": @"songs",
                                       @"row1": @"label",
                                       @"row2": @"artist",
                                       @"row3": @"year",
                                       @"row4": @"duration",
                                       @"row5": @"rating",
                                       @"row6": @"songid",
                                       @"row7": @"track",
                                       @"row8": @"albumid",
                                       @"playlistid": @0,
                                       @"row9": @"songid",
                                       @"row10": @"file",
                                       @"row11": @"artist"},
                                      
                                      @[],
                                      
                                      @[],
                                      
                                      @[],
                                      
                                      @[],
                                      
                                      @[],
                                      
                                      @[],
                                      
                                      @[],
                                      
                                      @[],
                                      
                                      @[],
                                      
                                      @[]];
    item1.subItem.subItem.rowHeight = 53;
    item1.subItem.subItem.thumbWidth = 53;
    item1.subItem.subItem.defaultThumb = @"nocover_music";
    item1.subItem.subItem.sheetActions = @[@[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],//@"Stream to iPhone",
                                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                        @[],
                                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                        @[],
                                        @[],
                                        @[],
                                        @[],
                                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
//                                        [NSArray arrayWithObjects:nil],
                                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)]];
    item1.subItem.subItem.showRuntime = @[@YES,
                                       @YES,
                                       @YES,
                                       @YES,
                                       @YES,
                                       @YES,
                                       @YES,
                                       @YES,
                                       @YES,
                                       @YES,
                                       @YES,
                                       @YES,
                                       @YES];
#pragma mark - Movies
    item2.mainLabel = NSLocalizedString(@"Movies", nil);
    item2.upperLabel = NSLocalizedString(@"Watch your", nil);
    item2.icon = @"icon_home_movie_alt";
    item2.family = 1;
    item2.enableSection = YES;
    item2.noConvertTime = YES;
    item2.mainButtons = @[@"st_movie", @"st_movie_genre", @"st_movie_set", @"st_movie_recently", @"st_concert", @"st_filemode", @"st_addons", @"st_livetv"];
    item2.mainMethod = [NSMutableArray arrayWithObjects:
                      @[@"VideoLibrary.GetMovies", @"method",
                       @"VideoLibrary.GetMovieDetails", @"extra_info_method"],
                      
                      @[@"VideoLibrary.GetGenres", @"method"],
                      
                      @[@"VideoLibrary.GetMovieSets", @"method"],
                      
                      @[@"VideoLibrary.GetRecentlyAddedMovies", @"method",
                       @"VideoLibrary.GetMovieDetails", @"extra_info_method"],
                      
                      @[@"VideoLibrary.GetMusicVideos", @"method"],
                      
                      @[@"Files.GetSources", @"method"],
                      
                      @[@"Files.GetDirectory", @"method"],
                      
                      @[@"PVR.GetChannelGroups", @"method"],
                      
                      nil];
    
    item2.mainParameters = [NSMutableArray arrayWithObjects:
                          [NSMutableArray arrayWithObjects:
                           @{@"sort": @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},
                            @"properties": @[@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", @"trailer"]}, @"parameters", NSLocalizedString(@"Movies", nil), @"label", @"Movie", @"wikitype",
                           @{@"properties": @[@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", @"studio", @"director", @"plot", @"mpaa", @"votes", @"cast", @"file", @"fanart", @"resume", @"trailer"]}, @"extra_info_parameters",
                           @"YES", @"FrodoExtraArt",
                           @"YES", @"enableCollectionView",
                           @"1", @"collectionViewUniqueKey",
                           @"YES", @"enableLibraryCache",
                           @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                             @"height": @(itemMovieHeightIphone)},
                            @"ipad": @{@"width": @(itemMovieWidthIpad),
                             @"height": @(itemMovieHeightIpad)}}, @"itemSizes",
//                           @"YES", @"collectionViewRecentlyAdded",
//                           [NSDictionary dictionaryWithObjectsAndKeys:
//                            [NSDictionary dictionaryWithObjectsAndKeys:
//                             @"fullWidth", @"width",
//                             [NSNumber numberWithFloat:itemMovieHeightRecentlyIphone], @"height", nil], @"iphone",
//                            [NSDictionary dictionaryWithObjectsAndKeys:
//                             @"fullWidth", @"width",
//                             [NSNumber numberWithFloat:itemMovieHeightRecentlyIpad], @"height", nil], @"ipad",
//                            nil], @"itemSizes",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           @{@"sort": @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},
                            @"type": @"movie",
                            @"properties": @[@"thumbnail"]}, @"parameters", NSLocalizedString(@"Movie Genres", nil), @"label", @"nocover_movie_genre.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth",
                           @"YES", @"enableLibraryCache",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           @{@"sort": @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},
                            @"properties": @[@"thumbnail", @"playcount"]}, @"parameters",
                           @"2", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",
                           @"YES", @"enableLibraryCache",
                           @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                             @"height": @(itemMovieHeightIphone)},
                            @"ipad": @{@"width": @(itemMovieWidthIpad),
                             @"height": @(itemMovieHeightIpad)}}, @"itemSizes",
                           NSLocalizedString(@"Movie Sets", nil), @"label", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           @{@"sort": @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"none"},
                            @"properties": @[@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", @"trailer", @"fanart"]}, @"parameters", NSLocalizedString(@"Added Movies", nil), @"label", @"Movie", @"wikitype",
                           @{@"properties": @[@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", @"studio", @"director", @"plot", @"mpaa", @"votes", @"cast", @"file", @"fanart", @"resume", @"trailer"]}, @"extra_info_parameters",
                           @"YES", @"FrodoExtraArt",
                           @"3", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",
                           @"YES", @"collectionViewRecentlyAdded",
                           @{@"iphone": @{@"width": @"fullWidth",
                             @"height": @(itemMovieHeightRecentlyIphone)},
                            @"ipad": @{@"width": @"fullWidth",
                             @"height": @(itemMovieHeightRecentlyIpad)}}, @"itemSizes",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           @{@"sort": @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},
                            @"properties": @[@"year", @"playcount", @"thumbnail", @"genre", @"runtime", @"studio", @"director", @"plot", @"file", @"fanart", @"resume"]}, @"parameters", NSLocalizedString(@"Music Videos", nil), @"label", NSLocalizedString(@"Music Videos", nil), @"morelabel", @"Movie", @"wikitype",
                           @"14", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",
                           @"YES", @"enableLibraryCache",
                           @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                             @"height": @(itemMovieHeightIphone)},
                            @"ipad": @{@"width": @(itemMovieWidthIpad),
                             @"height": @(itemMovieHeightIpad)}}, @"itemSizes",
                           nil],

                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"video", @"media",
                            nil], @"parameters", @"Files", @"label", NSLocalizedString(@"Files", nil), @"morelabel", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},@"sort",
                            @"video", @"media",
                            @"addons://sources/video", @"directory",
                            @[@"thumbnail"], @"properties",
                            nil], @"parameters", @"Video Addons", @"label", NSLocalizedString(@"Video Addons", nil), @"morelabel", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth",
                           @"15", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",

                           @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                             @"height": @(itemMovieWidthIphone)},
                            @"ipad": @{@"width": @(itemMovieWidthIpad),
                             @"height": @(itemMovieWidthIpad)}}, @"itemSizes",
                           nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"tv", @"channeltype",
                            nil], @"parameters", @"Live TV", @"label", NSLocalizedString(@"Live TV", nil), @"morelabel", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth",
                           @"16", @"collectionViewUniqueKey",
                           @"YES", @"enableCollectionView",
                           @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                             @"height": @(itemMovieWidthIphone)},
                            @"ipad": @{@"width": @(itemMovieWidthIpad),
                             @"height": @(itemMovieWidthIpad)}}, @"itemSizes",
                           nil],
                          //                          "plot" and "runtime" and "plotoutline"
                          nil];
    
    item2.mainFields = @[@{@"itemid": @"movies",
                       @"row1": @"label",
                       @"row2": @"genre",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"movieid",
                       @"playlistid": @1,
                       @"row8": @"movieid",
                       @"row9": @"movieid",
                       @"row10": @"playcount",
                       @"row11": @"trailer",
                       @"row12": @"plot",
                       @"row13": @"mpaa",
                       @"row14": @"votes",
                       @"row15": @"studio",
                       @"row16": @"cast",
//                       @"fanart",@"row7",
                       @"row17": @"director",
                       @"row18": @"resume",
                       @"itemid_extra_info": @"moviedetails"},
                      
                      @{@"itemid": @"genres",
                       @"row1": @"label",
                       @"row2": @"label",
                       @"row3": @"disable",
                       @"row4": @"disable",
                       @"row5": @"disable",
                       @"row6": @"genre",
                       @"playlistid": @1,
                       @"row8": @"genreid"},
                      
                      @{@"itemid": @"sets",
                       @"row1": @"label",
                       @"row2": @"disable",
                       @"row3": @"disable",
                       @"row4": @"disable",
                       @"row5": @"disable",
                       @"row6": @"setid",
                       @"playlistid": @1,
                       @"row8": @"setid",
                       @"row9": @"setid",
                       @"row10": @"playcount"},

                      @{@"itemid": @"movies",
                       @"row1": @"label",
                       @"row2": @"genre",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"movieid",
                       @"playlistid": @1,
                       @"row8": @"movieid",
                       @"row9": @"movieid",
                       @"row10": @"playcount",
                       @"row11": @"trailer",
                       @"row12": @"plot",
                       @"row13": @"mpaa",
                       @"row14": @"votes",
                       @"row15": @"studio",
                       @"row16": @"cast",
//                       @"fanart",@"row7",
                       @"row17": @"director",
                       @"row18": @"resume",
                       @"itemid_extra_info": @"moviedetails"},
                      
                      @{@"itemid": @"musicvideos",
                       @"row1": @"label",
                       @"row2": @"genre",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"musicvideoid",
                       @"playlistid": @1,
                       @"row8": @"musicvideoid",
                       @"row9": @"musicvideoid",
                       @"row10": @"director",
                       @"row11": @"studio",
                       @"row12": @"plot",
                       @"row13": @"playcount",
                       @"row14": @"resume",
                       @"row15": @"votes",
                       @"row16": @"cast",
                       @"row17": @"file",
                       @"row7": @"fanart"},
                      
                      @{@"itemid": @"sources",
                       @"row1": @"label",
                       @"row2": @"year",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"file",
                       @"playlistid": @1,
                       @"row8": @"file",
                       @"row9": @"file"},
                      
                      @{@"itemid": @"files",
                       @"row1": @"label",
                       @"row2": @"year",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"file",
                       @"playlistid": @1,
                       @"row8": @"file",
                       @"row9": @"file"},
                      
                      @{@"itemid": @"channelgroups",
                       @"row1": @"label",
                       @"row2": @"year",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"channelgroupid",
                       @"playlistid": @1,
                       @"row8": @"channelgroupid",
                       @"row9": @"channelgroupid"}];
    item2.rowHeight = 76;
    item2.thumbWidth = 53;
    item2.defaultThumb = @"nocover_movies";
    item2.sheetActions = @[[NSMutableArray arrayWithObjects:NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Movie Details", nil), nil],
                        @[],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                        [NSMutableArray arrayWithObjects:NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Movie Details", nil), nil],
                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Music Video Details", nil)],
                        @[],
                        @[],
                        @[]];
    //    item2.showInfo = YES;
    item2.showInfo = @[@YES,
                      @YES,
                      @YES,
                      @YES,
                      @YES,
                      @YES,
                      @YES,
                      @YES];
    item2.watchModes = @[@{@"modes": @[@"all", @"unwatched", @"watched"],
                         @"icons": @[@"", @"icon_not_watched", @"icon_watched"]},
                        @{@"modes": @[],
                         @"icons": @[]},
                        @{@"modes": @[@"all", @"unwatched", @"watched"],
                         @"icons": @[@"", @"icon_not_watched", @"icon_watched"]},
                        @{@"modes": @[@"all", @"unwatched", @"watched"],
                         @"icons": @[@"", @"icon_not_watched", @"icon_watched"]},
                        @{@"modes": @[@"all", @"unwatched", @"watched"],
                         @"icons": @[@"", @"icon_not_watched", @"icon_watched"]},
                        @{@"modes": @[],
                         @"icons": @[]},
                        @{@"modes": @[],
                         @"icons": @[]},
                        @{@"modes": @[],
                         @"icons": @[]}];
    
    item2.subItem.mainMethod = [NSMutableArray arrayWithObjects:
                              @[],
                              
                              @[@"VideoLibrary.GetMovies", @"method",
                               @"VideoLibrary.GetMovieDetails", @"extra_info_method"],

                              @[@"VideoLibrary.GetMovies", @"method",
                               @"VideoLibrary.GetMovieDetails", @"extra_info_method"],
                              
                              @[],
                              @[],
                              @[@"Files.GetDirectory", @"method"],
                              @[@"Files.GetDirectory", @"method"],
                              @[@"PVR.GetChannels", @"method"],
                              nil];
    item2.subItem.noConvertTime = YES;

    item2.subItem.mainParameters = [NSMutableArray arrayWithObjects:
                                  
                                  @[],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   @{@"sort": @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"label"},
                                    @"properties": @[@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", @"trailer"]}, @"parameters", @"Movies", @"label", @"Movie", @"wikitype", @"nocover_movies", @"defaultThumb",
                                   @{@"properties": @[@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", @"studio", @"director", @"plot", @"mpaa", @"votes", @"cast", @"file", @"fanart", @"resume", @"trailer"]}, @"extra_info_parameters",
                                   @"YES", @"FrodoExtraArt",
                                   @"4", @"collectionViewUniqueKey",
                                   @"YES", @"enableCollectionView",
                                   @"YES", @"enableLibraryCache",
                                   @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                                     @"height": @(itemMovieHeightIphone)},
                                    @"ipad": @{@"width": @(itemMovieWidthIpad),
                                     @"height": @(itemMovieHeightIpad)}}, @"itemSizes",
                                   nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   @{@"sort": @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"year"},
                                    @"properties": @[@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", @"trailer"]}, @"parameters", @"Movies", @"label", @"Movie", @"wikitype", @"nocover_movies", @"defaultThumb",
                                   @{@"properties": @[@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"runtime", @"studio", @"director", @"plot", @"mpaa", @"votes", @"cast", @"file", @"fanart", @"resume", @"trailer"]}, @"extra_info_parameters",
                                   @"YES", @"FrodoExtraArt",
                                   @"5", @"collectionViewUniqueKey",
                                   @"YES", @"enableCollectionView",

                                   @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                                     @"height": @(itemMovieHeightIphone)},
                                    @"ipad": @{@"width": @(itemMovieWidthLargeIpad),
                                     @"height": @(itemMovieHeightLargeIpad)}}, @"itemSizes",
//                                   @"YES", @"collectionViewRecentlyAdded",
//                                   [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSDictionary dictionaryWithObjectsAndKeys:
//                                     @"fullWidth", @"width",
//                                     [NSNumber numberWithFloat:itemMovieHeightRecentlyIphone], @"height", nil], @"iphone",
//                                    [NSDictionary dictionaryWithObjectsAndKeys:
//                                     @"fullWidth", @"width",
//                                     [NSNumber numberWithFloat:itemMovieHeightRecentlyIpad], @"height", nil], @"ipad",
//                                    nil], @"itemSizes",
                                   nil],
                                  
                                  @[],
                                  
                                  @[],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"label"},@"sort",
                                    filemodeVideoType, @"media",
                                    nil], @"parameters", @"Files", @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"none"},@"sort",
                                    @"video", @"media",
                                    @[@"thumbnail"], @"file_properties",
                                    nil], @"parameters", @"Video Addons", @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth",
                                   @"YES", @"enableCollectionView",
                                   @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                                     @"height": @(itemMovieWidthIphone)},
                                    @"ipad": @{@"width": @(itemMovieWidthIpad),
                                     @"height": @(itemMovieWidthIpad)}}, @"itemSizes",
                                   nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @[@"thumbnail", @"channel"], @"properties",
                                    nil], @"parameters", @"Live TV", @"label", @"icon_video.png", @"defaultThumb", @"YES", @"disableFilterParameter", filemodeRowHeight, @"rowHeight", livetvThumbWidth, @"thumbWidth",
                                   @"YES", @"enableCollectionView",
                                   @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                                     @"height": @(itemMovieWidthIphone)},
                                    @"ipad": @{@"width": @(itemMovieWidthIpad),
                                     @"height": @(itemMovieWidthIpad)}}, @"itemSizes",
                                   nil],
                                  nil];
    item2.subItem.mainFields = @[@{},
                              
                              @{@"itemid": @"movies",
                               @"row1": @"label",
                               @"row2": @"genre",
                               @"row3": @"year",
                               @"row4": @"runtime",
                               @"row5": @"rating",
                               @"row6": @"movieid",
                               @"playlistid": @1,
                               @"row8": @"movieid",
                               @"row9": @"movieid",
                               @"row10": @"playcount",
                               @"row11": @"trailer",
                               @"row12": @"plot",
                               @"row13": @"mpaa",
                               @"row14": @"votes",
                               @"row15": @"studio",
                               @"row16": @"cast",
                               @"row7": @"fanart",
                               @"row17": @"director",
                               @"row18": @"resume",
                               @"itemid_extra_info": @"moviedetails"},
                              
                              @{@"itemid": @"movies",
                               @"row1": @"label",
                               @"row2": @"genre",
                               @"row3": @"year",
                               @"row4": @"runtime",
                               @"row5": @"rating",
                               @"row6": @"movieid",
                               @"playlistid": @1,
                               @"row8": @"movieid",
                               @"row9": @"movieid",
                               @"row10": @"playcount",
                               @"row11": @"trailer",
                               @"row12": @"plot",
                               @"row13": @"mpaa",
                               @"row14": @"votes",
                               @"row15": @"studio",
                               @"row16": @"cast",
//                               @"fanart",@"row7",
                               @"row17": @"director",
                               @"row18": @"resume",
                               @"itemid_extra_info": @"moviedetails"},
                              
                              @{},
                              
                              @{},
                              
                              @{@"itemid": @"files",
                               @"row1": @"label",
                               @"row2": @"filetype",
                               @"row3": @"filetype",
                               @"row4": @"filetype",
                               @"row5": @"filetype",
                               @"row6": @"file",
                               @"playlistid": @1,
                               @"row8": @"file",
                               @"row9": @"file",
                               @"row10": @"filetype",
                               @"row11": @"type"},
                              
                              @{@"itemid": @"files",
                               @"row1": @"label",
                               @"row2": @"filetype",
                               @"row3": @"filetype",
                               @"row4": @"filetype",
                               @"row5": @"filetype",
                               @"row6": @"file",
                               @"row7": @"plugin",
                               @"playlistid": @1,
                               @"row8": @"file",
                               @"row9": @"file",
                               @"row10": @"filetype",
                               @"row11": @"type"},
                              
                              @{@"itemid": @"channels",
                               @"row1": @"channel",
                               @"row2": @"starttime",
                               @"row3": @"endtime",
                               @"row4": @"filetype",
                               @"row5": @"filetype",
                               @"row6": @"channelid",
                               @"playlistid": @1,
                               @"row8": @"channelid",
                               @"row9": @"channelid",
                               @"row10": @"filetype",
                               @"row11": @"type"}];
    
    item2.subItem.enableSection = NO;
    item2.subItem.rowHeight = 76;
    item2.subItem.thumbWidth = 53;
    item2.subItem.defaultThumb = @"nocover_movies";
    item2.subItem.sheetActions = @[@[],
                                  [NSMutableArray arrayWithObjects:NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Movie Details", nil), nil],
                                  [NSMutableArray arrayWithObjects:NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Movie Details", nil), nil],
                                  @[],
                                  @[],
                                  @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                  @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                  @[NSLocalizedString(@"Play", nil)]];
    item2.subItem.showInfo = @[@NO,
                              @YES,
                              @YES,
                              @NO,
                              @NO,
                              @NO,
                              @NO,
                              @NO];
    item2.subItem.watchModes = @[@{@"modes": @[],
                                 @"icons": @[]},
                                @{@"modes": @[@"all", @"unwatched", @"watched"],
                                 @"icons": @[@"", @"icon_not_watched", @"icon_watched"]},
                                @{@"modes": @[@"all", @"unwatched", @"watched"],
                                 @"icons": @[@"", @"icon_not_watched", @"icon_watched"]},
                                @{@"modes": @[],
                                 @"icons": @[]},
                                @{@"modes": @[],
                                 @"icons": @[]},
                                @{@"modes": @[],
                                 @"icons": @[]},
                                @{@"modes": @[],
                                 @"icons": @[]},
                                @{@"modes": @[],
                                 @"icons": @[]}];

    item2.subItem.widthLabel = 252;
    
    item2.subItem.subItem.noConvertTime = YES;
    item2.subItem.subItem.mainMethod = [NSMutableArray arrayWithObjects:
                                        @[],
                                        @[],
                                        @[],
                                        @[],
                                        @[],
                                        @[@"Files.GetDirectory", @"method"],
                                        @[@"Files.GetDirectory", @"method"],
                                        @[],
                                        nil];
    item2.subItem.subItem.mainParameters = [NSMutableArray arrayWithObjects:
                                            @[],
                                            @[],
                                            @[],
                                            @[],
                                            @[],
                                            @[],
                                            [NSMutableArray arrayWithObjects:filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                            @[],
                                            nil];
    item2.subItem.subItem.mainFields = @[@{},
                                        @{},
                                        @{},
                                        @{},
                                        @{},
                                        @{},
                                        @{},
                                        @{}];
    item2.subItem.subItem.enableSection = NO;
    item2.subItem.subItem.rowHeight = 76;
    item2.subItem.subItem.thumbWidth = 53;
    item2.subItem.subItem.defaultThumb = @"nocover_filemode";
    item2.subItem.subItem.sheetActions = @[@[],
                                          @[],
                                          @[],
                                          @[],
                                          @[],
                                          @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                          @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)]];
    item2.subItem.subItem.widthLabel = 252;
    
#pragma mark - TV Shows
    item3.mainLabel = NSLocalizedString(@"TV Shows", nil);
    item3.upperLabel = NSLocalizedString(@"Watch your", nil);
    item3.icon = @"icon_home_tv_alt";
    item3.family = 1;
    item3.enableSection = YES;
    item3.mainButtons = @[@"st_tv", @"st_tv_recently", @"st_filemode", @"st_addons"];//@"st_movie_genre",
    item3.mainMethod = [NSMutableArray arrayWithObjects:
                        @[@"VideoLibrary.GetTVShows", @"method",
                         @"VideoLibrary.GetTVShowDetails", @"extra_info_method",
                         @"YES", @"tvshowsView"],
                        
//                        [NSArray arrayWithObjects:@"VideoLibrary.GetGenres", @"method", nil],
                        
                        @[@"VideoLibrary.GetRecentlyAddedEpisodes", @"method",
                         @"VideoLibrary.GetEpisodeDetails", @"extra_info_method"],
                        
                        @[@"Files.GetSources", @"method"],
                        
                        @[@"Files.GetDirectory", @"method"],
                        
                        nil];
    item3.mainParameters = [NSMutableArray arrayWithObjects:
                            [NSMutableArray arrayWithObjects:
                             @{@"sort": @{@"order": @"ascending",
                               @"ignorearticle": @NO,
                               @"method": @"label"},
                              @"properties": @[@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"studio"]}, @"parameters", NSLocalizedString(@"TV Shows", nil), @"label", @"TV Show", @"wikitype",
                             @{@"properties": @[@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"studio", @"plot", @"mpaa", @"votes", @"cast", @"premiered", @"episode", @"fanart"]}, @"extra_info_parameters",
                             @"YES", @"blackTableSeparator",
                             @"YES", @"FrodoExtraArt",
                             @"YES", @"enableLibraryCache",
                             nil],
                            
//                            [NSMutableArray arrayWithObjects:
//                             [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSDictionary dictionaryWithObjectsAndKeys:
//                               @"ascending",@"order",
//                               [NSNumber numberWithBool:NO],@"ignorearticle",
//                               @"label", @"method",
//                               nil],@"sort",
//                              @"tvshow", @"type",
//                              [NSArray arrayWithObjects:@"thumbnail", nil], @"properties",
//                              nil], @"parameters", @"TV Show Genres", @"label", @"nocover_movie_genre.png", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                            
                            [NSMutableArray arrayWithObjects:
                             @{@"sort": @{@"order": @"ascending",
                               @"ignorearticle": @NO,
                               @"method": @"none"},
                              @"properties": @[@"episode", @"thumbnail", @"firstaired", @"playcount", @"showtitle"]}, @"parameters", NSLocalizedString(@"Added Episodes", nil), @"label", @"53", @"rowHeight", @"95", @"thumbWidth", @"nocover_tvshows_episode", @"defaultThumb",
                             @{@"properties": @[@"episode", @"thumbnail", @"firstaired", @"runtime", @"plot", @"director", @"writer", @"rating", @"showtitle", @"season", @"cast", @"file", @"fanart", @"playcount", @"resume"]}, @"extra_info_parameters",
                             @"YES", @"FrodoExtraArt",
//                             @"17", @"collectionViewUniqueKey",
//                             @"YES", @"enableCollectionView",
//                             @"YES", @"collectionViewRecentlyAdded",
//                             [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSDictionary dictionaryWithObjectsAndKeys:
//                               @"fullWidth", @"width",
//                               [NSNumber numberWithFloat:itemMovieHeightRecentlyIphone], @"height", nil], @"iphone",
//                              [NSDictionary dictionaryWithObjectsAndKeys:
//                               @"fullWidth", @"width",
//                               [NSNumber numberWithFloat:itemMovieHeightRecentlyIpad], @"height", nil], @"ipad",
//                              nil], @"itemSizes",
                             nil],
                            
                            [NSMutableArray arrayWithObjects:
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @{@"order": @"ascending",
                               @"ignorearticle": @NO,
                               @"method": @"label"},@"sort",
                              @"video", @"media",
                              nil], @"parameters", NSLocalizedString(@"Files", nil), @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                            
                            [NSMutableArray arrayWithObjects:
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @{@"order": @"ascending",
                               @"ignorearticle": @NO,
                               @"method": @"label"},@"sort",
                              @"video", @"media",
                              @"addons://sources/video", @"directory",
                              @[@"thumbnail"], @"properties",
                              nil], @"parameters", NSLocalizedString(@"Video Addons", nil), @"label", NSLocalizedString(@"Video Addons", nil), @"morelabel", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth",
                             @"YES", @"enableCollectionView",
                             @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                               @"height": @(itemMovieWidthIphone)},
                              @"ipad": @{@"width": @(itemMovieWidthIpad),
                               @"height": @(itemMovieWidthIpad)}}, @"itemSizes",
                             nil],
                            
                            nil];
    item3.mainFields = @[@{@"itemid": @"tvshows",
                         @"row1": @"label",
                         @"row2": @"genre",
                         @"row3": @"blank",
                         @"row4": @"studio",
                         @"row5": @"rating",
                         @"row6": @"tvshowid",
                         @"playlistid": @1,
                         @"row8": @"tvshowid",
                         @"row9": @"playcount",
                         @"row10": @"mpaa",
                         @"row11": @"votes",
                         @"row12": @"cast",
                         @"row13": @"premiered",
                         @"row14": @"episode",
                         @"row7": @"fanart",
                         @"row15": @"plot",
                         @"row16": @"studio",
                         @"itemid_extra_info": @"tvshowdetails"},
                        
//                        [NSDictionary dictionaryWithObjectsAndKeys:
//                         @"genres",@"itemid",
//                         @"label", @"row1",
//                         @"label", @"row2",
//                         @"disable", @"row3",
//                         @"disable", @"row4",
//                         @"disable",@"row5",
//                         @"genre",@"row6",
//                         [NSNumber numberWithInt:1], @"playlistid",
//                         @"genreid",@"row8",
//                         nil],
                        
                        @{@"itemid": @"episodes",
                         @"row1": @"label",
                         @"row2": @"showtitle",
                         @"row3": @"firstaired",
                         @"row4": @"runtime",
                         @"row5": @"rating",
                         @"row6": @"episodeid",
                         @"row7": @"playcount",
                         @"row8": @"episodeid",
                         @"playlistid": @1,
                         @"row9": @"episodeid",
                         @"row10": @"plot",
                         @"row11": @"director",
                         @"row12": @"writer",
                         @"row13": @"resume",
                         @"row14": @"showtitle",
                         @"row15": @"season",
                         @"row16": @"cast",
                         @"row17": @"firstaired",
                         @"row18": @"season",
                         @"row7": @"fanart",
                         @"itemid_extra_info": @"episodedetails"},
                        
                        @{@"itemid": @"sources",
                         @"row1": @"label",
                         @"row2": @"year",
                         @"row3": @"year",
                         @"row4": @"runtime",
                         @"row5": @"rating",
                         @"row6": @"file",
                         @"playlistid": @1,
                         @"row8": @"file",
                         @"row9": @"file"},
                        
                        @{@"itemid": @"files",
                         @"row1": @"label",
                         @"row2": @"year",
                         @"row3": @"year",
                         @"row4": @"runtime",
                         @"row5": @"rating",
                         @"row6": @"file",
                         @"playlistid": @1,
                         @"row8": @"file",
                         @"row9": @"file"}];
    
    item3.rowHeight = tvshowHeight;
    item3.thumbWidth = thumbWidth;
    item3.defaultThumb = @"nocover_tvshows.png";
    item3.originLabel = 60;
    item3.sheetActions = @[@[NSLocalizedString(@"TV Show Details", nil)],
//                          [NSArray arrayWithObjects: nil],
                          @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Episode Details", nil)],
                          @[],
                          @[]];
    
    item3.showInfo = @[@NO,
//                      [NSNumber numberWithBool:NO],
                      @YES,
                      @NO,
                      @NO];
    
    item3.watchModes = @[@{@"modes": @[@"all", @"unwatched", @"watched"],
                         @"icons": @[@"", @"icon_not_watched", @"icon_watched"]},
//                        [NSDictionary dictionaryWithObjectsAndKeys:
//                         [NSArray arrayWithObjects:nil], @"modes",
//                         [NSArray arrayWithObjects:nil], @"icons",
//                         nil],
                        @{@"modes": @[@"all", @"unwatched", @"watched"],
                         @"icons": @[@"", @"icon_not_watched", @"icon_watched"]},
                        @{@"modes": @[],
                         @"icons": @[]},
                        @{@"modes": @[],
                         @"icons": @[]}];
    
    item3.subItem.mainMethod = [NSMutableArray arrayWithObjects:
                              @[@"VideoLibrary.GetEpisodes", @"method",
                               @"VideoLibrary.GetEpisodeDetails", @"extra_info_method",
                               @"YES", @"episodesView",
                               @"VideoLibrary.GetSeasons", @"extra_section_method"],
//                              [NSArray arrayWithObjects:
//                               @"VideoLibrary.GetTVShows", @"method",
//                               @"VideoLibrary.GetTVShowDetails", @"extra_info_method",
//                               nil],
                              @[],
                              @[@"Files.GetDirectory", @"method"],
                              @[@"Files.GetDirectory", @"method"],
                              nil];
    
    item3.subItem.mainParameters = [NSMutableArray arrayWithObjects:
                                    [NSMutableArray arrayWithObjects:
                                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @{@"order": @"ascending",
                                       @"method": @"episode"},@"sort",
                                      @[@"episode", @"thumbnail", @"firstaired", @"showtitle", @"playcount", @"season", @"tvshowid", @"runtime"], @"properties",
                                      nil], @"parameters", @"Episodes", @"label", @"YES", @"disableFilterParameter",
                                     @{@"properties": @[@"episode", @"thumbnail", @"firstaired", @"runtime", @"plot", @"director", @"writer", @"rating", @"showtitle", @"season", @"cast", @"fanart", @"resume"]}, @"extra_info_parameters",
                                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @{@"order": @"ascending",
                                       @"ignorearticle": @NO,
                                       @"method": @"label"},@"sort",
                                      @[@"season", @"thumbnail", @"tvshowid", @"playcount", @"episode"], @"properties",
                                      nil], @"extra_section_parameters",
                                     @"YES", @"FrodoExtraArt",
                                     nil],
                                    
//                                    [NSMutableArray arrayWithObjects:
//                                     [NSDictionary dictionaryWithObjectsAndKeys:
//                                      [NSDictionary dictionaryWithObjectsAndKeys:
//                                       @"ascending",@"order",
//                                       [NSNumber numberWithBool:NO],@"ignorearticle",
//                                       @"label", @"method",
//                                       nil],@"sort",
//                                      [NSArray arrayWithObjects:@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"studio", nil], @"properties",
//                                      nil], @"parameters",
//                                     @"TV Shows", @"label", @"TV Show", @"wikitype", [NSNumber numberWithInt:tvshowHeight], @"rowHeight", [NSNumber numberWithInt:thumbWidth], @"thumbWidth",
//                                     [NSDictionary dictionaryWithObjectsAndKeys:
//                                      [NSArray arrayWithObjects:@"year", @"playcount", @"rating", @"thumbnail", @"genre", @"studio", @"plot", @"mpaa", @"votes", @"cast", @"premiered", @"episode", @"fanart", nil], @"properties",
//                                      nil], @"extra_info_parameters",
//                                     @"YES", @"blackTableSeparator",
//                                     @"YES", @"FrodoExtraArt",
//                                     nil],
                                    
                                    @[],
                                    
                                    [NSMutableArray arrayWithObjects:
                                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @{@"order": @"ascending",
                                       @"ignorearticle": @NO,
                                       @"method": @"label"},@"sort",
                                      filemodeVideoType, @"media",
                                      nil], @"parameters", @"Files", @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                    
                                    [NSMutableArray arrayWithObjects:
                                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @{@"order": @"ascending",
                                       @"ignorearticle": @NO,
                                       @"method": @"none"},@"sort",
                                      @"video", @"media",
                                      @[@"thumbnail"], @"file_properties",
                                      nil], @"parameters", @"Video Addons", @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth",
                                     @"YES", @"enableCollectionView",
                                     @{@"iphone": @{@"width": @(itemMovieWidthIphone),
                                       @"height": @(itemMovieWidthIphone)},
                                      @"ipad": @{@"width": @(itemMovieWidthIpad),
                                       @"height": @(itemMovieWidthIpad)}}, @"itemSizes",
                                     nil],
                                                                       
                                    nil];
    item3.subItem.mainFields = @[@{@"itemid": @"episodes",
                                 @"row1": @"label",
                                 @"row2": @"showtitle",
                                 @"row3": @"firstaired",
                                 @"row4": @"runtime",
                                 @"row5": @"rating",
                                 @"row6": @"episodeid",
                                 @"row7": @"playcount",
                                 @"row8": @"episodeid",
                                 @"playlistid": @1,
                                 @"row9": @"episodeid",
                                 @"row10": @"season",
                                 @"row11": @"tvshowid",
                                 @"row12": @"writer",
                                 @"row13": @"firstaired",
                                 @"row14": @"showtitle",
                                 @"row15": @"plot",
                                 @"row16": @"cast",
                                 @"row17": @"director",
                                 @"row18": @"resume",
                                 @"row19": @"episode",
                                 @"itemid_extra_info": @"episodedetails",
                                 @"itemid_extra_section": @"seasons"},
                                
//                                [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"tvshows",@"itemid",
//                                 @"label", @"row1",
//                                 @"genre", @"row2",
//                                 @"blank", @"row3",
//                                 @"studio", @"row4",
//                                 @"rating",@"row5",
//                                 @"tvshowid",@"row6",
//                                 [NSNumber numberWithInt:1], @"playlistid",
//                                 @"tvshowid",@"row8",
//                                 @"playcount",@"row9",
//                                 @"mpaa",@"row10",
//                                 @"votes",@"row11",
//                                 @"cast",@"row12",
//                                 @"premiered",@"row13",
//                                 @"episode",@"row14",
//                                 @"fanart",@"row7",
//                                 @"plot",@"row15",
//                                 @"studio",@"row16",
//                                 @"tvshowdetails",@"itemid_extra_info",
//                                 nil],
                                
                                @[],
                                
                                @{@"itemid": @"files",
                                 @"row1": @"label",
                                 @"row2": @"filetype",
                                 @"row3": @"filetype",
                                 @"row4": @"filetype",
                                 @"row5": @"filetype",
                                 @"row6": @"file",
                                 @"playlistid": @1,
                                 @"row8": @"file",
                                 @"row9": @"file",
                                 @"row10": @"filetype",
                                 @"row11": @"type"},
                                
                                @{@"itemid": @"files",
                                 @"row1": @"label",
                                 @"row2": @"filetype",
                                 @"row3": @"filetype",
                                 @"row4": @"filetype",
                                 @"row5": @"filetype",
                                 @"row6": @"file",
                                 @"row7": @"plugin",
                                 @"playlistid": @1,
                                 @"row8": @"file",
                                 @"row9": @"file",
                                 @"row10": @"filetype",
                                 @"row11": @"type"}];
    item3.subItem.enableSection = NO;
    item3.subItem.rowHeight = 53;
    item3.subItem.thumbWidth = 95;
    item3.subItem.defaultThumb = @"nocover_tvshows_episode.png";
    item3.subItem.sheetActions = @[@[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil), NSLocalizedString(@"Episode Details", nil)],
//                                  [NSArray arrayWithObjects:@"TV Show Details", nil],
                                  @[],
                                  @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                  @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)]];//, @"Stream to iPhone"
    item3.subItem.originYearDuration = 248;
    item3.subItem.widthLabel = 208;
    item3.subItem.showRuntime = @[@NO,
//                               [NSNumber numberWithBool:NO],
                               @NO,
                               @NO,
                               @NO];
    item3.subItem.noConvertTime = YES;
    item3.subItem.showInfo = @[@YES,
//                              [NSNumber numberWithBool:NO],
                              @YES,
                              @YES,
                              @YES];
    
    item3.subItem.subItem.mainMethod = [NSMutableArray arrayWithObjects:
                                      @[],
//                                      [NSArray arrayWithObjects:nil],
                                      @[],
                                      @[@"Files.GetDirectory", @"method"],
                                      @[@"Files.GetDirectory", @"method"],
                                      nil];
    item3.subItem.subItem.mainParameters = [NSMutableArray arrayWithObjects:
                                          @[],
                                          
//                                          [NSArray arrayWithObjects:nil],

                                          @[],
                                          
                                          @[],
                                          
                                          [NSMutableArray arrayWithObjects:filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                          
                                          nil];
    item3.subItem.subItem.mainFields = @[@[],
                                      
//                                      [NSArray arrayWithObjects:nil],
                                      
                                      @[],
                                      
                                      @[],
                                      
                                      @[]];
    item3.subItem.subItem.enableSection = NO;
    item3.subItem.subItem.rowHeight = 53;
    item3.subItem.subItem.thumbWidth = 95;
    item3.subItem.subItem.defaultThumb = @"nocover_tvshows_episode.png";
    item3.subItem.subItem.sheetActions = @[@[],
//                                        [NSArray arrayWithObjects:nil],
                                        @[],
                                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)],
                                        @[NSLocalizedString(@"Queue after current", nil), NSLocalizedString(@"Queue", nil), NSLocalizedString(@"Play", nil)]];
    item3.subItem.subItem.originYearDuration = 248;
    item3.subItem.subItem.widthLabel = 208;
    item3.subItem.subItem.showRuntime = @[@NO,
//                                       [NSNumber numberWithBool:NO],
                                       @NO,
                                       @NO,
                                       @NO];
    item3.subItem.subItem.noConvertTime = YES;
    item3.subItem.subItem.showInfo = @[@YES,
//                                      [NSNumber numberWithBool:YES],
                                      @YES,
                                      @YES,
                                      @YES];
    
#pragma mark - Pictures
    item4.mainLabel = NSLocalizedString(@"Pictures", nil);
    item4.upperLabel = NSLocalizedString(@"Browse your", nil);
    item4.icon = @"icon_home_picture_alt";
    item4.family = 1;
    item4.enableSection = YES;
    item4.mainButtons = @[@"st_filemode", @"st_addons"];
    
    item4.mainMethod = [NSMutableArray arrayWithObjects:
                      
                      @[@"Files.GetSources", @"method"],
                      
                      @[@"Files.GetDirectory", @"method"],
                      
                      nil];
    
    item4.mainParameters = [NSMutableArray arrayWithObjects:
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},@"sort",
                            @"pictures", @"media",
                            nil], @"parameters", NSLocalizedString(@"Pictures", nil), @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                          
                          [NSMutableArray arrayWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @{@"order": @"ascending",
                             @"ignorearticle": @NO,
                             @"method": @"label"},@"sort",
                            @"pictures", @"media",
                            @"addons://sources/image", @"directory",
                            @[@"thumbnail"], @"properties",
                            nil], @"parameters", NSLocalizedString(@"Pictures Addons", nil), @"label", NSLocalizedString(@"Pictures Addons", nil), @"morelabel", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                          
                          nil];
    item4.mainFields = @[@{@"itemid": @"sources",
                       @"row1": @"label",
                       @"row2": @"year",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"file",
                       @"playlistid": @2,
                       @"row8": @"file",
                       @"row9": @"file"},
                      
                      @{@"itemid": @"files",
                       @"row1": @"label",
                       @"row2": @"year",
                       @"row3": @"year",
                       @"row4": @"runtime",
                       @"row5": @"rating",
                       @"row6": @"file",
                       @"playlistid": @2,
                       @"row8": @"file",
                       @"row9": @"file"}];
    
    item4.thumbWidth = 53;
    item4.defaultThumb = @"jewel_dvd.table.png";
    
    item4.subItem.mainMethod = [NSMutableArray arrayWithObjects:
                              
                              @[@"Files.GetDirectory", @"method"],
                              
                              @[@"Files.GetDirectory", @"method"],
                              
                              nil];
    
    item4.subItem.mainParameters = [NSMutableArray arrayWithObjects:
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"label"},@"sort",
                                    @"pictures", @"media",
                                    @[@"thumbnail"], @"file_properties",
                                    nil], @"parameters", NSLocalizedString(@"Files", nil), @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                  
                                  [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @{@"order": @"ascending",
                                     @"ignorearticle": @NO,
                                     @"method": @"none"},@"sort",
                                    @"pictures", @"media",
                                    @[@"thumbnail"], @"file_properties",
                                    nil], @"parameters", NSLocalizedString(@"Video Addons", nil), @"label", @"nocover_filemode", @"defaultThumb", filemodeRowHeight, @"rowHeight", filemodeThumbWidth, @"thumbWidth", nil],
                                  
                                  nil];
    item4.subItem.mainFields = @[@{@"itemid": @"files",
                               @"row1": @"label",
                               @"row2": @"filetype",
                               @"row3": @"filetype",
                               @"row4": @"filetype",
                               @"row5": @"filetype",
                               @"row6": @"file",
                               @"playlistid": @2,
                               @"row8": @"file",
                               @"row9": @"file",
                               @"row10": @"filetype",
                               @"row11": @"type"},
                              
                              @{@"itemid": @"files",
                               @"row1": @"label",
                               @"row2": @"filetype",
                               @"row3": @"filetype",
                               @"row4": @"filetype",
                               @"row5": @"filetype",
                               @"row6": @"file",
                               @"playlistid": @2,
                               @"row8": @"file",
                               @"row9": @"file",
                               @"row10": @"filetype",
                               @"row11": @"type"}];
    
    item4.subItem.enableSection = NO;
    item4.subItem.rowHeight = 76;
    item4.subItem.thumbWidth = 53;
    item4.subItem.defaultThumb = @"nocover_tvshows_episode.png";
    
    
    item4.subItem.subItem.mainMethod = [NSMutableArray arrayWithObjects:
                                      
                                      @[@"Files.GetDirectory", @"method"],
                                      
                                      @[@"Files.GetDirectory", @"method"],
                                      
                                      nil];
    
    item4.subItem.subItem.mainParameters = [NSMutableArray arrayWithObjects:
                                          
                                          @[],
                                          
                                          @[],
                                          
                                          nil];
    
    item4.subItem.subItem.mainFields = @[@[],
                                      
                                      @[]];
    
#pragma mark - Now Playing
    item5.mainLabel = NSLocalizedString(@"Now Playing", nil);
    item5.upperLabel = NSLocalizedString(@"See what's", nil);
    item5.icon = @"icon_home_playing_alt";
    item5.family = 2;
    
#pragma mark - Remote Control
    item6.mainLabel = NSLocalizedString(@"Remote Control", nil);
    item6.upperLabel = NSLocalizedString(@"Use as", nil);
    item6.icon = @"icon_home_remote_alt";
    item6.family = 3;
    
#pragma mark - XBMC Server Management
    item7.mainLabel = NSLocalizedString(@"XBMC Server", nil);
    item7.upperLabel = @"";
    item7.icon = @"";
    item7.family = 4;
    
    playlistArtistAlbums = [item1 copy];
    playlistArtistAlbums.subItem.disableNowPlaying = TRUE;
    playlistArtistAlbums.subItem.subItem.disableNowPlaying = TRUE;
    
    playlistMovies = [item2 copy];
    playlistMovies.subItem.disableNowPlaying = TRUE;
    playlistMovies.subItem.subItem.disableNowPlaying = TRUE;
    
    playlistTvShows = [item3 copy];
    playlistTvShows.subItem.disableNowPlaying = TRUE;
    playlistTvShows.subItem.subItem.disableNowPlaying = TRUE;

#pragma mark - Host Right Menu
    rightMenuItems = [NSMutableArray arrayWithCapacity:1];
    mainMenu *rightItem1 = [[mainMenu alloc] init];
    rightItem1.mainLabel = NSLocalizedString(@"XBMC Server", nil);
    rightItem1.family = 1;
    rightItem1.enableSection = YES;
    rightItem1.mainMethod = @[@{@"offline": @[@{@"label": @"ServerInfo",
                                @"bgColor": @{@"red": @.208f,
                                 @"green": @.208f,
                                 @"blue": @.208f},
                                @"fontColor": @{@"red": @.702f,
                                 @"green": @.702f,
                                 @"blue": @.702f},

                                @"hideLineSeparator": @YES},
                               @{@"label": NSLocalizedString(@"Wake On Lan", nil),
                                @"bgColor": @{@"red": @.741f,
                                 @"green": @.141f,
                                 @"blue": @.141f},
                                @"fontColor": @{@"red": @1.0f,
                                 @"green": @1.0f,
                                 @"blue": @1.0f},
                                @"icon": @"icon_power",
                                @"action": @{@"command": @"System.WOL"}},
                               @{@"label": NSLocalizedString(@"LED Torch", nil),
                                @"icon": @"torch"}],
                              
                              @"utility": @[@{@"label": NSLocalizedString(@"LED Torch", nil),
                                @"icon": @"torch"}],
                              
                              @"online": @[@{@"label": @"ServerInfo",
                                @"bgColor": @{@"red": @.208f,
                                 @"green": @.208f,
                                 @"blue": @.208f},
                                @"fontColor": @{@"red": @.702f,
                                 @"green": @.702f,
                                 @"blue": @.702f},
                                @"hideLineSeparator": @YES},
                               
                               @{@"label": NSLocalizedString(@"Power off System", nil),
                                @"bgColor": @{@"red": @.741f,
                                 @"green": @.141f,
                                 @"blue": @.141f},
                                @"fontColor": @{@"red": @1.0f,
                                 @"green": @1.0f,
                                 @"blue": @1.0f},
                                @"hideLineSeparator": @YES,
                                @"icon": @"icon_power",
                                @"action": @{@"command": @"System.Shutdown",
                                 @"message": NSLocalizedString(@"Are you sure you want to power off your XBMC system now?", nil),
//                                 @"If you do nothing, the XBMC system will shutdown automatically in", @"countdown_message",
                                 @"countdown_time": @5,
                                 @"cancel_button": NSLocalizedString(@"Cancel", nil),
                                 @"ok_button": NSLocalizedString(@"Power off", nil)}},
                               
                               @{@"label": NSLocalizedString(@"Hibernate", nil),
                                @"icon": @"icon_hibernate",
                                @"action": @{@"command": @"System.Hibernate",
                                 @"message": NSLocalizedString(@"Are you sure you want to hibernate your XBMC system now?", nil),
                                 @"cancel_button": NSLocalizedString(@"Cancel", nil),
                                 @"ok_button": NSLocalizedString(@"Hibernate", nil)}},
                               
                               @{@"label": NSLocalizedString(@"Suspend", nil),
                                @"icon": @"icon_sleep",
                                @"action": @{@"command": @"System.Suspend",
                                 @"message": NSLocalizedString(@"Are you sure you want to suspend your XBMC system now?", nil),
                                 @"cancel_button": NSLocalizedString(@"Cancel", nil),
                                 @"ok_button": NSLocalizedString(@"Suspend", nil)}},
                               
                               @{@"label": NSLocalizedString(@"Reboot", nil),
                                @"icon": @"icon_reboot",
                                @"action": @{@"command": @"System.Reboot",
                                 @"message": NSLocalizedString(@"Are you sure you want to reboot your XBMC system now?", nil),
                                 @"cancel_button": NSLocalizedString(@"Cancel", nil),
                                 @"ok_button": NSLocalizedString(@"Reboot", nil)}},
                               
                               @{@"label": NSLocalizedString(@"Quit XBMC application", nil),
                                @"icon": @"icon_exit",
                                @"action": @{@"command": @"Application.Quit",
                                 @"message": NSLocalizedString(@"Are you sure you want to quit XBMC application now?", nil),
                                 @"cancel_button": NSLocalizedString(@"Cancel", nil),
                                 @"ok_button": NSLocalizedString(@"Quit", nil)}},
                               
                               @{@"label": NSLocalizedString(@"Update Audio Library", nil),
                                @"icon": @"icon_update_audio",
                                @"action": @{@"command": @"AudioLibrary.Scan",
                                 @"message": NSLocalizedString(@"Are you sure you want to update your audio library now?", nil),
                                 @"cancel_button": NSLocalizedString(@"Cancel", nil),
                                 @"ok_button": NSLocalizedString(@"Update Audio", nil)}},
                               
                               @{@"label": NSLocalizedString(@"Clean Audio Library", nil),
                                @"icon": @"icon_clean_audio",
                                @"action": @{@"command": @"AudioLibrary.Clean",
                                 @"message": NSLocalizedString(@"Are you sure you want to clean your audio library now?", nil),
                                 @"cancel_button": NSLocalizedString(@"Cancel", nil),
                                 @"ok_button": NSLocalizedString(@"Clean Audio", nil)}},
                               
                               @{@"label": NSLocalizedString(@"Update Video Library", nil),
                                @"icon": @"icon_update_video",
                                @"action": @{@"command": @"VideoLibrary.Scan",
                                 @"message": NSLocalizedString(@"Are you sure you want to update your video library now?", nil),
                                 @"cancel_button": NSLocalizedString(@"Cancel", nil),
                                 @"ok_button": NSLocalizedString(@"Update Video", nil)}},
                               
                               @{@"label": NSLocalizedString(@"Clean Video Library", nil),
                                @"icon": @"icon_clean_video",
                                @"action": @{@"command": @"VideoLibrary.Clean",
                                 @"message": NSLocalizedString(@"Are you sure you want to clean your video library now?", nil),
                                 @"cancel_button": NSLocalizedString(@"Cancel", nil),
                                 @"ok_button": NSLocalizedString(@"Clean Video", nil)}},
                               @{@"label": NSLocalizedString(@"LED Torch", nil),
                                @"icon": @"torch"}]}];
    [rightMenuItems addObject:rightItem1];
    
#pragma mark - Now Playing Right Menu
    nowPlayingMenuItems = [NSMutableArray arrayWithCapacity:1];
    mainMenu *nowPlayingItem1 = [[mainMenu alloc] init];
    nowPlayingItem1.mainLabel = @"VolumeControl";
    nowPlayingItem1.family = 2;
    nowPlayingItem1.mainMethod = @[@{@"offline": @[@{@"label": @"ServerInfo",
                                     @"bgColor": @{@"red": @.208f,
                                      @"green": @.208f,
                                      @"blue": @.208f},
                                     @"fontColor": @{@"red": @.702f,
                                      @"green": @.702f,
                                      @"blue": @.702f},
                                     @"hideLineSeparator": @YES}],
                                   
                                   @"online": @[@{@"label": @"ServerInfo",
                                     @"bgColor": @{@"red": @.208f,
                                      @"green": @.208f,
                                      @"blue": @.208f},
                                     @"fontColor": @{@"red": @.702f,
                                      @"green": @.702f,
                                      @"blue": @.702f},
                                     @"hideLineSeparator": @YES},
                                    @{@"label": @"VolumeControl",
                                     @"icon": @"volume"},
                                    @{@"label": NSLocalizedString(@"Keyboard", nil),
                                     @"icon": @"keyboard_icon"},
                                    @{@"label": @"RemoteControl"}]}];
    [nowPlayingMenuItems addObject:nowPlayingItem1];
    
#pragma mark - Remote Control Right Menu
    remoteControlMenuItems = [NSMutableArray arrayWithCapacity:1];
    mainMenu *remoteControlItem1 = [[mainMenu alloc] init];
    remoteControlItem1.mainLabel = @"RemoteControl";
    remoteControlItem1.family = 3;
    remoteControlItem1.mainMethod = @[@{@"offline": @[@{@"label": @"ServerInfo",
                                     @"bgColor": @{@"red": @.208f,
                                      @"green": @.208f,
                                      @"blue": @.208f},
                                     @"fontColor": @{@"red": @.702f,
                                      @"green": @.702f,
                                      @"blue": @.702f},
                                     @"hideLineSeparator": @YES},
                                    @{@"label": NSLocalizedString(@"LED Torch", nil),
                                     @"icon": @"torch"}],
                                   
                                   @"online": @[@{@"label": @"ServerInfo",
                                     @"bgColor": @{@"red": @.208f,
                                      @"green": @.208f,
                                      @"blue": @.208f},
                                     @"fontColor": @{@"red": @.702f,
                                      @"green": @.702f,
                                      @"blue": @.702f},
                                     @"hideLineSeparator": @YES},
                                    @{@"label": @"VolumeControl",
                                     @"icon": @"volume"},
                                    @{@"label": NSLocalizedString(@"Keyboard", nil),
                                     @"icon": @"keyboard_icon",
                                     @"revealViewTop": @YES},
                                    @{@"label": NSLocalizedString(@"Gesture Zone", nil),
                                     @"icon": @"finger"},
                                    @{@"label": NSLocalizedString(@"Button Pad", nil),
                                     @"icon": @"circle"},
                                    @{@"label": NSLocalizedString(@"Help Screen", nil),
                                     @"icon": @"button_info"},
                                    @{@"label": NSLocalizedString(@"LED Torch", nil),
                                     @"icon": @"torch"}]}];
    [remoteControlMenuItems addObject:remoteControlItem1];
    
//    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProximityChangeNotification:) name:UIDeviceProximityStateDidChangeNotification object:nil];

#pragma mark -

    self.serverName = NSLocalizedString(@"No connection", nil);
    InitialSlidingViewController *initialSlidingViewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [mainMenuItems addObject:item7];
        [mainMenuItems addObject:item1];
        [mainMenuItems addObject:item2];
        [mainMenuItems addObject:item3];
        [mainMenuItems addObject:item4];
        [mainMenuItems addObject:item5];
        [mainMenuItems addObject:item6];
        initialSlidingViewController = [[InitialSlidingViewController alloc] initWithNibName:@"InitialSlidingViewController" bundle:nil];
        initialSlidingViewController.mainMenu = mainMenuItems;
        self.window.rootViewController = initialSlidingViewController;
    }
    else {
        [mainMenuItems addObject:item7];
        [mainMenuItems addObject:item1];
        [mainMenuItems addObject:item2];
        [mainMenuItems addObject:item3];
        [mainMenuItems addObject:item4];
        [mainMenuItems addObject:item6];
        self.windowController = [[ViewControllerIPad alloc] initWithNibName:@"ViewControllerIPad" bundle:nil];
        self.windowController.mainMenu = mainMenuItems;
        self.window.rootViewController = self.windowController;
    }
    return YES;
}

-(void)handleProximityChangeNotification:(id)sender {
    if ([[UIDevice currentDevice] proximityState]) {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"UIApplicationDidEnterBackgroundNotification" object: nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"UIApplicationWillEnterForegroundNotification" object: nil];
    }
}

-(void)wake:(NSString *)macAddress {
    Wake_on_LAN("255.255.255.255", [macAddress UTF8String]);
}

int Wake_on_LAN(char *ip_broadcast,const char *wake_mac) {
	int i,sockfd,an = 1;
	char *x;
	char mac[102];
	char macpart[2];
	char test[103];
	
	struct sockaddr_in serverAddress;
	
	if ( (sockfd = socket( AF_INET, SOCK_DGRAM,17)) < 0 ) {
		return 1;
	}
	
	setsockopt(sockfd,SOL_SOCKET,SO_BROADCAST,&an,sizeof(an));
	
	bzero( &serverAddress, sizeof(serverAddress) );
	serverAddress.sin_family = AF_INET;
	serverAddress.sin_port = htons( 9 );
	
	inet_pton( AF_INET, ip_broadcast, &serverAddress.sin_addr );
	
	for (i = 0;i < 6;i++) mac[i]=255;
	for (i = 1;i < 17;i++) {
		macpart[0]=wake_mac[0];
		macpart[1]=wake_mac[1];
		mac[6*i]=strtol(macpart,&x,16);
		macpart[0]=wake_mac[3];
		macpart[1]=wake_mac[4];
		mac[6*i+1]=strtol(macpart,&x,16);
		macpart[0]=wake_mac[6];
		macpart[1]=wake_mac[7];
		mac[6*i+2]=strtol(macpart,&x,16);
		macpart[0]=wake_mac[9];
		macpart[1]=wake_mac[10];
		mac[6*i+3]=strtol(macpart,&x,16);
		macpart[0]=wake_mac[12];
		macpart[1]=wake_mac[13];
		mac[6*i+4]=strtol(macpart,&x,16);
		macpart[0]=wake_mac[15];
		macpart[1]=wake_mac[16];
		mac[6*i+5]=strtol(macpart,&x,16);
	}
	for (i = 0;i < 103;i++) test[i]=mac[i];
	test[102]=0;
	
	sendto(sockfd,&mac,102,0,(struct sockaddr *)&serverAddress,sizeof(serverAddress));
	close(sockfd);
	
	return 0;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    UIApplication *xbmcRemote = [UIApplication sharedApplication];
    if ([[userDefaults objectForKey:@"lockscreen_preference"] boolValue] == YES ) {
        xbmcRemote.idleTimerDisabled = YES;
        
    }
    else {
        xbmcRemote.idleTimerDisabled = NO;
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName: @"UIApplicationWillEnterForegroundNotification" object: nil];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"UIApplicationShakeNotification" object: nil]; 
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)saveServerList {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) { 
        [NSKeyedArchiver archiveRootObject:arrayServerList toFile:self.dataFilePath];
    }
}

-(void)clearAppDiskCache {
    // OLD SDWEBImageCache
    NSString *fullNamespace = @"ImageCache"; 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    [[NSFileManager defaultManager] removeItemAtPath:paths[0] error:nil];
    
    // TO BE CHANGED!!!
    fullNamespace = @"com.hackemist.SDWebImageCache.default";
    diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
    
    [[NSFileManager defaultManager] removeItemAtPath:self.libraryCachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:self.libraryCachePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}

@end
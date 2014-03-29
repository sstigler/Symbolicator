// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooArtifact.h instead.

#import <CoreData/CoreData.h>
#import "MMRecord.h"

extern const struct SYMBambooArtifactAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *url;
} SYMBambooArtifactAttributes;

extern const struct SYMBambooArtifactRelationships {
	__unsafe_unretained NSString *build;
} SYMBambooArtifactRelationships;

extern const struct SYMBambooArtifactFetchedProperties {
} SYMBambooArtifactFetchedProperties;

@class SYMBambooBuild;




@interface SYMBambooArtifactID : NSManagedObjectID {}
@end

@interface _SYMBambooArtifact : MMRecord {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SYMBambooArtifactID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SYMBambooBuild *build;

//- (BOOL)validateBuild:(id*)value_ error:(NSError**)error_;





@end

@interface _SYMBambooArtifact (CoreDataGeneratedAccessors)

@end

@interface _SYMBambooArtifact (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (SYMBambooBuild*)primitiveBuild;
- (void)setPrimitiveBuild:(SYMBambooBuild*)value;


@end

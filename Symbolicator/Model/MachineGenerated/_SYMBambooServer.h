// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooServer.h instead.

#import <CoreData/CoreData.h>
#import "MMRecord.h"

extern const struct SYMBambooServerAttributes {
	__unsafe_unretained NSString *url;
	__unsafe_unretained NSString *urlProtectionSpace;
	__unsafe_unretained NSString *version;
} SYMBambooServerAttributes;

extern const struct SYMBambooServerRelationships {
	__unsafe_unretained NSString *projects;
} SYMBambooServerRelationships;

extern const struct SYMBambooServerFetchedProperties {
} SYMBambooServerFetchedProperties;

@class SYMBambooProject;


@class NSObject;


@interface SYMBambooServerID : NSManagedObjectID {}
@end

@interface _SYMBambooServer : MMRecord {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SYMBambooServerID*)objectID;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id urlProtectionSpace;



//- (BOOL)validateUrlProtectionSpace:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* version;



@property int32_t versionValue;
- (int32_t)versionValue;
- (void)setVersionValue:(int32_t)value_;

//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *projects;

- (NSMutableSet*)projectsSet;





@end

@interface _SYMBambooServer (CoreDataGeneratedAccessors)

- (void)addProjects:(NSSet*)value_;
- (void)removeProjects:(NSSet*)value_;
- (void)addProjectsObject:(SYMBambooProject*)value_;
- (void)removeProjectsObject:(SYMBambooProject*)value_;

@end

@interface _SYMBambooServer (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;




- (id)primitiveUrlProtectionSpace;
- (void)setPrimitiveUrlProtectionSpace:(id)value;




- (NSNumber*)primitiveVersion;
- (void)setPrimitiveVersion:(NSNumber*)value;

- (int32_t)primitiveVersionValue;
- (void)setPrimitiveVersionValue:(int32_t)value_;





- (NSMutableSet*)primitiveProjects;
- (void)setPrimitiveProjects:(NSMutableSet*)value;


@end

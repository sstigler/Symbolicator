// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooServer.h instead.

#import <CoreData/CoreData.h>


extern const struct SYMBambooServerAttributes {
	__unsafe_unretained NSString *authenticationString;
	__unsafe_unretained NSString *url;
	__unsafe_unretained NSString *version;
} SYMBambooServerAttributes;

extern const struct SYMBambooServerRelationships {
	__unsafe_unretained NSString *projects;
} SYMBambooServerRelationships;

extern const struct SYMBambooServerFetchedProperties {
} SYMBambooServerFetchedProperties;

@class SYMBambooProject;





@interface SYMBambooServerID : NSManagedObjectID {}
@end

@interface _SYMBambooServer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SYMBambooServerID*)objectID;





@property (nonatomic, strong) NSString* authenticationString;



//- (BOOL)validateAuthenticationString:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* version;



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


- (NSString*)primitiveAuthenticationString;
- (void)setPrimitiveAuthenticationString:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;




- (NSString*)primitiveVersion;
- (void)setPrimitiveVersion:(NSString*)value;





- (NSMutableSet*)primitiveProjects;
- (void)setPrimitiveProjects:(NSMutableSet*)value;


@end

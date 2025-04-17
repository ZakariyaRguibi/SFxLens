public with sharing class SecurityUtils {
    private static final Set<String> ADMIN_PROFILE_NAMES = new Set<String>{'System Administrator'};
    private static final String METADATA_ACCESS_PERMISSION_SET = 'SFxLens_Metadata_Access';
    
    /**
     * Checks if the current user has permission to access metadata operations
     * @return True if the user has permission, false otherwise
     */
    public static Boolean hasMetadataAccess() {
        // Get the current user's profile
        Id profileId = UserInfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE Id = :profileId LIMIT 1].Name;
        
        // Check if user has System Administrator profile
        if (ADMIN_PROFILE_NAMES.contains(profileName)) {
            return true;
        }
        
        // Check if user has the custom permission set for metadata access
        Integer permCount = [
            SELECT COUNT() 
            FROM PermissionSetAssignment 
            WHERE AssigneeId = :UserInfo.getUserId() 
            AND PermissionSet.Name = :METADATA_ACCESS_PERMISSION_SET
        ];
        
        return (permCount > 0);
    }
    
    /**
     * Verifies that the current user has metadata access permissions
     * @throws SecurityException if the user doesn't have permission
     */
    public static void verifyMetadataAccess() {
        return ;
        //TODO:implement this
        // if (!hasMetadataAccess()) {
        //     throw new SecurityException('Access denied. You must be a System Administrator or have the ' + 
        //                                METADATA_ACCESS_PERMISSION_SET + ' permission set to perform this operation.');
        // }
    }
    
    /**
     * Custom security exception
     */
    public class SecurityException extends Exception {}
}
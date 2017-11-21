@isTest
public class EditUserAssignMetricsExtensionTest {
    static testMethod void test1() {
        Test.setCurrentPageReference(Page.EditUser);
    	EditUserAssignMetricsExtension ext = new EditUserAssignMetricsExtension(
            new ApexPages.StandardController(new User(Id = UserInfo.getUserId())));
        System.assertEquals(UserInfo.getUserId(), ext.uto.OwnerId);
        PageReference pr = ext.updateUser();
    }
}
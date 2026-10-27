# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
## SparkNest Salesforce Capstone

### Project Components

**Custom Data Model**
- Enquiry (`Enquiry__c`)
- Enquiry Product (`Enquiry_Product__c`)
- Customer budget validation and enquiry status management

**Automation**
- Convert Enquiry to Case Screen Flow
- Complete Tasks when an Enquiry is closed
- Update the Enquiry Product count
- Weekly Enquiry Summary Flow

**Apex Development**
- Enquiry trigger and dispatcher
- Enquiry service and trigger handler
- Follow-up Task creation
- Closed Date stamping
- Stale Enquiry batch processing and scheduler
- SparkNest Enquiry REST API

**Testing**
- `EnquiryServiceTest`
- `CloseStaleEnquiriesBatchTest`
- Latest recorded run: 6 tests passed, 0 failures

**Lightning Apps**
- SparkNest Sales
- SparkNest Support

### Git History

The project uses Git to track Salesforce metadata and project documentation. Meaningful commits document project setup, test results, and project documentation.

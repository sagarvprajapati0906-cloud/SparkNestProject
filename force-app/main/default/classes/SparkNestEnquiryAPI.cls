@RestResource(urlMapping='/sparknest/enquiries/*')
global with sharing class SparkNestEnquiryAPI {

    global class EnquiryRequest {
        public String firstName;
        public String lastName;
        public String email;
        public String phone;
        public String city;
        public String subject;
        public String enquiryType;
        public String source;
        public String planDuration;
        public Decimal customerBudget;
    }

    global class EnquiryResponse {
        public Boolean success;
        public String message;
        public Id contactId;
        public Id enquiryId;
    }

    @HttpPost
    global static EnquiryResponse submitEnquiry() {
        RestResponse response = RestContext.response;
        EnquiryResponse result = new EnquiryResponse();

        try {
            EnquiryRequest requestData = (EnquiryRequest) JSON.deserialize(
                RestContext.request.requestBody.toString(),
                EnquiryRequest.class
            );

            if (requestData == null ||
                String.isBlank(requestData.email)) {
                response.statusCode = 400;
                result.success = false;
                result.message = 'Email is required.';
                return result;
            }

            if (requestData.customerBudget != null &&
                requestData.customerBudget < 1000) {
                response.statusCode = 400;
                result.success = false;
                result.message =
                    'Customer budget must be at least ₹1,000.';
                return result;
            }

            if (String.isBlank(requestData.lastName)) {
                response.statusCode = 400;
                result.success = false;
                result.message = 'Last name is required.';
                return result;
            }

            if (String.isBlank(requestData.subject) ||
                String.isBlank(requestData.enquiryType) ||
                String.isBlank(requestData.source)) {
                response.statusCode = 400;
                result.success = false;
                result.message =
                    'Subject, enquiry type and source are required.';
                return result;
            }

            List<Contact> matches = [
                SELECT Id
                FROM Contact
                WHERE Email = :requestData.email
                LIMIT 1
            ];

            Contact customer;

            if (!matches.isEmpty()) {
                customer = matches[0];
            } else {
                customer = new Contact(
                    FirstName = requestData.firstName,
                    LastName = requestData.lastName,
                    Email = requestData.email,
                    Phone = requestData.phone,
                    MailingCity = requestData.city
                );
                insert customer;
            }

            Enquiry__c enquiry = new Enquiry__c(
                Subject__c = requestData.subject,
                Contact__c = customer.Id,
                Enquiry_Type__c = requestData.enquiryType,
                Source__c = requestData.source,
                Status__c = 'New',
                Customer_Budget__c = requestData.customerBudget
            );

            if (requestData.enquiryType == 'Care Plan Enquiry') {
                enquiry.Plan_Duration__c = requestData.planDuration;
            }

            insert enquiry;

            result.success = true;
            result.message = 'Contact and Enquiry processed successfully.';
            result.contactId = customer.Id;
            result.enquiryId = enquiry.Id;
            response.statusCode = 201;
            return result;

        } catch (Exception ex) {
            response.statusCode = 400;
            result.success = false;
            result.message = 'Unable to submit enquiry: ' + ex.getMessage();
            return result;
        }
    }
}
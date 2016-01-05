angular.module('SCC').factory('Config', [function() {

    var base_url = "http://localhost:3000/";

    return {
        base_url: base_url,
        endpoints: {
            getAllNeighborhoods: {
                url: base_url + "get_all_neighborhoods"
            },
            //Create customer
            getNeighborhoods: {
                url: base_url + "get_neighborhoods"
            },
            getPersonality: {
                url: base_url + "get_personality"
            },
            getServices: {
                url: base_url + "get_services"
            },
            getIDs: {
                url: base_url + "get_identifications"
            },
            //Customer List
            getCNCustomers: {
                url: base_url + "get_customer_cn"
            },
            createClient: {
                url: base_url + "create_customer",
                method: "POST"
            },
            //Payment List
            getPaymentList: {
                url: base_url + "get_payment_list_cn"
            },
            getPaymentStatus: {
                url: base_url + "get_payment_status"
            },
            getBillDetails: {
                url: base_url + "get_bill_details"
            },
            updateOrderStatus: {
                url: base_url + "update_order_status",
                method: "PUT"
            },
            updateOrderVisitDate: {
                url: base_url + "update_order_visit_date",
                method: "PUT"
            },
            makePayment: {
                url: base_url + "process_payment",
                method: "POST"
            },
            //Login
            authenticate: {
                url: base_url + "authentication",
                method: "POST"
            },
        }
    };
}]);
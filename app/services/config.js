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
                url: base_url + "get_customers_cn"
            },
            getCNCustomer: {
                url: base_url + "get_customer_cn"
            },
            getCJCustomers: {
                url: base_url + "get_customers_cj"
            },
            getCJCustomer: {
                url: base_url + "get_customer_cj"
            },
            getPaymentsOrdersInDetails: {
                url: base_url + "get_payment_order_details"
            },
            createClientCN: {
                url: base_url + "create_customer_cn",
                method: "POST"
            },
            createClientCJ: {
                url: base_url + "create_customer_cj",
                method: "POST"
            },
            updateCustomerCN: {
                url: base_url + "update_customer_cn",
                method: "PUT"
            },
            updateCustomerCJ: {
                url: base_url + "update_customer_cj",
                method: "PUT"
            },
            createPaymentOrder: {
                url: base_url + "create_payment_order",
                method: "POST"
            },

            //Payment List
            getPaymentListCN: {
                url: base_url + "get_payment_list_cn"
            },
            getPaymentListCJ: {
                url: base_url + "get_payment_list_cj"
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
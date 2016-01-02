angular.module('SCC').factory('Config', [function() {

    var base_url = "http://localhost:3000/";

    return {
        base_url: base_url,
        endpoints: {
            getPaymentStatus: {
                url: base_url + "get_payment_status"
            },
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
            getCNCustomers:{
                url: base_url+ "get_customer_cn"
            },
            createClient: {
                url: base_url + "create_customer",
                method: "POST"
            },
            authenticate: {
                url: base_url + "authentication",
                method: "POST"
            },
        }
    };
}]);
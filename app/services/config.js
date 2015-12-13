angular.module('SCC').factory('Config', [function() {

    var base_url = "http://localhost:3000/";
    
    return {
        base_url: base_url,
        endpoints: {
            getTechnologyGroups: {
                url: base_url + "cm_get_hierarchy_TG.xsjs",
                method: "GET"
            }
        }
    };
}]);
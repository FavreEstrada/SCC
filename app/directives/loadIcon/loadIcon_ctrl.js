angular.module('SCC').directive('cscLoadIcon', [function() {
    "use strict";
    
    return {
        restrict: 'E',
        scope: {
            isLoading: "="
        },
        templateUrl: 'app/directives/loadIcon/loadIcon.html'
    };
}]);
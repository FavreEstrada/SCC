angular.module('SCC').factory('Util', ["$filter",function($filter) {

    return {
        getMonthName: function(monthNumber) {
            var month = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
            return month[monthNumber - 1];
        },
        toTitleCase: function(str) {
            return str.replace(/\w\S*/g, function(txt) {
                return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
            });
        },
        formatDate: function(date){
            return $filter('date')(date, 'dd-MM-yy');
        }
    };
}]);
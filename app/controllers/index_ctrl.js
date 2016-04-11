angular.module('SCC').controller('index_ctrl', ["$scope", "$location", "$window", 'toaster', '$timeout', '$rootScope' ,function($scope, $location, $window, toaster, $timeout, $rootScope) {
	$scope.logged = false;

	if (!$scope.logged) {
		$location.path("/");
	}
	$scope.setLogged = function(value) {
		$scope.logged = value;
	};
	if ($window.google) {
		google.charts.load('current', {
			'packages': ['bar', 'corechart']
		});
	} else {
		$timeout(function() {
			toaster.pop('warning', "Sin Acceso a Internet", "No podrá tener acceso a los dashboards, sin una conexión a Internet");
		}, 0);
		$rootScope.noInternet = true;
	}
	
}]);
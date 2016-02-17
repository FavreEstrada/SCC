angular.module('SCC').controller('index_ctrl', ["$scope", "$location", function($scope, $location) {
	$scope.logged = false;

	if (!$scope.logged) {
		$location.path("/");
	}
	$scope.setLogged = function(value) {
		$scope.logged = value;
	};
	google.charts.load('current', {
		'packages': ['bar', 'corechart']
	});
}]);
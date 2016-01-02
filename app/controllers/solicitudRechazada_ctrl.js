angular.module('SCC').controller('solicitudRechazada_ctrl', ["$scope", "$http", "Config", function($scope, $http, Config) {

	initialize();

	function initialize() {
		loadNeighborhoods();
	}

	function loadNeighborhoods() {
		$http.get(Config.endpoints.getAllNeighborhoods.url).then(function(data) {
			$scope.neighborhoods = data.data;
			$scope.neighbor = data.data[0];
			$scope.getCover();
			
		}, function(error) {
			console.log("Error getting all neighborhoods " + JSON.stringify(error));
		});
	}
	$scope.getCover = function() {
		$scope.isCovered = $scope.neighbor.covered === 0 ? "Si" : "No";
	};

	$scope.saveRequest = function (){
		
	};
}]);
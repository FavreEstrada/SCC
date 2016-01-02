angular.module('SCC').controller('login_ctrl', ["$scope", 'md5', "$http", "Config", "$location", function($scope, md5, $http, Config, $location) {
	$scope.validateUser = true;
	$scope.validatePass = true;
	$scope.login = function() {
		if (!$scope.user) {
			$scope.validateUser = false;
		} else {
			$scope.validateUser = true;
		}

		if (!$scope.pass) {
			$scope.validatePass = false;
		} else {
			$scope.validatePass = true;
		}

		if ($scope.pass && $scope.user) {
			$scope.pass = md5.createHash($scope.pass);
			authenticate();
		}
	};

	function authenticate() {
		$http({
			url: Config.endpoints.authenticate.url,
			method: Config.endpoints.authenticate.method,
			params: {
				user: $scope.user,
				password: $scope.pass
			}
		}).then(function(data) {
			if (data.data.error === 1) {
				alert("Credenciales incorrectas");
				$scope.pass = "";
			} else {
				Config.user = data.data[0];
				$scope.setLogged(true);
				$location.path("/clientes");
			}
		}, function(error) {
			console.log("Error authenticating user: " + JSON.stringify(error));
		});
	}
}]);
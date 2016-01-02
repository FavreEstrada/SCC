angular.module('SCC').controller('crearCliente_ctrl', ["$scope", "$http", "Config", '$window',  "toaster", function($scope, $http, Config, $window, toaster) {
	function createCustomerObj() {
		$scope.customer = {
			first_name: "",
			middle_name: "",
			first_last: "",
			second_last: "",
			extens: 0,
			tel: "",
			email: "",
			dir: "",
			obs: "",
			noID: ""
		};
	}

	initialize();

	$scope.addClient = function() {
		var url = Config.endpoints.createClient.url;
		var method = Config.endpoints.createClient.method;
		var params_ = {
			first_name: $scope.customer.first_name,
			middle_name: $scope.customer.middle_name,
			first_last: $scope.customer.first_last,
			second_last: $scope.customer.second_last,
			extens: $scope.customer.extens,
			tel: $scope.customer.tel,
			email: $scope.customer.email,
			address: $scope.customer.dir,
			obs: $scope.customer.obs,
			neighbor: $scope.customer.bar.id,
			personality: $scope.customer.personeria.id,
			service: $scope.customer.service.id,
			ident: $scope.customer.id.id,
			NoID: $scope.customer.noID
		};
		if ($scope.customer.personeria.name === "Juridica") {
			url = Config.endpoints.createClientCJ.url;
			method = Config.endpoints.createClientCJ.method;
		}

		params_.userID = Config.user.Id;
		$http({
			url: url,
			method: method,
			params: params_
		}).then(function(data) {
			createCustomerObj();
			toaster.pop('success', "", "Client creada correctamente");
		}, function(error) {
			toaster.pop('error', "", "Error al crear el cliente");
			console.log("Error creating customer: " + JSON.stringify(error));
		});
	};
	$scope.onCancel = function() {
		$window.history.back();
	};

	$scope.loadIDs = function() {
		getIDs();
	};

	function initialize() {
		createCustomerObj();
		getPersonality();
		getServices();
		getNeighbors();
	}

	function getPersonality() {
		$http.get(Config.endpoints.getPersonality.url).then(function(data) {
			$scope.customer.personeria = data.data.filter(function(e) {
				return e.name === "Natural";
			})[0];
			$scope.personeria = data.data;
			getIDs();
		}, function(error) {
			console.log("Error getting personalities: " + JSON.stringify(error));
		});
	}

	function getServices() {
		$http.get(Config.endpoints.getServices.url).then(function(data) {
			$scope.customer.service = data.data[0];
			$scope.services = data.data;
		}, function(error) {
			console.log("Error getting services: " + JSON.stringify(error));
		});
	}

	function getNeighbors() {
		$http.get(Config.endpoints.getNeighborhoods.url).then(function(data) {
			$scope.customer.bar = data.data[0];
			$scope.neighborhoods = data.data;
		}, function(error) {
			console.log("Error getting neighborhoods: " + JSON.stringify(error));
		});
	}

	function getIDs() {
		$http({
			url: Config.endpoints.getIDs.url,
			method: "GET",
			params: {
				personality_id: $scope.customer.personeria.id
			}
		}).then(function(data) {
			$scope.idsArray = data.data;
			$scope.customer.id = data.data[0];
		}, function(error) {
			console.log("Error getting ids: " + JSON.stringify(error));
		});
	}
}]);
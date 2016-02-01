angular.module('SCC').controller('crearCliente_ctrl', ["$scope", "$http", "Config", '$window', "toaster", "Util", "$routeParams", function($scope, $http, Config, $window, toaster, Util, $routeParams) {
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
			noID: "",
			company: "",
			representant: "",
			position: "",
			fax: ""
		};
	}
	$scope.finishLoading = 0;

	if ($routeParams.id) {
		$scope.mode = "edit";
		var params = $routeParams.id.split("-");
		$scope.customerID = params[0];
		$scope.personality = parseInt(params[1], 0);
	}
	initialize();

	$scope.addClient = function() {
		var url, method;
		var params_ = {
			first_name: Util.toTitleCase($scope.customer.first_name),
			middle_name: Util.toTitleCase($scope.customer.middle_name),
			first_last: Util.toTitleCase($scope.customer.first_last),
			second_last: Util.toTitleCase($scope.customer.second_last),
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


		if ($scope.mode) {
			url = Config.endpoints.updateCustomerCN.url;
			method = Config.endpoints.updateCustomerCN.method;
			params_.contractID = $scope.customer.contractID;
			params_.IDCustomer = $scope.customerID;
			params_.customerStatus = $scope.customer.status;
			if ($scope.personality === 2) {
				url = Config.endpoints.updateCustomerCJ.url;
				method = Config.endpoints.updateCustomerCJ.method;
				params_.company_name = $scope.customer.company;
				params_.representant = $scope.customer.representant;
				params_.position = $scope.customer.position;
				params_.fax = $scope.customer.fax;
			}
		} else {
			url = Config.endpoints.createClientCN.url;
			method = Config.endpoints.createClientCN.method;

			if ($scope.customer.personeria.name === "Juridica") {
				url = Config.endpoints.createClientCJ.url;
				method = Config.endpoints.createClientCJ.method;
				params_.company_name = $scope.customer.company;
				params_.representant = $scope.customer.representant;
				params_.position = $scope.customer.position;
				params_.fax = $scope.customer.fax;
			}
		}



		params_.userID = Config.user.Id;
		$http({
			url: url,
			method: method,
			params: params_
		}).then(function(data) {
			if (!$scope.mode) {
				createCustomerObj();
			}
			toaster.pop('success', "", "Cliente creado correctamente");
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


	function getCustomer() {
		var url = Config.endpoints.getCNCustomer.url;

		if ($scope.personality === 2) {
			url = Config.endpoints.getCJCustomer.url;
		}

		$http({
			url: url,
			method: "GET",
			params: {
				customerID: $scope.customerID
			}
		}).then(function(data) {
			$scope.customer.first_name = data.data[0].first_name;
			$scope.customer.middle_name = data.data[0].middle_name;
			$scope.customer.first_last = data.data[0].first_last;
			$scope.customer.second_last = data.data[0].second_last;
			$scope.customer.extens = data.data[0].extens;
			$scope.customer.tel = data.data[0].phone;
			$scope.customer.email = data.data[0].email;
			$scope.customer.dir = data.data[0].address;
			$scope.customer.obs = data.data[0].obs;
			$scope.customer.bar = $scope.neighborhoods.filter(function(e) {
				return e.id === data.data[0].neighbor;
			})[0];
			$scope.customer.personeria = $scope.personeria.filter(function(e) {
				return e.id === data.data[0].personality;
			})[0];
			$scope.customer.service = $scope.services.filter(function(e) {
				return e.id === data.data[0].service;
			})[0];
			$scope.customer.id = $scope.idsArray.filter(function(e) {
				return e.id === data.data[0].id_type;
			})[0];
			$scope.customer.noID = data.data[0].noID;
			$scope.customer.contractID = data.data[0].contractID;
			$scope.customer.status = data.data[0].customer_status;
			if ($scope.personality === 2) {
				$scope.customer.company = data.data[0].company_name;
				$scope.customer.representant = data.data[0].representant;
				$scope.customer.position = data.data[0].position;
				$scope.customer.fax = data.data[0].fax;
			}
		}, function(error) {
			console.log("Error getting customer");
		});
	}

	function getPersonality() {
		++$scope.finishLoading;
		$http.get(Config.endpoints.getPersonality.url).then(function(data) {
			$scope.customer.personeria = data.data.filter(function(e) {
				return e.name === "Natural";
			})[0];
			$scope.personeria = data.data;
			getIDs();
			--$scope.finishLoading;
		}, function(error) {
			console.log("Error getting personalities: " + JSON.stringify(error));
		});
	}

	function getServices() {
		$scope.finishLoading++;
		$http.get(Config.endpoints.getServices.url).then(function(data) {
			$scope.customer.service = data.data[0];
			$scope.services = data.data;
			$scope.finishLoading--;
		}, function(error) {
			console.log("Error getting services: " + JSON.stringify(error));
		});
	}

	function getNeighbors() {
		++$scope.finishLoading;
		$http.get(Config.endpoints.getNeighborhoods.url).then(function(data) {
			$scope.customer.bar = data.data[0];
			$scope.neighborhoods = data.data;
			--$scope.finishLoading;
		}, function(error) {
			console.log("Error getting neighborhoods: " + JSON.stringify(error));
		});
	}

	function getIDs() {
		++$scope.finishLoading;
		$http({
			url: Config.endpoints.getIDs.url,
			method: "GET",
			params: {
				personality_id: $scope.personality ? $scope.personality : $scope.customer.personeria.id
			},
			cache: true
		}).then(function(data) {
			$scope.idsArray = data.data;
			$scope.customer.id = data.data[0];
			--$scope.finishLoading;
		}, function(error) {
			console.log("Error getting ids: " + JSON.stringify(error));
		});
	}

	$scope.$watch('finishLoading', function(newVal) {
		if ($scope.mode && newVal === 0) {
			getCustomer();
		}
	});

}]);
angular.module('SCC').controller('listaClientes_ctrl', ["$scope", "$location", "$http", "Config", "$timeout", "Util", function($scope, $location, $http, Config, $timeout, Util) {

	$scope.columnSort = "ID";
	$scope.reverseSort = false;
	$scope.seeFilter = 1;

	$scope.table = {
		header: {},
		body: [],
		metadata: [],
		isLoading: false
	};


	$scope.createClient = function() {
		$location.path("/crearCliente");
	};
	$scope.sort = {
		column: 'idClient',
		descending: false
	};

	function getCNCustomers() {
		$scope.table.body = [];
		$scope.table.isLoading = true;
		$scope.table.metadata = [];
		$scope.table.header = {
			idClient: "ID",
			first_name: "Primer Nombre",
			middle_name: "Segundo Nombre",
			first_last: "Primer Apellido",
			second_last: "Segundo Apellido",
			bar: "Barrio/Colonia",
			status: "Estado de Cliente",
			contract: "No. Contrato",
			service: "Servicio",
			date: "Fecha de Instalación"
		};
		$http.get(Config.endpoints.getCNCustomers.url).then(function(data) {
			data.data.forEach(function(val, i) {
				$scope.table.body.push({
					idClient: val.ID,
					first_name: val.first_name,
					middle_name: val.middle_name,
					first_last: val.first_last,
					second_last: val.second_last,
					bar: val.neighbor,
					status: val.customer_status,
					contract: val.contract,
					service: val.service,
					date: Util.formatDate(val.inst_date)
				});
				$scope.table.metadata.push(val);
			});
			$scope.table.isLoading = false;
		}, function(error) {
			$scope.table.isLoading = false;
			console.log("Error getting natural customers: " + JSON.stringify(error));
		});
	}

	function getCJCustomers() {
		$scope.table.body = [];
		$scope.table.isLoading = true;
		$scope.table.metadata = [];
		$scope.table.header = {
			idClient: "ID",
			company_name: "Nombre de Empresa",
			representant: "Representante",
			position: "Cargo",
			bar: "Barrio/Colonia",
			status: "Estado de Cliente",
			contract: "No. Contrato",
			service: "Servicio",
			date: "Fecha de Instalación"
		};
		$http.get(Config.endpoints.getCJCustomers.url).then(function(data) {
			data.data.forEach(function(val, i) {
				$scope.table.body.push({
					idClient: val.ID,
					company_name: val.company_name,
					representant: val.representant,
					position: val.position,
					bar: val.neighbor,
					status: val.customer_status,
					contract: val.contract,
					service: val.service,
					date: Util.formatDate(val.inst_date)
				});
				$scope.table.metadata.push(val);
			});
			$scope.table.isLoading = false;
		}, function(error) {
			$scope.table.isLoading = false;
			console.log("Error getting juridic customers: " + JSON.stringify(error));
		});
	}
	$scope.selectedCls = function(column) {
		return column === $scope.sort.column && 'sort-' + $scope.sort.descending;
	};

	$scope.changeSorting = function(column) {
		var sort = $scope.sort;
		if (sort.column === column) {
			sort.descending = !sort.descending;
		} else {
			sort.column = column;
			sort.descending = false;
		}
	};

	$scope.seeDetails = function(client) {
		var customerIndex = $scope.table.body.indexOf(client);
		$scope.modalContent = $scope.table.metadata[customerIndex];
		if ($scope.seeFilter === 1) {
			$scope.modalTitle = client.first_name + " " + client.middle_name + " " + client.first_last + " " + client.second_last;
		}
		else{
			$scope.modalTitle = client.company_name;
		}
		$("#clientDetail").modal('show');
	};

	function initialize() {
		$scope.seeBy();
	}
	$scope.seeBy = function() {
		if ($scope.seeFilter === 1) {
			getCNCustomers();
		} else {
			getCJCustomers();
		}
	};
	$scope.editCustomer = function() {
		$("#clientDetail").modal('hide');
		$timeout(function() {
			$location.path("/crearCliente/" + $scope.modalContent.ID + "-" + $scope.seeFilter);
		}, 500);
	};

	initialize();
}]);
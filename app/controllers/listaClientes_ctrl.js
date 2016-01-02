angular.module('SCC').controller('listaClientes_ctrl', ["$scope", "$location", "$http", "Config", function($scope, $location, $http, Config) {

	$scope.columnSort = "ID";
	$scope.reverseSort = false;

	initialize();
	$scope.table = {
		header: {
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
		},
		body: [],
		metadata: []
	};


	$scope.createClient = function() {
		$location.path("/crearCliente");
	};
	$scope.sort = {
		column: 'idClient',
		descending: false
	};

	function getCNCustomers() {
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
					date: val.inst_date
				});
				$scope.table.metadata.push(val);
			});
		}, function(error) {
			console.log("Error getting natural customers: " + JSON.stringify(error));
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
		$scope.modalContent = client;
		$scope.modalTitle = client.first_name + " " + client.first_last;
		$("#clientDetail").modal('show');
	};

	function initialize() {
		getCNCustomers();
	}
}]);
angular.module('SCC').controller('listaCobro_ctrl', ["$scope", "$location", "$http", "Config", function($scope, $location, $http, Config) {
	$scope.columnSort = "ID";
	$scope.reverseSort = false;

	$scope.table = {
		expandedTable: {
			header: ["Fact.",
				"Fecha",
				"Mes en Mora",
				"Servicio",
				"Est. de Pago",
				"Total"
			]
		}
	};

	$scope.sort = {
		column: 'idClient',
		descending: false
	};

	initialize();

	function getPaymentStatus() {
		$http.get(Config.endpoints.getPaymentStatus.url).then(function(data) {
			$scope.payStatus = data.data;
			loadClients();
		}, function(error) {
			console.log("Error getting payment status " + JSON.stringify(error));
		});
	}
	$scope.getHeaderSize = function() {
		if ($scope.table.header) {
			return Object.keys($scope.table.header).length;
		}
	};

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

	$scope.seeDetails = function(rowObj) {
		rowObj.showExpandedData = !rowObj.showExpandedData;
	};

	$scope.openPaymentModal = function(row, index) {
		var client = row.row;
		$scope.modalContent = {
			row: row,
			expandedRow: row.expandedRow[index]
		};
		$scope.modalTitle = client.first_name + " " + client.middle_name + " " + client.first_last + " " + client.second_last;
		$("#clientDetail").modal('show');
	};
	$scope.seeBy = function() {
		if ($scope.seeFilter === "1") {
			loadClients();
		} else {
			loadCompanies();
		}
	};
	$scope.selectClick = function($event) {
		$event.stopPropagation();
	};

	$scope.setSelectedStatus = function(status) {
		return status === 'Pendiente - No Visitado ';
	};

	function loadCompanies() {
		$scope.table.header = {
			idClient: "ID",
			company: "Nombre de la Empresa",
			representant: "Representante",
			bar: "Barrio/Colonia",
			monthToPay: "Mes(es) a Pagar",
			status: "Estado de Cobro",
			date: "Fecha de Visita",
			service: "Servicio",
			amount: "Cant. a Pagar"
		};

		$scope.table.body = [];
	}

	function loadClients() {
		$scope.table.header = {
			idClient: "ID",
			first_name: "Primer Nombre",
			middle_name: "Segundo Nombre",
			first_last: "Primer Apellido",
			second_last: "Segundo Apellido",
			bar: "Barrio/Colonia",
			monthToPay: "Mes(es) a Pagar",
			status: "Estado de Cobro",
			date: "Fecha de Visita",
			service: "Servicio",
			amount: "Cant. a Pagar"
		};
		$scope.table.isSelect = [
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			1,
			0,
			0,
			0
		];
		$scope.table.body = [{
			row: {
				idClient: "1201",
				first_name: "Osman",
				middle_name: "Gabriel",
				first_last: "Hernandez",
				second_last: "Cerrato",
				bar: "MAX",
				monthToPay: "1",
				status: "Visitado",
				date: "12-04-2002",
				service: "TV",
				amount: "150.00"
			},
			showExpandedData: false,
			expandedRow: [{
				fact: "1001",
				date: "20/12/15",
				month_pay: "Marzo",
				service: "TV",
				pay_status: "En Mora",
				total: "150.00"
			}]
		}, {
			row: {
				idClient: "1202",
				first_name: "Antonio",
				middle_name: "Pedro",
				first_last: "Caceres",
				second_last: "Rodriguez",
				bar: "ROT",
				monthToPay: "2",
				status: "No Visitado",
				date: "12-04-2002",
				service: "TV",
				amount: "150.00"
			},
			showExpandedData: false,
			expandedRow: [{
				fact: "1001",
				date: "20/12/15",
				month_pay: "Marzo",
				service: "TV",
				pay_status: "Vencido",
				total: "150.00"
			}, {
				fact: "1002",
				date: "20/12/15",
				month_pay: "Abril",
				service: "TV",
				pay_status: "Vencido",
				total: "150.00"
			}]
		}, {
			row: {
				idClient: "1203",
				first_name: "Etel",
				middle_name: "Maria",
				first_last: "Mejia",
				second_last: "Iglesias",
				bar: "MAM",
				monthToPay: "1",
				status: "Visitado",
				date: "12-04-2002",
				service: "TV",
				amount: "150.00"
			},
			showExpandedData: false,
			expandedRow: [{
				fact: "1001",
				date: "20/12/15",
				month_pay: "Marzo",
				service: "TV",
				pay_status: "En Mora",
				total: "150.00"
			}]
		}, {
			row: {
				idClient: "1204",
				first_name: "Juan",
				middle_name: "Pablo",
				first_last: "Maradiaga",
				second_last: "Cortes",
				bar: "CEI",
				monthToPay: "3",
				status: "No Visitado",
				date: "12-04-2002",
				service: "TV",
				amount: "150.00"
			},
			showExpandedData: false,
			expandedRow: [{
				fact: "1001",
				date: "20/12/15",
				month_pay: "Marzo",
				service: "TV",
				pay_status: "Vencido",
				total: "150.00"
			}]
		}];

	}

	function initialize() {
		getPaymentStatus();
	}
}]);
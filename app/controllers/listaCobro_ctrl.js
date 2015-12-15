angular.module('SCC').controller('listaCobro_ctrl', ["$scope", "$location", function($scope, $location) {
	$scope.columnSort = "ID";
	$scope.reverseSort = false;
	$scope.table = {
		header: {
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
		},
		expandedTable: {
			header: ["Fact.",
				"Fecha",
				"Mes en Mora",
				"Servicio",
				"Est. de Pago",
				"Est. de Cobro",
				"Fecha Visita",
				"Total"
			]
		},
		body: [{
			row: {
				idClient: "1201",
				first_name: "Osman",
				middle_name: "Gabriel",
				first_last: "Hernandez",
				second_last: "Cerrato",
				bar: "MAX",
				monthToPay: "1",
				status: "En Mora",
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
				inc_status: "No Visitado",
				visit_date: "--",
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
				status: "Pagado",
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
				inc_status: "No Visitado",
				visit_date: "--",
				total: "150.00"
			},{
				fact: "1002",
				date: "20/12/15",
				month_pay: "Marzo",
				service: "TV",
				pay_status: "Vencido",
				inc_status: "No Visitado",
				visit_date: "--",
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
				status: "En Mora",
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
				inc_status: "No Visitado",
				visit_date: "--",
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
				status: "En Mora",
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
				inc_status: "No Visitado",
				visit_date: "--",
				total: "150.00"
			}]
		}]
	};

	$scope.sort = {
		column: 'idClient',
		descending: false
	};

	$scope.getHeaderSize = function() {
		return Object.keys($scope.table.header).length;
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

		// $scope.modalContent = client;
		// $scope.modalTitle = client.first_name + " " + client.first_last;
		// $("#clientDetail").modal('show');
	};

	$scope.seeBy = function() {
		if ($scope.seeFilter === "1") {
			console.log("Show Cliente Natural");
		} else {
			console.log("Show Cliente Juridico");
		}
	};
}]);
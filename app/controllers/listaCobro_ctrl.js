angular.module('SCC').controller('listaCobro_ctrl', ["$scope", "$location", "$http", "Config", "toaster", "$timeout", function($scope, $location, $http, Config, toaster, $timeout) {
	$scope.columnSort = "ID";
	$scope.reverseSort = false;
	$scope.discount = "0.00";
	$scope.table = {
		expandedTable: {
			header: ["Fact.",
				"Fecha",
				"Mes en Mora",
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
		if (rowObj.showExpandedData) {
			rowObj.isLoadingExpandedData = true;
			rowObj.expandedRow = [];
			loadExpandedData(rowObj.metadata.idClient, function(data) {
				data.data.forEach(function(val, i) {
					rowObj.expandedRow.push({
						fact: val.ID,
						date: val.bill_date,
						month_to_pay: getMonthName(val.month),
						income_status: val.payment_status,
						total: parseFloat(val.total).toFixed(2)
					});
				});
				rowObj.isLoadingExpandedData = false;
			}, function() {
				rowObj.isLoadingExpandedData = false;
			});
		}
	};

	function loadExpandedData(customerID, successCallback, erroCallback) {
		$http({
			url: Config.endpoints.getBillDetails.url,
			method: "GET",
			params: {
				customerID: customerID
			},
			cache: true
		}).then(function(data) {
			successCallback(data);
		}, function(error) {
			erroCallback();
			console.log("Error getting bill details: " + JSON.stringify(error));
		});
	}
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


	function loadCompanies() {
		$scope.table.header = {
			idOrder: "",
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
		$scope.isLoadingTable = true;
		$scope.table.body = [];
		$scope.table.header = {
			idOrder: "",
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
		/*
		 0 For Span,
		 1 for Select,
		 2 for input
		*/
		$scope.table.isSelect = [
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			1,
			2,
			0,
			0
		];

		$http.get(Config.endpoints.getPaymentList.url).then(function(data) {
			data.data.forEach(function(val, i) {
				$scope.table.body.push({
					row: {
						idOrder: (i + 1),
						first_name: val.first_name,
						middle_name: val.middle_name,
						first_last: val.first_last,
						second_last: val.second_last,
						bar: val.neighbor,
						monthToPay: val.month_to_pay,
						status: $scope.payStatus.filter(function(status) {
							return status.name === val.payment_status;
						})[0],
						date: val.visit_date ? new Date(val.visit_date) : "",
						service: val.service,
						amount: parseFloat(val.total).toFixed(2)
					},
					metadata: {
						idClient: val.IDClient,
						idContract: val.IDContract
					},
					showExpandedData: false,
					isLoadingExpandedData: false,
					expandedRow: []
				});
			});
			$scope.isLoadingTable = false;
		}, function(error) {
			$scope.isLoadingTable = false;
			console.log("Error getting payment status " + JSON.stringify(error));
		});

	}

	function getMonthName(monthNumber) {
		var month = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
		return month[monthNumber - 1];
	}

	$scope.updateIncStatus = function(incStatus, rowObj) {
		if (incStatus.name !== "Realizado") {
			$http({
				url: Config.endpoints.updateOrderStatus.url,
				method: Config.endpoints.updateOrderStatus.method,
				params: {
					contractID: rowObj.metadata.idContract,
					status: incStatus.id,
					userID: Config.user.Id
				}
			}).then(function(data) {
				toaster.pop('success', "", "Estado de orden de cobro actualizado");
			}, function(error) {
				toaster.pop('error', "", "Error al actualizar estado de orden de cobro");
				console.log("Error updating order status: " + JSON.stringify(error));
			});
		} else {
			loadExpandedData(rowObj.metadata.idClient, function(data) {
				data.data.forEach(function(val, i) {
					rowObj.expandedRow.push({
						fact: val.ID,
						date: val.bill_date,
						month_to_pay: getMonthName(val.month),
						income_status: val.payment_status,
						total: parseFloat(val.total).toFixed(2)
					});
				});
				$scope.openPaymentModal(rowObj, 0);
			});
		}
	};
	$scope.updateVisitDate = function(date_, rowObj) {
		if (date_) {
			$http({
				url: Config.endpoints.updateOrderVisitDate.url,
				method: Config.endpoints.updateOrderVisitDate.method,
				params: {
					contractID: rowObj.metadata.idContract,
					visitDate: formatDatetoMYSQLFormat(date_),
					userID: Config.user.Id
				}
			}).then(function(data) {
				toaster.pop('success', "", "Fecha de visita de orden de cobro actualizado");
			}, function(error) {
				toaster.pop('error', "", "Error al actualizar fecha de visita de orden de cobro");
				console.log("Error updating order visit date: " + JSON.stringify(error));
			});
		}
	};

	function initialize() {
		getPaymentStatus();
	}

	function formatDatetoMYSQLFormat(date_) {
		var toFixDate = new Date(date_);
		var fixedDate = toFixDate.getFullYear() + "/" + (toFixDate.getMonth() + 1) + "/" + toFixDate.getDate();
		return fixedDate;
	}

	$scope.processPayment = function() {
		var total = modalContent.expandedRow.total;
		$htttp({
			url: Config.endpoints.makePayment.url,
			methodL Config.endpoints.makePayment.method,
			params:{
				contractID: $scope.modalContent.row.metadata.idContract, 
				amountPaid: $scope.amountPaid, 
				discount: $scope.discount, 
				numFact: $scope.numRecibo, 
				userID: Config.user.Id
			}
		}).then();
	};
}]);
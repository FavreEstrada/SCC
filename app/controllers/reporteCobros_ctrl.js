angular.module('SCC').controller('reporteCobros_ctrl', ["$scope", "$location", "Config", "$http", "toaster", "Util", "$filter", function($scope, $location, Config, $http, toaster, Util, $filter) {

	$scope.table = {
		header: {
			id: "",
			name: "Nombre",
			neighbor: "Barrio/Colonia",
			contractID: "No. Contrato",
			service: "Servicio",
			date: "Fecha Factura",
			paid_date: "Fecha Cobrado",
			month: "Mes Cobrado",
			received_by: "Cobrado Por",
			discount: "Descuento",
			paid_amount: "Cantidad Pagada",
			total: "Total"
		},
		body: []
	};
	$scope.totalRecaudado = 0;
	$scope.sort = {
		column: 'idClient',
		descending: false
	};
	$scope.columnSort = "ID";
	$scope.reverseSort = false;
	$scope.isLoading = false;

	function getUsers() {
		$http.get(Config.endpoints.getUsers.url).then(function(data) {
			$scope.users = [{
				userID: -1,
				userName: "Todos"
			}];
			data.data.forEach(function(usr, ind) {
				$scope.users.push(usr);
			});
			$scope.collector = $scope.users[0];
		}, function(error) {
			console.log("Error getting users: " + JSON.stringify(error));
		});
	}

	function getNeighbors() {
		$http.get(Config.endpoints.getAllNeighborhoods.url).then(function(data) {
			$scope.neighbors = [{
				id: -1,
				abbr: "Todos"
			}];
			data.data.forEach(function(neigh, ind) {
				$scope.neighbors.push(neigh);
			});
			$scope.neighbor = $scope.neighbors[0];
		}, function(error) {
			console.log("Error getting neighbors: " + JSON.stringify(error));
		});
	}

	function getReportsCN() {
		$scope.isLoading = true;
		$http({
			url: Config.endpoints.paymentReportCN.url,
			params: {
				neighbor: $scope.neighbor.id,
				collector: $scope.collector.userID,
				dateRange: {
					start: $filter('date')($scope.startDate, "yyyy-MM-dd"),
					end: $scope.endDate ? $filter('date')($scope.endDate, "yyyy-MM-dd") : $filter('date')(new Date(), "yyyy-MM-dd")
				}
			}
		}).then(function(data) {
			if (data.data.length === 0) {
				toaster.pop('warning', "", "No se encontraron datos para clientes naturales");
			} else {
				data.data.forEach(function(order, ind) {
					$scope.table.body.push({
						id: $scope.table.body.length + 1,
						name: order.name,
						neighbor: order.abbr,
						contractID: order.contractID,
						service: order.service,
						date: Util.formatDate(order.date),
						paid_date: Util.formatDate(order.paidDate),
						month: Util.getMonthYear(order.date),
						received_by: order.collector,
						discount: order.discount ? parseFloat(order.discount).toFixed(2) : "",
						paid_amount: parseFloat(order.paidAmount).toFixed(2),
						total: parseFloat(order.total).toFixed(2)
					});
					$scope.totalRecaudado = $scope.totalRecaudado + order.paidAmount;
				});
			}
			$scope.isLoading = false;
		}, function(error) {
			$scope.isLoading = false;
			console.log("Error getting neighbors: " + JSON.stringify(error));
		});
	}

	function getReportsCJ() {
		$scope.isLoading = true;
		$http({
			url: Config.endpoints.paymentReportCJ.url,
			params: {
				neighbor: $scope.neighbor.id,
				collector: $scope.collector.userID,
				dateRange: {
					start: $filter('date')($scope.startDate, "yyyy-MM-dd"),
					end: $scope.endDate ? $filter('date')($scope.endDate, "yyyy-MM-dd") : $filter('date')(new Date(), "yyyy-MM-dd")
				}
			}
		}).then(function(data) {
			if (data.data.length === 0) {
				toaster.pop('warning', "", "No se encontraron datos para clientes jurídicos");
			} else {
				data.data.forEach(function(order, ind) {
					$scope.table.body.push({
						id: $scope.table.body.length + 1,
						name: order.name,
						neighbor: order.abbr,
						contractID: order.contractID,
						service: order.service,
						date: Util.formatDate(order.date),
						paid_date: Util.formatDate(order.paidDate),
						month: Util.getMonthYear(order.date),
						received_by: order.collector,
						discount: order.discount ? parseFloat(order.discount).toFixed(2) : "",
						paid_amount: parseFloat(order.paidAmount).toFixed(2),
						total: parseFloat(order.total).toFixed(2)
					});
					$scope.totalRecaudado = $scope.totalRecaudado + order.paidAmount;
				});
			}
			$scope.isLoading = false;
		}, function(error) {
			$scope.isLoading = false;
			console.log("Error getting neighbors: " + JSON.stringify(error));
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

	$scope.getHeaderLength = function() {
		return Object.keys($scope.table.header).length;
	};
	$scope.update = function() {
		$scope.table.body = [];
		$scope.totalRecaudado = 0;
		getReportsCN();
		getReportsCJ();
	};

	function initialize() {
		getNeighbors();
		getUsers();

	}

	$scope.$watchGroup(['neighbors', 'users'], function(values) {
		if (values[0] && values[1]) {
			$scope.update();
		}
	});
	$scope.$watchGroup(['startDate', 'endDate'], function(values) {
		if (values[0] && values[1]) {	
			$scope.update();
		}
	});

	initialize();
}]);
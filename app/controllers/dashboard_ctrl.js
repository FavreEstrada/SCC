angular.module('SCC').controller('dashboard_ctrl', ["$scope", "$location", "$http", "Config", "Util", "$window", 'toaster', '$rootScope', function($scope, $location, $http, Config, Util, $window, toaster, $rootScope) {
	$scope.chartObject = {};
	$scope.isLoading = false;
	$scope.filters = [{
		id: 0,
		value: "Diario"
	}, {
		id: 1,
		value: "Mensual"
	}, {
		id: 2,
		value: "Anual"
	}];
	$scope.period = {
		id: 0,
		value: "Diario"
	};
	$scope.neighbor = {
		id: 'total',
		abbr: 'Todos'
	};
	var resizeFuncs = [];
	$scope.chartObject = {
		incomeChart: {
			options: {
				chart: {},
				"vAxis": {
					format: "short"
				},
				legend: {
					position: 'out',
					alignment: 'center'
				},

			}
		},
		incomeComparison: {
			options: {
				chart: {},
				"vAxis": {
					format: "short"
				},
				legend: {
					position: 'right',
					alignment: 'center'
				},
				colors: ['#1b9e77', '#d95f02', '#7570b3']
			}
		},
		debtComparison: {
			options: {
				title: 'Comparación Mora por Barrio',
				pieHole: 0.4,
				titleTextStyle: {
					color: '#757575',
					fontName: 'Roboto',
					fontSize: 16,
					bold: false
				},
				chartArea: {
					top: 100
				}
			}
		},
		debtCollectedComparison: {
			options: {
				title: 'Comparación Mora vs. Recolección',
				pieHole: 0.4,
				titleTextStyle: {
					color: '#757575',
					fontName: 'Roboto',
					fontSize: 16,
					bold: false
				},
				chartArea: {
					top: 100
				}
			}
		}
	};

	function drawChart(container, data, options, type) {
		var data_ = google.visualization.arrayToDataTable(data);
		var chart;
		if (type !== 'PieChart') {
			if ($rootScope.noInternet) {
				chart = new google.visualization.ColumnChart(container);
			} else {
				chart = new google.charts[type](container);
			}
		} else {
			chart = new google.visualization.PieChart(container);
		}
		chart.draw(data_, options);
	}
	$scope.update = function() {
		renderIncomeChart();
	};

	function initialize() {
		renderIncomeChart();
		renderComparisonIncomeChart();
		renderDebtComparisonChart();
		renderDebtCollectedComparisonChart();
	}

	function renderIncomeChart() {
		$scope.isLoading = true;
		$http({
			url: Config.endpoints.collectingReport.url,
			method: Config.endpoints.collectingReport.method,
			params: {
				period: $scope.period.id
			}
		}).then(function(data) {
			var legend, title, subtitle;
			title = "Recaudación por Órdenes de Cobro: ";
			$scope.chartObject.incomeChart.data = null;
			if ($scope.period.id === 0) {
				legend = "Dia";
				title = title.concat($scope.period.value);

				var date = new Date();
				subtitle = Util.getMonthName(date.getMonth() + 1) + " " + date.getFullYear();

			} else if ($scope.period.id === 1) {
				legend = "Mensual";
				title = title.concat($scope.period.value);
				subtitle = "Mes Anterior Vs. Mes Actual";
			} else {
				legend = "Anual";
				title = title.concat($scope.period.value);
				subtitle = "Enero - Diciembre";
			}
			var rows = [];
			Object.keys(data.data).forEach(function(val, ind) {
				rows.push([$scope.period.id === 0 ? val : Util.getMonthYear(val), data.data[val]]);
			});
			if (Object.keys(data.data).length) {
				rows.sort(function(a, b) {
					return a > b;
				});
				rows.unshift([legend, 'Lempiras']);
				$scope.chartObject.incomeChart.data = rows;
				$scope.chartObject.incomeChart.options.chart.title = title;
				$scope.chartObject.incomeChart.options.chart.subtitle = subtitle;
				drawChart(angular.element("#bargraph")[0], $scope.chartObject.incomeChart.data, $scope.chartObject.incomeChart.options, 'Bar');
				resizeFuncs.push([angular.element("#bargraph")[0], $scope.chartObject.incomeChart.data, $scope.chartObject.incomeChart.options, 'Bar']);
			}
			$scope.isLoading = false;
		}, function(error) {
			$scope.isLoading = false;
			toaster.pop('error', "", "No se pudo generar gráfico de comparación de Ingresos: " + $scope.period.value);
			console.log("Error retrieving data for collecting chart");
		});
	}

	function renderComparisonIncomeChart() {
		$scope.isLoading = true;
		$http.get(Config.endpoints.collectingComparisonReport.url).then(function(data) {

			var rows;
			rows = [Object.keys(data.data).map(function(key) {
				return Util.getMonthYear(key);
			})];


			var values = [];
			Object.keys(data.data).forEach(function(val, ind) {
				if (ind === 0) {
					rows[0].unshift(Util.getMonthName(val.substr(0, val.indexOf("-"))));
				}
				values.push(data.data[val]);
			});
			if (Object.keys(data.data).length) {
				values.unshift(" ");
				rows[1] = values;
				$scope.chartObject.incomeComparison.data = rows;
				$scope.chartObject.incomeComparison.options.chart.title = "Recaudación por Órdenes de Cobro: ";
				$scope.chartObject.incomeComparison.options.chart.subtitle = "Mes Año Actual vs. Mes Año Pasado";
				drawChart(angular.element("#bargraphComparisonMonth")[0], $scope.chartObject.incomeComparison.data, $scope.chartObject.incomeComparison.options, 'Bar');
				resizeFuncs.push([angular.element("#bargraphComparisonMonth")[0], $scope.chartObject.incomeComparison.data, $scope.chartObject.incomeComparison.options, 'Bar']);
			}
			$scope.isLoading = false;
		}, function(error) {
			$scope.isLoading = false;
			toaster.pop('error', "", "No se pudo generar gráfico de comparación de Ingresos: Mes Año Actual Vs. Mes Año Pasado");
			console.log("Error retrieving data for collecting comparison chart");
		});
	}

	function renderDebtComparisonChart() {
		$scope.isLoading = true;
		$http.get(Config.endpoints.debtComparisonReport.url).then(function(data) {
			var rows = [
				["Barrio", "Mora"]
			];
			Object.keys(data.data).forEach(function(val, ind) {
				if (val !== "total") {
					rows.push([val, parseFloat(data.data[val].debt)]);
				}
			});
			if (Object.keys(data.data).length) {
				$scope.chartObject.debtComparison.data = rows;
				drawChart(angular.element("#debtComparison")[0], $scope.chartObject.debtComparison.data, $scope.chartObject.debtComparison.options, 'PieChart');
				resizeFuncs.push([angular.element("#debtComparison")[0], $scope.chartObject.debtComparison.data, $scope.chartObject.debtComparison.options, 'PieChart']);
			}
			$scope.isLoading = false;
		}, function(error) {
			$scope.isLoading = false;
			toaster.pop('error', "", "No se pudo generar gráfico de comparación de Mora por Barrio");
			console.log("Error retrieving data for debt comparison chart");
		});
	}

	function renderDebtCollectedComparisonChart() {
		$scope.isLoading = true;
		getNeighbors();
		$http.get(Config.endpoints.debtComparisonReport.url).then(function(data) {
			$scope.debtData = data.data;
			var rows = [
				["Categoria", "Cantidad"]
			];
			if (data.data && data.data.total) {
				rows.push(['Cobrado', parseFloat(data.data.total.collected)]);
				rows.push(['Mora', parseFloat(data.data.total.debt)]);
				$scope.chartObject.debtCollectedComparison.data = rows;
				drawChart(angular.element("#debtCollectedComparison")[0], $scope.chartObject.debtCollectedComparison.data, $scope.chartObject.debtCollectedComparison.options, 'PieChart');
				resizeFuncs.push([angular.element("#debtCollectedComparison")[0], $scope.chartObject.debtCollectedComparison.data, $scope.chartObject.debtCollectedComparison.options, 'PieChart']);
			}
			$scope.isLoading = false;
		}, function(error) {
			$scope.isLoading = false;
			toaster.pop('error', "", "No se pudo generar gráfico de comparación de Mora por Barrio");
			console.log("Error retrieving data for debt comparison chart");
		});
	}

	function getNeighbors() {
		$http.get(Config.endpoints.getAllNeighborhoods.url).then(function(data) {
			$scope.neighbors = data.data;
			$scope.neighbors.unshift({
				id: 'total',
				abbr: 'Todos'
			});
			$scope.isLoading = false;

		}, function(error) {
			$scope.isLoading = false;
			toaster.pop('error', "", "No se pudo generar gráfico de comparación de Mora y Recolección");
			console.log("Error retrieving data for debt collected comparison chart");
		});
	}
	$scope.updateDebtCollectedChart = function() {
		$scope.isLoading = true;
		var rows = [
			["Categoria", "Cantidad"]
		];
		var neighborData = $scope.debtData[$scope.neighbor.id === 'total' ? 'total' : $scope.neighbor.abbr];
		if (neighborData) {
			rows.push(['Cobrado', neighborData ? parseFloat(neighborData.collected) : 0]);
			rows.push(['Mora', neighborData ? parseFloat(neighborData.debt) : 0]);
			$scope.chartObject.debtCollectedComparison.data = rows;
			drawChart(angular.element("#debtCollectedComparison")[0], $scope.chartObject.debtCollectedComparison.data, $scope.chartObject.debtCollectedComparison.options, 'PieChart');
		}
		$scope.isLoading = false;
	};

	if ($window.google) {
		initialize();
	} else {
		toaster.pop('error', "Sin Accesso a Internet", "Se requiere una conexión a Internet");
	}

	function iterateResizeFuncs() {
		resizeFuncs.forEach(function(func, ind) {
			drawChart(func[0], func[1], func[2], func[3]);
		});
	}
	angular.element(window).resize(function() {
		iterateResizeFuncs();
	});
	$scope.$on('$destroy', function() {
		iterateResizeFuncs();
	});
}]);
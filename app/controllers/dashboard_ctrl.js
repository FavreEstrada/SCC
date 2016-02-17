angular.module('SCC').controller('dashboard_ctrl', ["$scope", "$location", "$http", "Config", "Util", function($scope, $location, $http, Config, Util) {
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

	$scope.chartObject.options = {
		chart: {},
		"vAxis": {
			format: "short"
		},
		legend: {
			position: 'out',
			alignment: 'center'
		}
	};

	function drawChart() {
		var data = google.visualization.arrayToDataTable($scope.chartObject.data);

		var chart = new google.charts.Bar(angular.element("#bargraph")[0]);
		chart.draw(data, $scope.chartObject.options);
	}
	$scope.update = function() {
		renderChart();
	};

	function initialize() {
		renderChart();
	}

	function renderChart() {
		$scope.isLoading = true;
		$http({
			url: Config.endpoints.collectingReport.url,
			method: Config.endpoints.collectingReport.method,
			params: {
				period: $scope.period.id
			}
		}).then(function(data) {
			var legend, title, subtitle;
			if ($scope.period.id === 0) {
				legend = "Dia";
				title = 'Ingresos: ' + $scope.period.value;

				var date = new Date();
				subtitle = Util.getMonthName(date.getMonth() + 1) + " " + date.getFullYear();

			} else if ($scope.period.id === 1) {
				legend = "Mensual";
				title = 'Ingresos: ' + $scope.period.value;
				subtitle = "";
			} else {
				legend = "Anual";
				title = 'Ingresos: ' + $scope.period.value;
				subtitle = "";
			}
			var rows = [
				[legend, 'Lempiras']
			];
			Object.keys(data.data).forEach(function(val, ind) {
				rows.push([$scope.period.id === 1 ? Util.getMonthYear(val) : val, data.data[val]]);
			});
			$scope.chartObject.data = rows;
			$scope.chartObject.options.chart.title = title;
			$scope.chartObject.options.chart.subtitle = subtitle;
			google.charts.setOnLoadCallback(drawChart);
			$scope.isLoading = false;
		}, function(error) {
			$scope.isLoading = false;
			console.log("Error retrieving data for collecting chart");
		});
	}
	initialize();
}]);
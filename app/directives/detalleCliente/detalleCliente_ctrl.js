angular.module('SCC').directive('detalleCliente', ["$http", "Config", "Util", "toaster", function() {
	return {
		restrict: "E",
		templateUrl: "app/directives/detalleCliente/DetalleCliente.html",
		controller: function($scope, $http, Config, Util, toaster) {

			$scope.$watch('modalContent', function(newVal) {
				if (newVal) {
					$scope.extens = newVal.extens;
					$scope.id_type = newVal.id_type;
					$scope.ident = newVal.ident;
					$scope.contract = newVal.contract;
					getPayments(newVal.contract);

				}
			});
			$scope.payTable = {
				header: ["Fact.",
					"Fecha",
					"Mes en Mora",
					"Est. de Pago",
					"Est. de Cobro",
					"Fecha Visita",
					"Fecha Pagada",
					"Cant. Pagada",
					"Desc.",
					"Total"
				],
				body: []
			};

			$scope.workTable = {
				header: ["Fact.",
					"Fecha",
					"Mes en Mora",
					"Est. de Pago",
					"Est. de Orden de Trabajo",
					"Fecha Visita",
					"Total"

				],
				body: [],
				isLoading: false
			};

			function getPayments(contractID) {
				$scope.payTable.body = [];
				$scope.isLoading = true;
				$http({
					url: Config.endpoints.getPaymentsOrdersInDetails.url,
					method: "GET",
					params: {
						contractID: contractID
					}
				}).then(function(data) {
					data.data.forEach(function(val, index) {
						$scope.payTable.body.push({
							IDOrder: val.IDOrder,
							date: Util.formatDate(val.date),
							month_to_pay: Util.getMonthName(val.month_to_pay),
							payment_status: val.payment_status,
							income_status: val.income_status,
							visit_date: val.visit_date,
							paid_date: val.paid_date,
							paid_amount: parseFloat(val.paid_amount).toFixed(2),
							discount: parseFloat(val.discount).toFixed(2),
							total: parseFloat(val.total).toFixed(2)
						});
					});
					$scope.isLoading = false;
				}, function(error) {
					$scope.isLoading = false;
					console.log("Error getting Payment Orders in User Details");
				});
			}

			$scope.createPayOrder = function() {

				$http({
					url: Config.endpoints.createPaymentOrder.url,
					method: Config.endpoints.createPaymentOrder.method,
					params: {
						contractID: $scope.contract,
						userID: Config.user.Id
					}
				}).then(function(data) {
					toaster.pop('success', "", "Orden de cobro creada");
					getPayments($scope.contract);
				}, function(error) {
					toaster.pop('error', "", "Error al crear orden de cobro");
					console.log("Error getting Payment Orders in User Details");
				});
			};
		}
	};
}]);
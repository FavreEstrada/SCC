angular.module('SCC').directive('detalleCliente', [function() {
	return {
		restrict: "E",
		templateUrl: "app/directives/detalleCliente/DetalleCliente.html",
		controller: function($scope) {

			$scope.$watch('modalContent', function(newVal) {
				if (newVal) {
					$scope.name = newVal.first_name + " " + newVal.middle_name + " " + newVal.first_last + " " + newVal.second_last;
					$scope.contract = newVal.contract;
					$scope.service = newVal.service;
					$scope.extens = newVal.extens;
				}
			});
			$scope.payTable = {
				header: ["Fact.",
					"Fecha",
					"Mes en Mora",
					"Servicio",
					"Est. de Pago",
					"Est. de Cobro",
					"Fecha Visita",
					"Total"
				],
				body: []
			};

			$scope.workTable = {
				header: ["Fact.",
					"Fecha",
					"Mes en Mora",
					"Servicio",
					"Est. de Pago",
					"Est. de Cobro",
					"Fecha Visita",
					"Total"
				],
				body: []
			};
		},
	};
}]);
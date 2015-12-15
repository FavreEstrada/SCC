angular.module('SCC').directive('detalleCliente', [function() {
	return {
		restrict: "E",
		templateUrl: "app/directives/detalleCliente/DetalleCliente.html",
		controller: function($scope) {

			$scope.$watch('modalContent', function(newVal) {
				if (newVal) {
					$scope.name = $scope.modalContent.first_name + " " + $scope.modalContent.middle_name + " " + $scope.modalContent.first_last + " " + $scope.modalContent.second_last;
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
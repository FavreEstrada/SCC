angular.module('SCC').controller('reporteCobros_ctrl', ["$scope", "$location", function($scope, $location) {

	$scope.table = {
		header: {
			id: "ID",
			first_name: "Primer Nombre",
			middle_name: "Segundo Nombre",
			first_last: "Primer Apellido",
			second_last: "Segundo Apellido",
			neighbor: "Barrio/Colonia",
			contractID: "No. Contrato",
			service: "Servicio",
			paid_date: "Fecha Cobrado",
			received_by: "Cobrado Por",
			month: "Mes",
			discount: "Descuento",
			paid_amount: "Cantidad Pagada",
			total: "Total"
		}
	};
}]);
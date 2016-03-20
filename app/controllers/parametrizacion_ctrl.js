angular.module('SCC').controller('parametrizacion_ctrl', ["$scope", "$http", "Config", function($scope, $http, Config) {
	$scope.leftMenu = {
		options: [{
			name: "Parametrización de: "
		},{
			name: "Barrios/Colonias"
		}, {
			name: "Estado de Cobro"
		}, {
			name: "Estado General del Cliente"
		}, {
			name: "Estado de Orden de Trabajo"
		}, {
			name: "Estado de Pago del Cliente"
		}, {
			name: "Identificación"
		}, {
			name: "Personería"
		}, {
			name: "Prioridad"
		}, {
			name: "Rol"
		}, {
			name: "Servicio"
		}, {
			name: "Trabajo a Realizar"
		}, {
			name: "Usuario"
		}]
	};

}]);
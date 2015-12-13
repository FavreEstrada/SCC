angular.module('SCC').directive('detalleCliente', [function() {
	return {
		restrict: "E",
		scope: true,
		templateUrl: "app/directives/detalleCliente/DetalleCliente.html",
		controller: function($scope) {
			var self = this;
		},
	};
}]);
(function() {
	var dir = angular.module('SCC.directives', []);
	dir.directive('menu', function($timeout) {
		return {
			restrict: "E",
			templateUrl: "app/components/directives/Menu.html",
			controller: function() {
				var self = this;
				self.menu = {
					left: [{
						name: "Clientes",
						options: [
							/*{
														name: "Crear Cliente",
														link: "#/crearCliente"
													},  */
							{
								name: "Lista de Clientes",
								link: "#/clientes"
							}, {
								name: "Crear Solicitud Rechazada",
								link: "#/crearSolicitud"
							}
						]
					}, {
						name: "Cobros",
						options: [{
							name: "Lista de Cobros",
							link: "#/cobros"
						}]
					}, {
						name: "Reportes",
						options: [{
							name: "DashBoards",
							link: "#/dashboards"
						}, {
							name: "Solicitudes Rechazadas",
							link: "#/solicitudes"
						}, {
							name: "Órdenes",
							link: "#/ordenes"
						}]
					}, {
						name: "Parametrización",
						options: [],
						link: "#/configuracion"
					}]
				};
				$timeout(function() {
					$('.dropdown-toggle').dropdown();
					$(".no-menu").removeAttr("data-toggle");
				});

			},
			controllerAs: "menuCtrl"
		};
	});
	dir.directive('detalleCliente', function() {
		return {
			restrict: "E",
			scope: true,
			controller: function($scope) {
				var self = this;
			},
			controllerAs: "detailsCtrl",
			templateUrl: "app/components/directives/DetalleCliente.html"
		};
	});
}(this));
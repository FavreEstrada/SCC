angular.module('SCC').directive('menu', ["$timeout", function($timeout) {
	return {
		restrict: "E",
		templateUrl: "app/directives/menu/Menu.html",
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
						name: "Dashboards",
						link: "#/dashboards"
					}, {
						name: "Solicitudes Rechazadas",
						link: "#/solicitudes"
					}, {
						name: "Órdenes de Cobro",
						link: "#/reporteCobros",
					}, {
						name: "Órdenes de Trabajo",
						link: "#/reporteTrabajos",
					}]
				}, {
					name: "Parametrización",
					options: [],
					link: "#/parametrizacion"
				}]
			};
			$timeout(function() {
				$('.dropdown-toggle').dropdown();
				$(".no-menu").removeAttr("data-toggle");
			});

		},
		controllerAs: "menuCtrl"
	};
}]);
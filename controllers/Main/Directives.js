(function() {
	var dir = angular.module('SCC.directives', []);
	dir.directive('menu', function($timeout) {
		return {
			restrict: "E",
			templateUrl: "views/Main/Menu.html",
			controller: function() {
				var self = this;

				self.menu = {
					left: [{
						name: "Clientes",
						options: [{
							name: "Crear Cliente",
							link: "#"
						}, {
							name: "Busqueda de Clientes",
							link: "#"
						}, {
							name: "Crear Solicitud Rechazada",
							link: "#"
						}]
					}, {
						name: "Cobros",
						options: [{
							name: "Lista de Cobros",
							link: "#"
						}]
					}, {
						name: "Reportes",
						options: [{
							name: "DashBoards",
							link: "#"
						}, {
							name: "Lista de Clientes",
							link: "#"
						}, {
							name: "Solicitudes Rechazadas",
							link: "#"
						}, {
							name: "Órdenes",
							link: "#"
						}]
					}, {
						name: "Parametrización",
						options: []
					}]
				};
				$timeout(function() {
					$('.submenu').hover(function() {
						$(this).children('ul').show();
					}, function() {
						$(this).children('ul').hide();
					}).find("a:first").append(" &raquo; ");
					$('.dropdown-toggle').dropdown();
				});

			},
			controllerAs: "menuCtrl"
		};
	});
}(this));
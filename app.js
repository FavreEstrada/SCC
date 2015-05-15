(function() {
	var ctrls = angular.module('SCC.controllers', []);
	ctrls.controller('mainCtrl', function($scope) {
		var self = this;
	});
	ctrls.controller('crearClienteCtrl', function($scope) {
		var self = this;
		self.personeria = ["Natural", "Juridica"];
		self.tipoPer = "Natural";
		self.idsArray = [{
			name: "Identidad",
			type: "Natural"
		}, {
			name: "Pasaporte",
			type: "Natural"
		}, {
			name: "RTN",
			type: "Juridica"
		}];
		self.costumer = {
			first_name: "",
			second_name: "",
			first_last: "",
			second_last: "",
			personeria: self.tipoPer,
			id: "",
			status: 1,
			service: "Tv",
			extens: 0,
			bar: "",
			tel: "",
			email: "",
			dir: "",
			obs: ""
		};
		self.validateForm = function() {
			console.log("validar");
		};
	});
}(this));;(function() {
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
						options: [{
							name: "Crear Cliente",
							link: "#/crearCliente"
						}, {
							name: "Busqueda de Clientes",
							link: "#/clientes"
						}, {
							name: "Crear Solicitud Rechazada",
							link: "#/crearSolicitud"
						}]
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
							name: "Lista de Clientes",
							link: "#/clientes"
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
}(this));;(function() {
	var app = angular.module('SCC', ['ngRoute', 'SCC.controllers', 'SCC.directives']);
	app.config(['$routeProvider', function($routeProvider) {
		$routeProvider.when('/crearCliente', {
			templateUrl: 'app/components/controllers/CrearCliente.html',
			controller: 'crearClienteCtrl',
			controllerAs: "client"
		});
		$routeProvider.otherwise({
			redirectTo: '/menu'
		});
	}]);
}(this));
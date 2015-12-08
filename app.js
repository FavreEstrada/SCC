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
			middle_name: "",
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
		self.onCancel = function() {
			window.history.back();
		};
	});
	ctrls.controller('listaClienteCtrl', function($scope) {
		var self = this;
		self.columnSort = "ID";
		self.reverseSort = false;
		self.table = {
			header: {
				idClient: "ID",
				first_name: "Primer Nombre",
				middle_name: "Segundo Nombre",
				first_last: "Primer Apellido",
				second_last: "Segundo Apellido",
				bar: "Barrio/Colonia",
				status: "Estado de Cliente",
				contract: "No. Contrato",
				service: "Servicio",
				date: "Fecha de Instalación"
			},
			body: [{
				idClient: "1201",
				first_name: "Osman",
				middle_name: "Gabriel",
				first_last: "Hernandez",
				second_last: "Cerrato",
				bar: "MAX",
				status: "Activo",
				contract: "1234",
				service: "TV",
				date: "12-04-2002"
			}, {
				idClient: "1202",
				first_name: "Antonio",
				middle_name: "Pedro",
				first_last: "Caceres",
				second_last: "Rodriguez",
				bar: "ROT",
				status: "Activo",
				contract: "1235",
				service: "TV",
				date: "12-04-2002"
			}, {
				idClient: "1203",
				first_name: "Etel",
				middle_name: "Maria",
				first_last: "Mejia",
				second_last: "Iglesias",
				bar: "MAM",
				status: "Activo",
				contract: "1290",
				service: "TV",
				date: "12-04-2002"
			}, {
				idClient: "1204",
				first_name: "Juan",
				middle_name: "Pablo",
				first_last: "Maradiaga",
				second_last: "Cortes",
				bar: "CEI",
				status: "Activo",
				contract: "1286",
				service: "TV",
				date: "12-04-2002"
			}]
		};


		self.createClient = function() {
			window.location.hash = "/crearCliente";
		};
		self.sort = {
			column: 'idClient',
			descending: false
		};

		self.selectedCls = function(column) {
			return column === self.sort.column && 'sort-' + self.sort.descending;
		};

		self.changeSorting = function(column) {
			var sort = self.sort;
			if (sort.column === column) {
				sort.descending = !sort.descending;
			} else {
				sort.column = column;
				sort.descending = false;
			}
		};

		self.seeDetails = function(client){
			$scope.modalContent = client;
			self.modalTitle = client.first_name + " " + client.first_last;
			$("#clientDetail").modal('show');
		};
	});
}(this));
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
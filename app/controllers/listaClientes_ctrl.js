angular.module('SCC').controller('listaClientes_ctrl', ["$scope", "$location", function($scope, $location) {
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
		$location.path("/crearCliente");
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

	self.seeDetails = function(client) {
		$scope.modalContent = client;
		self.modalTitle = client.first_name + " " + client.first_last;
		$("#clientDetail").modal('show');
	};
}]);
angular.module('SCC').controller('parametrizacion_ctrl', ["$scope", "$http", "Config", function($scope, $http, Config) {
	$scope.table = {
		header: {},
		body: []
	};
	$scope.leftMenu = {
		options: [{
			name: "Parametrización de: "
		}, {
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
	$scope.selectedItem = $scope.leftMenu.options[1].name;

	function getAllNeighbors() {
		$http.get(Config.endpoints.getAllNeighborhoods.url).then(function(data) {
			$scope.table.header = {
				"name": "Nombre",
				"abbr": "Abreviación",
				"covered": "Cobertura",
				"obs": "Observación",
				"status": "Estado"
			};
			data.data.forEach(function(neighbor, i) {
				$scope.table.body.push({
					"name": neighbor.name,
					"abbr": neighbor.abbr,
					"covered": neighbor.covered === 0 ? "Si" : "No",
					"obs": neighbor.Obs,
					"status": neighbor.status === 0 ? "Si" : "No"
				});
			});

		}, function(error) {
			console.log("Error retrieving all neighbors" + JSON.stringify(error));
		});
	}

	function initialize() {
		getAllNeighbors();
	}

	initialize();

}]);
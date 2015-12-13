angular.module('SCC').controller('crearCliente_ctrl', ["$scope", function($scope) {
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
}]);
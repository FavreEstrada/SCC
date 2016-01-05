var express = require('express');
var app = express();
var http = require('http').Server(app);
var path = require('path');
var mysql = require('mysql');
var db = {
	user: "root",
	password: "admin",
	host: "localhost",
	database: "sccdb",
	charset: "latin1_swedish_ci",
	timezone: "0700",
	debug: true
};
var connection = mysql.createConnection(db);
connection.connect(function(err) {
	if (!err) {
		console.log("Database is connected");
	} else {
		console.log("Error connecting database: ", JSON.stringify(err));
	}
});

//To let call endpoints using localhost
app.all('/*', function(req, res, next) {
	res.header("Access-Control-Allow-Origin", "*");
	res.header("Access-Control-Allow-Headers", "Content-Type, X-Requested-With");
	res.header("Access-Control-Allow-Methods", "GET,PUT,POST,DELETE");
	next();
});

app.get('/testEndpoint', function(req, res) {
	return res.json("Server Alive");
});

// GENERAL 
app.get('/get_all_neighborhoods', function(req, res) {
	var query = "SELECT IDBarriocolonia as id, Nombre as name, Abreviacion as abbr, Cobertura as covered, Observacion as Obs FROM  barriocolonia ORDER BY name";

	connection.query(query, function(err, rows, fields) {
		if (!err) {
			return res.json(rows);
		} else {
			return res.status(500).send("Error in getAllNeighborhoods " + JSON.stringify(err));
		}

	});
});
app.get('/get_neighborhoods', function(req, res) {
	var query = "SELECT IDBarriocolonia as id, Nombre as name, Abreviacion as abbr, Cobertura as covered, Observacion as Obs FROM  barriocolonia WHERE Estado = 0 ORDER BY name";

	connection.query(query, function(err, rows, fields) {
		if (!err) {
			return res.json(rows);
		} else {
			return res.status(500).send("Error in getNeighborhoods " + JSON.stringify(err));
		}

	});
});
app.get('/get_services', function(req, res) {
	var query = "SELECT ID as id, Nombre as name FROM  servicio WHERE Estado = 0 ORDER BY name ";

	connection.query(query, function(err, rows, fields) {
		if (!err) {
			return res.json(rows);
		} else {
			return res.status(500).send("Error in getServices " + JSON.stringify(err));
		}

	});
});


app.get('/get_identifications', function(req, res) {
	var perID = req.query.personality_id;

	if (perID !== undefined || perID !== null) {
		var query = "SELECT ID as id, Tipo as name FROM identificacion WHERE PERSONERIA_ID = ? ORDER BY name ";

		connection.query(query, [perID], function(err, rows, fields) {
			if (!err) {
				return res.json(rows);
			} else {
				return res.send("Error in getPersonalityIds " + JSON.stringify(err));
			}

		});
	} else {
		return res.status(500).send('MIssing personality_id parameter');
	}
});
app.get('/get_personality', function(req, res) {
	var query = "SELECT ID as id, Tipo as name FROM  personeria WHERE Estado = 0 ORDER BY name ";

	connection.query(query, function(err, rows, fields) {
		if (!err) {
			return res.json(rows);
		} else {
			return res.status(500).send("Error in getPersonality " + JSON.stringify(err));
		}

	});
});

//Payment List
app.get('/get_payment_status', function(req, res) {
	var query = "SELECT ID as id, Nombre as name, Descripcion as description FROM  estado_cobro WHERE Estado = 0 ORDER BY name";

	connection.query(query, function(err, rows, fields) {
		if (!err) {
			return res.json(rows);
		} else {
			return res.status(500).send("Error in getPaymentStatus " + JSON.stringify(err));
		}

	});
});
app.get('/get_payment_list_cn', function(req, res) {
	var query = "SELECT cn.CLIENTE_idCLIENTE AS IDClient, IDOrdenCobro AS IDOrder, IDContrato as IDContract, Primer_Nombre AS first_name, Segundo_Nombre AS middle_name, Primer_Apellido AS first_last, Segundo_Apellido AS second_last, ba.Abreviacion AS neighbor,oc.Fecha_Visita AS visit_date, NoID, No_Conexiones AS extens, count(oc.Fecha) AS month_to_pay, ec.Nombre AS payment_status,SUM(CantidadPagar) AS total, s.Nombre AS service FROM cliente_natural cn,barriocolonia ba, cliente cl, contrato con, orden_cobro oc, estado_cobro ec, estado_pago_cliente ep, servicio s WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia AND oc.CONTRATO_IDContrato = IDContrato AND ec.ID = oc.ESTADO_COBRO_ID AND ep.ID=oc.ESTADO_PAGO_CLIENTE_ID AND oc.Fecha < CURDATE() AND Fecha_Pagada IS NULL AND con.SERVICIO_ID=s.ID AND ESTADO_GENERAL_CLIENTE_ID != (SELECT ID FROM estado_general_cliente WHERE Nombre = 'INACTIVO') GROUP BY  IDClient, IDOrder, IDContract, first_name, middle_name, first_last, second_last, neighbor, visit_date, NoID, extens, payment_status, service";

	connection.query(query, function(err, rows, fields) {
		if (!err) {
			return res.json(rows);
		} else {
			return res.status(500).send("Error in getNaturalCustomers " + JSON.stringify(err));
		}

	});
});
app.get('/get_bill_details', function(req, res) {
	var customerID = req.query.customerID;

	if (customerID !== undefined || customerID !== null) {
		var query = " SELECT oc.IDOrdenCobro AS ID, oc.Fecha AS bill_date, month(oc.Fecha) AS month, ep.Nombre AS payment_status, oc.CantidadPagar AS total FROM orden_cobro AS oc JOIN (contrato AS con, estado_pago_cliente AS ep) ON (oc.CONTRATO_IDContrato = con.IDContrato AND oc.ESTADO_PAGO_CLIENTE_ID = ep.ID) WHERE con.CLIENTE_idCLIENTE = ?";

		connection.query(query, [customerID], function(err, rows, fields) {
			if (!err) {
				return res.json(rows);
			} else {
				return res.send("Error in getBillDetails " + JSON.stringify(err));
			}

		});
	} else {
		return res.status(500).send('MIssing customerID parameter');
	}
});
app.put('/update_order_status', function(req, res) {
	var contractID = req.query.contractID;
	var status = req.query.status;
	var userID = req.query.userID

	if ((contractID !== undefined || contractID !== null) && (status !== undefined || status !== null) && (userID !== undefined || userID !== null)) {
		var query = "UPDATE `sccdb`.`orden_cobro` SET `IDUsuario` = ?, `ESTADO_PAGO_CLIENTE_ID` = ?, `Fecha_Visita` =  current_date() WHERE `CONTRATO_IDContrato` = ?";

		connection.query(query, [userID, status, contractID], function(err, rows, fields) {
			if (!err) {
				return res.json({
					success: true
				});
			} else {
				return res.send("Error in updateOrderStatus " + JSON.stringify(err));
			}

		});
	} else {
		return res.status(500).send('MIssing parameters: contractID, status, userID');
	}
});
app.put('/update_order_visit_date', function(req, res) {
	var contractID = req.query.contractID;
	var visitDate = req.query.visitDate;
	var userID = req.query.userID

	if ((contractID !== undefined || contractID !== null) && (userID !== undefined || userID !== null) && (visitDate !== undefined || visitDate !== null)) {
		var query = "UPDATE `sccdb`.`orden_cobro` SET `IDUsuario` = ?,  `Fecha_Visita` =  ? WHERE `CONTRATO_IDContrato` = ?";

		connection.query(query, [userID, visitDate, contractID], function(err, rows, fields) {
			if (!err) {
				return res.json({
					success: true
				});
			} else {
				return res.send("Error in updateOrderVisitDate " + JSON.stringify(err));
			}

		});
	} else {
		return res.status(500).send('MIssing parameters: contractID, visitDate, userID');
	}
});
app.post('/process_payment', function(req, res) {
	var contractID = req.query.contractID;
	var discount = req.query.discount;
	var userID = req.query.userID;
	var amountPaid = req.query.amountPaid;
	var numFact = req.query.numFact;

	if ((contractID !== undefined || contractID !== null) && (userID !== undefined || userID !== null) && (discount !== undefined || discount !== null) && (amountPaid !== undefined || amountPaid !== null) && (numFact !== undefined || numFact !== null) ) {
		var query = "CALL processPayment(?,?,?,?,?)";

		connection.query(query, [contractID, amountPaid, discount, numFact, userID], function(err, rows, fields) {
			if (!err) {
				return res.json({
					success: true
				});
			} else {
				return res.send("Error in processPayment " + JSON.stringify(err));
			}

		});
	} else {
		return res.status(500).send('MIssing parameters: contractID, discount, amountPaid, userID,numFact');
	}
});


//CUSTOMER LIST
app.get('/get_customer_cn', function(req, res) {
	var query = "SELECT cn.IDCliente as ID,Primer_Nombre as first_name, Segundo_Nombre as middle_name, Primer_Apellido as first_last, Segundo_Apellido second_last,NoID as ident, id.Tipo as id_type, ba.Abreviacion as neighbor,  eg.Nombre as customer_status, IDContrato as contract, con.No_Conexiones as extens, s.Nombre as service, con.Fecha as inst_date FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg,  servicio s, identificacion id WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia AND cn.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID AND cn.IDENTIFICACION_ID = id.ID  ORDER BY (Primer_Nombre)";

	connection.query(query, function(err, rows, fields) {
		if (!err) {
			return res.json(rows);q
		} else {
			return res.status(500).send("Error in getNaturalCustomers " + JSON.stringify(err));
		}

	});
});
app.get('/get_customer_cj', function(req, res) {
	var query = " SELECT cj.IDCliente as ID,Nombre_Empresa as company_name, Representante as representant, Cargo as position, NoID as ident, id.Tipo as id_type, Fax,ba.Abreviacion as neighbor, IDContrato as contract, con.No_Conexiones as extens, eg.Nombre as customer_status, s.Nombre as service, con.Fecha as inst_date FROM cliente_juridico cj,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg, servicio s, identificacion id WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia AND cj.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID AND cj.IDENTIFICACION_ID = id.ID  ORDER BY (company_name)";

	connection.query(query, function(err, rows, fields) {
		if (!err) {
			return res.json(rows);
		} else {
			return res.status(500).send("Error in getNaturalCustomers " + JSON.stringify(err));
		}

	});
});

app.post('/create_customer', function(req, res) {
	var params = [req.query.first_name, req.query.middle_name, req.query.first_last, req.query.second_last, req.query.address, req.query.tel, req.query.email, req.query.obs, req.query.ident, req.query.NoID, req.query.neighbor, req.query.userID, req.query.personality, req.query.service, req.query.extens];
	var query = "CALL createCustomer(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	connection.query(query, params, function(err, rows, fields) {
		if (!err) {
			return res.json({
				success: true
			});
		} else {
			return res.status(500).send("Error in create_customer " + JSON.stringify(err));
		}

	});
});

app.post('/authentication', function(req, res) {
	var user = req.query.user;
	var pass = req.query.password;

	if (user && pass) {
		var query = "SELECT convert(Password USING utf8) as password, Nombre as name, Usuario as user, ROL_IDRol as role, IDUsuario as Id FROM usuario WHERE  Usuario = ?";

		connection.query(query, [user], function(err, rows, fields) {
			if (!err) {
				if (rows[0].password === pass) {
					delete rows[0].password;
					return res.json(rows);
				} else {
					//Error 1 for pass not matching
					return res.json({
						error: 1
					});
				}
			} else {
				return res.send("Error in getPersonalityIds " + JSON.stringify(err));
			}

		});
	} else {
		return res.status(500).send('MIssing parameters');
	}
});

http.listen(3000, function() {
	console.log('Listening on port 3000');
});
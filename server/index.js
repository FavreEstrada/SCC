var express = require('express');
var app = express();
var http = require('http').Server(app);
var path = require('path');

var pg = require('pg');
var connectionString = process.env.DATABASE_URL || require(path.join(__dirname, '../', '../', 'config'));
var client = new pg.Client(connectionString);
client.connect();

app.post('/sendCommand', function(req, res) {
	var jsonString = "";
	var dataObj;
	req.on('data', function(data) {
		jsonString += data;
	});
	req.on('end', function() {
		dataObj = JSON.parse(jsonString);
		var response = sendResponse(dataObj.command);
	});

	var query = client.query('CREATE TABLE items(id SERIAL PRIMARY KEY, text VARCHAR(40) not null, complete BOOLEAN)');

	query.on('end', function() {
		client.end();
		return res.json();
	});
});

app.get('/testEndpoint', function(req, res) {
	return res.json("successful connection");
});

app.post("/successPair", function(req, res) {
	var jsonString = "";
	var dataObj;
	req.on('data', function(data) {
		jsonString += data;
	});
	req.on('end', function() {
		dataObj = JSON.parse(jsonString);
		var response = {};
		response.action = "paired";
	});
});

http.listen(3000, function() {
	console.log('Listening on port 3000');
});

function sendResponse(command) {
	var response = {
		action: {},
		parameters: {}
	};
	return response;

}
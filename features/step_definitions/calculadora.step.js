const { Given, When, Then } = require('@cucumber/cucumber');
const { DriverHTTP } = require('../../HTTPDriver/DriverHttp');
const assert = require('assert');
const { REFUSED } = require('dns');

let driver;
let response;
let error;

Given('Eu tenho um DriverHTTP inicializado', function () {
    driver = new DriverHTTP();
});

When('Eu faco uma requisição POST para o endpoint {string}', 
    async function (endpoint, dataTable) {
      try {
        const body = JSON.parse(dataTable.hashes()[0].BODY);
        response = await driver.POST(endpoint, body);        
      } catch (err) {
        error = err;
        console.error('Erro na requisição:', err);
      }
  });

Then('O corpo da resposta deve conter', 
    async function (dataTable) {                      
      const expected = JSON.parse(dataTable.hashes()[0].RESPOSTA);        
      assert.deepStrictEqual(response, expected);      
});
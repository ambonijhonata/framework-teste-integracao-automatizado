const { Before, Given, When, Then } = require('@cucumber/cucumber');
const { DriverHTTP } = require('../../HTTPDriver/DriverHttp');
const assert = require('assert');

let driver = new DriverHTTP();;
let response;
let status;
let error;

Before(function() {
    driver = new DriverHTTP(); // Reinicia o driver para cada teste
    response = null;
    status = null;
    error = null;
});

Given('Eu realizo o login com o usuario', 
    async function (dataTable) {
        const endpointLogin = 'users/login';
        const email = dataTable.hashes()[0].EMAIL;
        const senha = dataTable.hashes()[0].SENHA;

        const body = {
          "email": email,
          "password": senha
        };                

        response = await driver.POST(endpointLogin, body);
        driver.setToken(response.token);        
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

When('Eu faco uma requisição GET para o endpoint {string}',
    async function (endpoint) {
      try {
        const endpointReturn = await driver.GET(endpoint);
        response = endpointReturn.data;
        status = endpointReturn.status;        
      } catch (err) {
        error = err;
        console.error('Erro na requisição:', err);
      }
});

Then('A resposta deve conter o status {int}', 
    function (statusCode) {
      if (error) {
        assert.fail(`Erro na requisição: ${error.message}`);
      } else {                
        assert.strictEqual(statusCode, status);
      }
});

Then('O corpo da resposta deve conter', 
    async function (dataTable) {                      
      const expected = JSON.parse(dataTable.hashes()[0].RESPOSTA);      

      assert.deepStrictEqual(response, expected);      
});
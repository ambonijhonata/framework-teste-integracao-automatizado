const { Before, Given, When, Then } = require('@cucumber/cucumber');
const { DriverHTTP } = require('../../HTTPDriver/DriverHttp');
const assert = require('assert');
const { get } = require('http');

let driver = new DriverHTTP();;
let response;
let status;
let error;
let variables;

Before(function() {
    driver = new DriverHTTP(); // Reinicia o driver para cada teste
    response = null;
    status = null;
    error = null;
    variables = new Map();
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
        driver.setToken(response.data.token);        
});

When('Eu faco uma requisição DELETE para o endpoint {string}', 
    async function (endpoint) {
      try {
        console.log("Endpoint antes do replace: " + endpoint);
        endpoint = replaceVariablesEndpoint(endpoint);
        console.log("Endpoint depois do replace: " + endpoint);
        const endpointReturn = await driver.DELETE(endpoint);
        response = endpointReturn.data;
        status = endpointReturn.status;        
      } catch (err) {
        error = err;
        console.error('Erro na requisição:', err);
      }
});

When('Eu faco uma requisição DELETE para o endpoint {string} se a variavel {string} existir', 
    async function (endpoint, variavel) {
      
        const variavelExiste = variables.has(variavel);        
        if(variavelExiste) {
          try {
            console.log("Endpoint antes do replace: " + endpoint);
            endpoint = replaceVariablesEndpoint(endpoint);
            console.log("Endpoint depois do replace: " + endpoint);
            const endpointReturn = await driver.DELETE(endpoint);
            response = endpointReturn.data;
            status = endpointReturn.status;        
          } catch (err) {
            error = err;
            console.error('Erro na requisição:', err);
          }
        }
        
});

When('Eu faco uma requisição POST para o endpoint {string}', 
    async function (endpoint, dataTable) {
      try {

        let body = JSON.parse(dataTable.hashes()[0].BODY);
        console.log("body sem replace: " + JSON.stringify(body));
        body = replaceVariables(body);
        console.log("body sem replace: " + JSON.stringify(body));

        const endpointReturn  = await driver.POST(endpoint, body);       
        response = endpointReturn.data;
        status = endpointReturn.status;   
      } catch (err) {
        error = err;
        console.error('Erro na requisição:', err);
      }
  });

When('Eu faco uma requisição POST para o endpoint {string} se a variavel {string} nao existir', 
    async function (endpoint, variavel, dataTable) {
      try {

        const variavelExiste = variables.has(variavel);
        console.log("POST Variavel existe: " + variavelExiste);
        if(!variavelExiste) {
          let body = JSON.parse(dataTable.hashes()[0].BODY);
          console.log("body sem replace: " + JSON.stringify(body));
          body = replaceVariables(body);
          console.log("body sem replace: " + JSON.stringify(body));

          const endpointReturn  = await driver.POST(endpoint, body);       
          response = endpointReturn.data;
          status = endpointReturn.status;  
        }
         
      } catch (err) {
        error = err;
        console.error('Erro na requisição:', err);
      }
  });

When('Eu faco uma requisição PUT para o endpoint {string}', 
    async function (endpoint, dataTable) {
      try {        
        let body = JSON.parse(dataTable.hashes()[0].BODY);        
        endpoint = replaceVariablesEndpoint(endpoint);
        console.log('ENDPOINT PUT: ' + endpoint)
        const endpointReturn  = await driver.PUT(endpoint, body);       
        response = endpointReturn.data;
        status = endpointReturn.status;   
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

When('Armazeno o valor do campo {string} da resposta em uma variavel chamada {string}',
  async function (jsonPath, variableName) {
      const retorno = getValueByJsonPath(jsonPath, response);
      console.log(`Valor encontrado no JSONPath ${jsonPath}:`, retorno);
      if(retorno){
        variables.set(variableName, retorno);
        console.log(`Valor armazenado na variável ${variableName}:`, retorno);  
      }      
  }
)

Then('A resposta deve conter o status {int}', 
    function (statusCode) {  
      
      console.log(`Status esperado: ${statusCode}`);
      console.log(`Status retornado: ${status}`);
      if (error) {
        assert.fail(`Erro na requisição: ${error.message}`);
      } else {                
        assert.strictEqual(statusCode, status);
      }
});

Then('O corpo da resposta deve conter', 
    async function (dataTable) {                

      let expected = JSON.parse(dataTable.hashes()[0].RESPOSTA);            
      expected = replaceVariables(expected);

      console.log("Resposta esperada: " + JSON.stringify(expected));
      console.log("Resposta retornada: " + JSON.stringify(response));
      assert.deepStrictEqual(response, expected);      
});

Then('O corpo da resposta nao deve conter', 
    async function (dataTable) {                

      let notExpected = JSON.parse(dataTable.hashes()[0].RESPOSTA);            
      notExpected = replaceVariables(notExpected);

      console.log("Resposta esperada: " + JSON.stringify(notExpected));
      console.log("Resposta retornada: " + JSON.stringify(response));
      
      // Verifica se notExpected está contido em response
      const responseStr = JSON.stringify(response);
      const notExpectedStr = JSON.stringify(notExpected);

      if (responseStr.includes(notExpectedStr)) {
        assert.fail(`A resposta contém o valor não esperado: ${notExpectedStr}`);
      }   
});

function getValueByJsonPath(jsonPath, jsonData) {    
    if (jsonPath.startsWith('$')) {
        jsonPath = jsonPath.substring(1);
    }
        
    const pathParts = jsonPath.split(/\.|\[|\]/).filter(part => part !== '');
    
    let current = jsonData;
    
    for (const part of pathParts) {
        if (current === null || current === undefined) {
            return undefined;
        }
                
        if (!isNaN(part)) {
            const index = parseInt(part, 10);
            if (Array.isArray(current) && index >= 0 && index < current.length) {
                current = current[index];
            } else {
                return undefined;
            }
        } else {            
            if (current.hasOwnProperty(part)) {
                current = current[part];
            } else {
                return undefined;
            }
        }
    }
    
    return current;
}

function replaceVariables(json) {    
    const result = Array.isArray(json) ? [...json] : { ...json };
    
    function processValue(value) {
        if (typeof value === 'string') {
            const regex = /\{([^}]+)\}/g;
            // Se a string for exatamente uma variável, retorna o valor convertido
            if (value.match(/^(\{[^}]+\})$/)) {
                const varName = value.slice(1, -1);
                if (variables.has(varName)) {
                    const variableValue = variables.get(varName);
                    // Se for número, retorna como número
                    if (!isNaN(variableValue) && variableValue !== '') {
                        return Number(variableValue);
                    }
                    return variableValue;
                }
                return value;
            }
            // Substitui variáveis dentro de strings maiores normalmente
            return value.replace(regex, (match, varName) => {
                return variables.has(varName) ? variables.get(varName) : match;
            });
        } else if (Array.isArray(value)) {
            return value.map(processValue);
        } else if (typeof value === 'object' && value !== null) {
            const newObj = {};
            for (const key in value) {
                newObj[key] = processValue(value[key]);
            }
            return newObj;
        }
        return value;
    }
    
    return processValue(result);
}

function replaceVariablesEndpoint(endpoint) {
    return endpoint.replace(/\{([^}]+)\}/g, (match, varName) => 
        variables.has(varName) ? variables.get(varName) : match
    );
}
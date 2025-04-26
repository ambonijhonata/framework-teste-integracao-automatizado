Feature: Testes da Calculadora via HTTP

  Scenario: Fazer uma soma via POST
    Given Eu tenho um DriverHTTP inicializado
     When Eu faco uma requisição POST para o endpoint 'api/somar'
      | BODY                |
      | { "a": 20, "b": 2 } |
     Then O corpo da resposta deve conter
      | RESPOSTA          |
      | {"resultado": 22} |

Scenario: Fazer uma subtracao via POST
    Given Eu tenho um DriverHTTP inicializado
     When Eu faco uma requisição POST para o endpoint 'api/subtrair'
      | BODY                |
      | { "a": 20, "b": 2 } |
     Then O corpo da resposta deve conter
      | RESPOSTA          |
      | {"resultado": 18} |      

Scenario: Fazer uma multiplicacao via POST
    Given Eu tenho um DriverHTTP inicializado
     When Eu faco uma requisição POST para o endpoint 'api/multiplicar'
      | BODY                |
      | { "a": 20, "b": 2 } |
     Then O corpo da resposta deve conter
      | RESPOSTA          |
      | {"resultado": 40} |     

Scenario: Fazer uma divisao via POST
    Given Eu tenho um DriverHTTP inicializado
     When Eu faco uma requisição POST para o endpoint 'api/dividir'
      | BODY                |
      | { "a": 20, "b": 2 } |
     Then O corpo da resposta deve conter
      | RESPOSTA          |
      | {"resultado": 10} |                   
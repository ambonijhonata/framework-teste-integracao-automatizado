Feature: Testes da Calculadora via HTTP

Scenario: Listar clientes   
  Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
  When Eu faco uma requisição GET para o endpoint 'api/cliente'
  Then A resposta deve conter o status 200      
   And O corpo da resposta deve conter
      | RESPOSTA                                                                                  |
      | [{"codigo": 4,"nome": "Michela Graciano"},{"codigo": 6, "nome": "Jhonata Vieira Amboni"}] |

Scenario: Listar cliente pelo nome
  Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
  When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=jhonata'
  Then A resposta deve conter o status 200      
   And O corpo da resposta deve conter
      | RESPOSTA                                         |
      | [{"codigo": 6, "nome": "Jhonata Vieira Amboni"}] |

Scenario: Cadastrar cliente
  Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
  When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=jhonata'
   And Armazeno o valor do campo 'codigo' do primeiro item da resposta em uma variavel chamada 'codigo'
   And Eu faco uma requisição POST para o endpoint 'api/cliente'
      | BODY                                |
      | {"nome": "Teste Cadastrar Cliente"} |
  Then A resposta deve conter o status 200      
   And O corpo da resposta deve conter
      | RESPOSTA                                         |
      | [{"codigo": 6, "nome": "Jhonata Vieira Amboni"}] |      
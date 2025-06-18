Feature: Testes da Calculadora via HTTP

 Scenario: Listar cliente pelo nome
  Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
  When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=michela'
  Then A resposta deve conter o status 200      
   And O corpo da resposta deve conter
      | RESPOSTA                                    |
      | [{"codigo": 4, "nome": "Michela Graciano"}] |

Scenario: Cadastrar cliente
  Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
  When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=Teste cadastro'
   And Armazeno o valor do campo '$[0].codigo' da resposta em uma variavel chamada 'codigo'
   And Eu faco uma requisição DELETE para o endpoint 'api/cliente/{codigo}' se a variavel 'codigo' existir     
   And Eu faco uma requisição POST para o endpoint 'api/cliente'
      | BODY                       |
      | {"nome": "Teste cadastro"} |
   And Armazeno o valor do campo '$.codigo' da resposta em uma variavel chamada 'codigoCadastrado'
  Then A resposta deve conter o status 200
  When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=Teste cadastro'
  Then A resposta deve conter o status 200   
   And O corpo da resposta deve conter
      | RESPOSTA                                                     |
      | [{"codigo": "{codigoCadastrado}", "nome": "Teste cadastro"}] |

Scenario: Atualizar cliente
  Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
   When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=Teste edicao'
    And Armazeno o valor do campo '$[0].codigo' da resposta em uma variavel chamada 'codigo'
    And Eu faco uma requisição DELETE para o endpoint 'api/cliente/{codigo}' se a variavel 'codigo' existir     
    And Eu faco uma requisição POST para o endpoint 'api/cliente'
      | BODY                     |
      | {"nome": "Teste edicao"} |
   And Armazeno o valor do campo '$.codigo' da resposta em uma variavel chamada 'codigoCadastrado'
   And Eu faco uma requisição PUT para o endpoint 'api/cliente/{codigoCadastrado}'
      | BODY                                |
      | {"nome": "Teste edicao atualizado"} |
  Then A resposta deve conter o status 200
  When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=Teste edicao'
  Then O corpo da resposta deve conter
      | RESPOSTA                                                              |
      | [{"codigo": "{codigoCadastrado}", "nome": "Teste edicao atualizado"}] |

Scenario: Excluir cliente
    Given Eu realizo o login com o usuario
        | EMAIL           | SENHA    |
        | email@gmail.com | senha123 |
    When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=Teste exclusao'
     And Armazeno o valor do campo '$[0].codigo' da resposta em uma variavel chamada 'codigo'
     And Eu faco uma requisição POST para o endpoint 'api/cliente' se a variavel 'codigo' nao existir
        | BODY                       |
        | {"nome": "Teste exclusao"} |
    When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=Teste exclusao'
     And Armazeno o valor do campo '$[0].codigo' da resposta em uma variavel chamada 'codigo'
     And Eu faco uma requisição DELETE para o endpoint 'api/cliente/{codigo}'
    Then A resposta deve conter o status 204
    When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=Teste exclusao'
    Then O corpo da resposta nao deve conter
       | RESPOSTA                                         |
       | {"codigo": "{codigo}", "nome": "Teste exclusao"} |
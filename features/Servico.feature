Feature: Servico

  Scenario: Listar Servico pelo nome
    Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
    When Eu faco uma requisição GET para o endpoint 'api/servico?nome=dep'
    Then A resposta deve conter o status 200
    And O corpo da resposta deve conter
      | RESPOSTA                                                              |
      | [{"id": 1,"nome": "Depilação buço","descricao": null,"valor": 55.99}] |

  Scenario: Cadastrar Servico
    Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
    When Eu faco uma requisição GET para o endpoint 'api/servico?nome=Servico teste'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigo'
    And Eu faco uma requisição DELETE para o endpoint 'api/servico/{codigo}' se a variavel 'codigo' existir
    And Eu faco uma requisição POST para o endpoint 'api/servico'
      | BODY                                                                      |
      | {"nome": "Servico teste", "descricao": "Descricao teste", "valor": 45.99} |
    And Armazeno o valor do campo '$.id' da resposta em uma variavel chamada 'codigoCadastrado'
    Then A resposta deve conter o status 200
    When Eu faco uma requisição GET para o endpoint 'api/servico?nome=Servico teste'
    Then A resposta deve conter o status 200
    And O corpo da resposta deve conter
      | RESPOSTA                                                                                             |
      | [{"id": "{codigoCadastrado}","nome": "Servico teste","descricao": "Descricao teste","valor": 45.99}] |

  Scenario: Excluir Servico
    Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
    When Eu faco uma requisição GET para o endpoint 'api/servico?nome=Servico excluir'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigo'
    And Eu faco uma requisição POST para o endpoint 'api/servico' se a variavel 'codigo' nao existir
      | BODY                                                                          |
      | {"nome": "Servico excluir", "descricao": "Descricao excluir", "valor": 45.99} |
    And Eu faco uma requisição GET para o endpoint 'api/servico?nome=Servico excluir'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigo'
    And Eu faco uma requisição DELETE para o endpoint 'api/servico/{codigo}'
    Then A resposta deve conter o status 204
    When Eu faco uma requisição GET para o endpoint 'api/servico?nome=Servico excluir'
    Then O corpo da resposta deve conter
      | RESPOSTA |
      | []       |

Scenario: Atualizar Servico
    Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
    When Eu faco uma requisição GET para o endpoint 'api/servico?nome=Servico editar'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigo'
    And Eu faco uma requisição DELETE para o endpoint 'api/servico/{codigo}' se a variavel 'codigo' existir
    And Eu faco uma requisição POST para o endpoint 'api/servico'
      | BODY                                                                          |
      | {"nome": "Servico editar", "descricao": "Descricao editar", "valor": 45.99} |
    And Armazeno o valor do campo '$.id' da resposta em uma variavel chamada 'codigoCadastrado'
    And Eu faco uma requisição PUT para o endpoint 'api/servico/{codigoCadastrado}'
      | BODY                                                                                   |
      | {"nome": "Servico editar atualizado", "descricao": "Descricao editar atualizada", "valor": 55.99} |
    Then A resposta deve conter o status 200
    When Eu faco uma requisição GET para o endpoint 'api/servico?nome=Servico editar'
    Then O corpo da resposta deve conter
      | RESPOSTA                                                                                                      |
      | [{"id": "{codigoCadastrado}","nome": "Servico editar atualizado","descricao": "Descricao editar atualizada","valor": 55.99}] |  
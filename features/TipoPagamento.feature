Feature: Tipo-pagamento

  Scenario: Listar todos tipos de pagamento
    Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
    When Eu faco uma requisição GET para o endpoint 'api/tipo-pagamento'
    Then A resposta deve conter o status 200
    And O corpo da resposta deve conter
      | RESPOSTA                                                                                                                                                                                                  |
      | [{"id": 1,"descricao": "Cartão de débito","taxa": 5.00},{"id": 2,"descricao": "Cartão de crédito","taxa": 5.00},{"id": 3,"descricao": "Pix","taxa": null},{"id": 4,"descricao": "Dinheiro","taxa": null}] |

  Scenario: Listar tipo de pagamento pela descricao
    Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
    When Eu faco uma requisição GET para o endpoint 'api/tipo-pagamento?descricao=Cartão de crédito'
    Then A resposta deve conter o status 200
    And O corpo da resposta deve conter
      | RESPOSTA                                                  |
      | [{"id": 2,"descricao": "Cartão de crédito","taxa": 5.00}] |

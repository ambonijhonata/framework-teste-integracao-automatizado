Feature: Agendamento

  Scenario: Listar agendamentos pelo cliente
    Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
    When Eu faco uma requisição GET para o endpoint 'api/agendamento?cliente=4'
    Then A resposta deve conter o status 200
    And O corpo da resposta deve conter
      | RESPOSTA                                                                                                                                                                                                                                                                                                                                                                                            |
      | [{"id": 6,"cliente": {"codigo": 4,"nome": "Michela Graciano"},"dataInicioAgendamento": "2025-06-10T15:00:00","dataFimAgendamento": "2024-06-10T15:30:00","tipoPagamento": {"id": 2,"descricao": "Cartão de crédito","taxa": 5.00},"servicos": [{"id": 1,"nome": "Depilação buço","descricao": null,"valor": 55.99},{"id": 2,"nome": "Design sobrancelha","descricao": "Com hena","valor": 55.99}]}] |

  Scenario: Cadastrar agendamento
    Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
    When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=jhon'
    And Armazeno o valor do campo '$[0].codigo' da resposta em uma variavel chamada 'codigoCliente'
    And Eu faco uma requisição GET para o endpoint 'api/agendamento?cliente=190'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigoAgendamento'
    And Eu faco uma requisição DELETE para o endpoint 'api/agendamento/{codigoAgendamento}' se a variavel 'codigoAgendamento' existir
    And Eu faco uma requisição GET para o endpoint 'api/tipo-pagamento?descricao=pix'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigoTipoPagamento'
    And Eu faco uma requisição GET para o endpoint 'api/servico?nome=Depilação buço'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigoServico1'
    And Eu faco uma requisição GET para o endpoint 'api/servico?nome=Design sobrancelha'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigoServico2'
    And Eu faco uma requisição POST para o endpoint 'api/agendamento'
      | BODY                                                                                                                                                                                                                        |
      | {"idCliente": "{codigoCliente}","idTipoPagamento": "{codigoTipoPagamento}","dataInicioAgendamento": "2025-06-10T15:00:00","dataFimAgendamento": "2024-06-10T15:30:00","servicos": ["{codigoServico1}", "{codigoServico2}"]} |
    Then A resposta deve conter o status 201
    When Armazeno o valor do campo '$.id' da resposta em uma variavel chamada 'codigoAgendamentoCadastrado'
    And Eu faco uma requisição GET para o endpoint 'api/agendamento?cliente={codigoCliente}'
    Then A resposta deve conter o status 200
    Then O corpo da resposta deve conter
      | RESPOSTA                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | [{"id": "{codigoAgendamentoCadastrado}","cliente": {"codigo": "{codigoCliente}","nome": "Jhonata"},"dataInicioAgendamento": "2025-06-10T15:00:00","dataFimAgendamento": "2024-06-10T15:30:00","tipoPagamento": {"id": "{codigoTipoPagamento}","descricao": "Pix","taxa": null},"servicos": [{"id": "{codigoServico1}","nome": "Depilação buço","descricao": null,"valor": 55.99},{"id": "{codigoServico2}","nome": "Design sobrancelha","descricao": "Com hena","valor": 55.99}]}] |

@specifico
Scenario: Excluir agendamento
    Given Eu realizo o login com o usuario
      | EMAIL           | SENHA    |
      | email@gmail.com | senha123 |
    When Eu faco uma requisição GET para o endpoint 'api/cliente?nome=Excluir agendamento'
    And Armazeno o valor do campo '$[0].codigo' da resposta em uma variavel chamada 'codigoCliente'
    When Eu faco uma requisição GET para o endpoint 'api/agendamento?cliente={codigoCliente}'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigoAgendamento'
    And Eu faco uma requisição DELETE para o endpoint 'api/agendamento/{codigoAgendamento}' se a variavel 'codigoAgendamento' existir    
    When Eu faco uma requisição GET para o endpoint 'api/agendamento?cliente={codigoCliente}'
    Then O corpo da resposta deve conter
      | RESPOSTA |
      | []       |
    And Eu faco uma requisição GET para o endpoint 'api/tipo-pagamento?descricao=pix'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigoTipoPagamento'
    And Eu faco uma requisição GET para o endpoint 'api/servico?nome=Depilação buço'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigoServico1'
    And Eu faco uma requisição GET para o endpoint 'api/servico?nome=Design sobrancelha'
    And Armazeno o valor do campo '$[0].id' da resposta em uma variavel chamada 'codigoServico2'
    And Eu faco uma requisição POST para o endpoint 'api/agendamento'
      | BODY                                                                                                                                                                                                                        |
      | {"idCliente": "{codigoCliente}","idTipoPagamento": "{codigoTipoPagamento}","dataInicioAgendamento": "2025-06-10T15:00:00","dataFimAgendamento": "2024-06-10T15:30:00","servicos": ["{codigoServico1}", "{codigoServico2}"]} |
    Then A resposta deve conter o status 201
    When Armazeno o valor do campo '$.id' da resposta em uma variavel chamada 'codigoAgendamentoCadastrado'
    When Eu faco uma requisição GET para o endpoint 'api/agendamento?cliente={codigoCliente}'
    Then O corpo da resposta deve conter
      | RESPOSTA                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | [{"id": "{codigoAgendamentoCadastrado}","cliente": {"codigo": "{codigoCliente}","nome": "Excluir agendamento"},"dataInicioAgendamento": "2025-06-10T15:00:00","dataFimAgendamento": "2024-06-10T15:30:00","tipoPagamento": {"id": "{codigoTipoPagamento}","descricao": "Pix","taxa": null},"servicos": [{"id": "{codigoServico1}","nome": "Depilação buço","descricao": null,"valor": 55.99},{"id": "{codigoServico2}","nome": "Design sobrancelha","descricao": "Com hena","valor": 55.99}]}] |
    When Eu faco uma requisição DELETE para o endpoint 'api/agendamento/{codigoAgendamentoCadastrado}'
    Then A resposta deve conter o status 204
    When Eu faco uma requisição GET para o endpoint 'api/agendamento?cliente={codigoCliente}'    
    Then O corpo da resposta deve conter
      | RESPOSTA |
      | []       |
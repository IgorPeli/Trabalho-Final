## O script SQL 
### Nesse repartimento há o script SQL implementado no SGBD Postgre

# Banco de Dados e Usuário Administrador

Este código contém um conjunto de instruções SQL para criar um banco de dados e um usuário administrador no PostgreSQL. O banco de dados chamado "university" é criado com o usuário "administrator" como proprietário. Além disso, são definidas tabelas e relacionamentos para um sistema acadêmico.  

## Criação do Usuário Administrador

O primeiro passo é criar o usuário administrador chamado "administrator". Ele terá privilégios especiais, como criar, alterar e apagar o banco de dados e seus usuários. O usuário será configurado com uma senha "syslogadm".  

## Criação do Banco de Dados

Em seguida, o banco de dados "university" é criado utilizando o usuário administrador "administrator" como proprietário. O banco de dados utiliza a codificação UTF8 e tem as configurações de collate e ctype definidas como "pt_BR.UTF8", para estabelecer o padrão da língua portuguesa.  
## Conexão ao Banco e Criação do Schema

Após a criação do banco de dados, é feita a conexão ao banco "university" utilizando as credenciais do usuário administrador. Em seguida, é criado o schema "academic_system" dentro do banco de dados. Esse schema será responsável por armazenar as tabelas e relacionamentos do sistema acadêmico.  
## Criação de Tabelas e Relacionamentos

A partir desse ponto, são criadas várias tabelas e seus respectivos relacionamentos para o sistema acadêmico. As tabelas incluem:

   - "endereco": armazena informações de endereços, como CEP, UF, cidade, bairro, complemento, número e logradouro.
   - "obras": guarda informações sobre obras, como código da obra, editora, tipo (CD, DVD, REVISTA, LIVRO), nome e nome do autor.
   - "nome_autor": tabela de suporte para o atributo multivalorado "nome_autor" da tabela "obras".
   - "volumes": armazena informações sobre os volumes das obras disponíveis, com seus respectivos códigos, ano de publicação e edição.
   - "pessoas": contém informações-chave das pessoas que utilizam o sistema acadêmico, como CPF, telefone, nome completo, email e data de cadastro.
   - "telefone": tabela de suporte para o atributo multivalorado "telefone" da tabela "pessoas".
   - "reservas": registra as reservas de obras, com informações como CPF da pessoa, data de início da reserva, código da obra e código do volume.
   - "emprestimos": registra os empréstimos de obras, com informações como data de início do empréstimo, CPF da pessoa, código do volume e código da obra.
   - "professores": armazena informações sobre a formação acadêmica dos professores, como CPF da pessoa, graduação e pós-graduação.
   - "pos_graduacao": tabela de suporte para o atributo multivalorado "pos_graduacao" da tabela "professores".
   - "graduacao": tabela de suporte para o atributo multivalorado "graduacao" da tabela "professores".
   - "alunos": guarda informações sobre os alunos matriculados, com dados como CPF da pessoa e matrícula.
   - "ofertas": registra as ofertas de disciplinas para os alunos, com informações como código da oferta, CPF da pessoa (professor responsável), semestre, quantidade mínima e máxima de alunos.
   - "matriculam_se_em": tabela de relacionamento entre as tabelas "alunos" e "ofertas".
   - "disciplinas": armazena informações sobre as disciplinas dos cursos, como código da disciplina, nome, carga horária, ementa e conteúdo.
   - "envolvem": tabela de relacionamento entre as tabelas "ofertas" e "disciplinas".
   - "cursos": guarda informações sobre os cursos da instituição, com dados como código do curso, nome e data de início.
   - "fazem": tabela de relacionamento entre as tabelas "alunos" e "cursos".
   - "compoem": tabela de relacionamento entre as tabelas "disciplinas" e "cursos".

Após a criação das tabelas, são definidas as restrições de chave primária (PRIMARY KEY) e as restrições de chave estrangeira (FOREIGN KEY) para garantir a integridade dos dados e os relacionamentos entre as tabelas.  
## Considerações Finais

Este código SQL fornece a estrutura básica do banco de dados e as tabelas necessárias para um sistema acadêmico. É importante notar que o código pode ser expandido e modificado conforme as necessidades específicas do projeto.

Certifique-se de executar essas instruções SQL em um ambiente PostgreSQL adequado e ajustar as configurações conforme necessário.
